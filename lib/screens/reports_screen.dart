import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import '../utils/app_theme.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late int _selectedYear;

  static final _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '${AppConstants.currencySymbol} ',
    decimalDigits: 0,
  );

  static const _monthLabels = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final monthlyIncome = provider.getMonthlyIncome(_selectedYear);
        final monthlyExpenses = provider.getMonthlyExpenses(_selectedYear);
        final monthlySavings = provider.getMonthlySavings(_selectedYear);
        final now = DateTime.now();
        final categoryExpenses =
            provider.getCategoryExpenses(now.month, now.year);

        final yearIncome =
            monthlyIncome.values.fold(0.0, (sum, v) => sum + v);
        final yearExpenses =
            monthlyExpenses.values.fold(0.0, (sum, v) => sum + v);
        final yearSavings = yearIncome - yearExpenses;

        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Year Selector
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () =>
                              setState(() => _selectedYear--),
                          icon: const Icon(Icons.chevron_left),
                        ),
                        Text(
                          '$_selectedYear',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () =>
                              setState(() => _selectedYear++),
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Annual Summary
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryTile(
                        'Total Income',
                        yearIncome,
                        AppTheme.incomeColor,
                        Icons.arrow_downward,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSummaryTile(
                        'Total Expenses',
                        yearExpenses,
                        AppTheme.expenseColor,
                        Icons.arrow_upward,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSummaryTile(
                        'Net Savings',
                        yearSavings,
                        yearSavings >= 0
                            ? AppTheme.incomeColor
                            : AppTheme.expenseColor,
                        Icons.savings,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Monthly Income vs Expenses Bar Chart
                Text(
                  'Income vs Expenses',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                _buildChartLegend(),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      height: 220,
                      child: _buildBarChart(monthlyIncome, monthlyExpenses),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Savings Chart
                Text(
                  'Monthly Savings',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      height: 200,
                      child: _buildLineChart(monthlySavings),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Category-wise Pie Chart
                Text(
                  'Expense Breakdown (This Month)',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: categoryExpenses.isEmpty
                        ? const SizedBox(
                            height: 200,
                            child: Center(
                              child: Text('No expenses this month'),
                            ),
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height: 200,
                                child: _buildPieChart(categoryExpenses),
                              ),
                              const SizedBox(height: 16),
                              ...categoryExpenses.entries.map(
                                (entry) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: AppConstants.categoryColors[
                                                  entry.key] ??
                                              Colors.grey,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(child: Text(entry.key)),
                                      Text(
                                        _currencyFormat
                                            .format(entry.value),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                // Savings Summary
                Text(
                  'Savings Summary',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildSummaryRow('Annual Income', yearIncome,
                            AppTheme.incomeColor),
                        const Divider(),
                        _buildSummaryRow('Annual Expenses', yearExpenses,
                            AppTheme.expenseColor),
                        const Divider(),
                        _buildSummaryRow(
                          'Net Savings',
                          yearSavings,
                          yearSavings >= 0
                              ? AppTheme.incomeColor
                              : AppTheme.expenseColor,
                        ),
                        const Divider(),
                        _buildSummaryRow(
                          'Savings Rate',
                          yearIncome > 0
                              ? (yearSavings / yearIncome * 100)
                              : 0,
                          yearSavings >= 0
                              ? AppTheme.incomeColor
                              : AppTheme.expenseColor,
                          isPercentage: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryTile(
      String title, double amount, Color color, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                _currencyFormat.format(amount),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartLegend() {
    return Row(
      children: [
        Container(width: 12, height: 12, color: AppTheme.incomeColor),
        const SizedBox(width: 4),
        const Text('Income', style: TextStyle(fontSize: 12)),
        const SizedBox(width: 16),
        Container(width: 12, height: 12, color: AppTheme.expenseColor),
        const SizedBox(width: 4),
        const Text('Expenses', style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildBarChart(
      Map<int, double> incomeData, Map<int, double> expenseData) {
    final maxY = [...incomeData.values, ...expenseData.values]
        .fold(0.0, (max, v) => v > max ? v : max);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY > 0 ? maxY * 1.2 : 1000,
        barGroups: List.generate(12, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: incomeData[i + 1] ?? 0,
                color: AppTheme.incomeColor,
                width: 8,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
              BarChartRodData(
                toY: expenseData[i + 1] ?? 0,
                color: AppTheme.expenseColor,
                width: 8,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          );
        }),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                if (value.toInt() >= 0 && value.toInt() < 12) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _monthLabels[value.toInt()],
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
              reservedSize: 28,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, _) {
                if (value == 0) return const SizedBox.shrink();
                return Text(
                  _formatCompact(value),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY > 0 ? maxY / 4 : 250,
        ),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                _currencyFormat.format(rod.toY),
                TextStyle(
                  color: rod.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLineChart(Map<int, double> savingsData) {
    final maxY = savingsData.values
        .fold(0.0, (max, v) => v.abs() > max ? v.abs() : max);

    return LineChart(
      LineChartData(
        minY: -maxY * 1.2,
        maxY: maxY > 0 ? maxY * 1.2 : 1000,
        lineBarsData: [
          LineChartBarData(
            spots: savingsData.entries
                .map((e) => FlSpot(e.key.toDouble() - 1, e.value))
                .toList(),
            isCurved: true,
            color: AppTheme.primaryColor,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
            ),
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, _) {
                final idx = value.toInt();
                if (idx >= 0 && idx < 12) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _monthLabels[idx],
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
              reservedSize: 28,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, _) {
                return Text(
                  _formatCompact(value),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) {
              return spots.map((spot) {
                return LineTooltipItem(
                  _currencyFormat.format(spot.y),
                  const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart(Map<String, double> data) {
    final total = data.values.fold(0.0, (sum, v) => sum + v);

    return PieChart(
      PieChartData(
        sections: data.entries.map((entry) {
          final percentage = total > 0 ? (entry.value / total * 100) : 0.0;
          return PieChartSectionData(
            value: entry.value,
            title: '${percentage.toStringAsFixed(0)}%',
            color: AppConstants.categoryColors[entry.key] ?? Colors.grey,
            radius: 80,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 20,
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, Color color,
      {bool isPercentage = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            isPercentage
                ? '${value.toStringAsFixed(1)}%'
                : _currencyFormat.format(value),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCompact(double value) {
    if (value.abs() >= 100000) {
      return '${(value / 100000).toStringAsFixed(1)}L';
    } else if (value.abs() >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }
}
