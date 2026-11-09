import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../models/budget_model.dart';
import '../utils/constants.dart';
import '../utils/app_theme.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  late int _selectedMonth;
  late int _selectedYear;

  static final _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '${AppConstants.currencySymbol} ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = now.month;
    _selectedYear = now.year;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final budget = provider.getBudgetForMonth(_selectedMonth, _selectedYear);
        final expenses = provider.getExpensesForMonth(_selectedMonth, _selectedYear);
        final income = provider.getIncomeForMonth(_selectedMonth, _selectedYear);
        final remaining = (budget?.monthlyBudget ?? 0) - expenses;
        final progress = budget != null && budget.monthlyBudget > 0
            ? (expenses / budget.monthlyBudget).clamp(0.0, 1.0)
            : 0.0;
        final isOverBudget = remaining < 0;
        final categoryExpenses =
            provider.getCategoryExpenses(_selectedMonth, _selectedYear);

        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Month Selector
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: _previousMonth,
                          icon: const Icon(Icons.chevron_left),
                        ),
                        Text(
                          DateFormat('MMMM yyyy')
                              .format(DateTime(_selectedYear, _selectedMonth)),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: _nextMonth,
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Budget Overview Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Monthly Budget',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              onPressed: () => _showSetBudgetDialog(
                                  context, provider, budget),
                              icon: const Icon(Icons.edit),
                              tooltip: 'Set Budget',
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (budget == null)
                          Center(
                            child: Column(
                              children: [
                                Icon(Icons.account_balance_wallet,
                                    size: 48, color: Colors.grey.shade400),
                                const SizedBox(height: 8),
                                Text(
                                  'No budget set for this month',
                                  style:
                                      TextStyle(color: Colors.grey.shade600),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  onPressed: () => _showSetBudgetDialog(
                                      context, provider, null),
                                  icon: const Icon(Icons.add),
                                  label: const Text('Set Budget'),
                                ),
                              ],
                            ),
                          )
                        else ...[
                          // Budget Amount
                          Text(
                            _currencyFormat.format(budget.monthlyBudget),
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),

                          // Progress Bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 12,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isOverBudget
                                    ? Colors.red
                                    : progress > 0.8
                                        ? AppTheme.warningColor
                                        : AppTheme.incomeColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${(progress * 100).toStringAsFixed(1)}% used',
                            style: TextStyle(
                              color: isOverBudget
                                  ? Colors.red
                                  : Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Summary Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildMiniCard(
                        'Income',
                        income,
                        Icons.arrow_downward,
                        AppTheme.incomeColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMiniCard(
                        'Expenses',
                        expenses,
                        Icons.arrow_upward,
                        AppTheme.expenseColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMiniCard(
                        'Remaining',
                        remaining,
                        Icons.account_balance_wallet,
                        isOverBudget ? Colors.red : AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Category-wise Expenses
                Text(
                  'Category-wise Expenses',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                if (categoryExpenses.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          'No expenses this month',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    ),
                  )
                else
                  ...categoryExpenses.entries.map((entry) {
                    final categoryPercent = expenses > 0
                        ? (entry.value / expenses)
                        : 0.0;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor:
                                  (AppConstants.categoryColors[entry.key] ??
                                          Colors.grey)
                                      .withValues(alpha: 0.15),
                              child: Icon(
                                AppConstants.categoryIcons[entry.key] ??
                                    Icons.more_horiz,
                                color:
                                    AppConstants.categoryColors[entry.key] ??
                                        Colors.grey,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.key,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 4),
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: categoryPercent,
                                      minHeight: 6,
                                      backgroundColor:
                                          Colors.grey.shade200,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                        AppConstants.categoryColors[
                                                entry.key] ??
                                            Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _currencyFormat.format(entry.value),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${(categoryPercent * 100).toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMiniCard(
      String title, double amount, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                _currencyFormat.format(amount),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _previousMonth() {
    setState(() {
      if (_selectedMonth == 1) {
        _selectedMonth = 12;
        _selectedYear--;
      } else {
        _selectedMonth--;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      if (_selectedMonth == 12) {
        _selectedMonth = 1;
        _selectedYear++;
      } else {
        _selectedMonth++;
      }
    });
  }

  void _showSetBudgetDialog(
      BuildContext context, AppProvider provider, BudgetModel? existing) {
    final controller = TextEditingController(
      text: existing?.monthlyBudget.toStringAsFixed(0) ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? 'Set Monthly Budget' : 'Update Budget'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Budget Amount',
            prefixText: '${AppConstants.currencySymbol} ',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text.trim());
              if (amount != null && amount > 0) {
                provider.addOrUpdateBudget(BudgetModel(
                  id: existing?.id,
                  monthlyBudget: amount,
                  month: _selectedMonth,
                  year: _selectedYear,
                ));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Budget saved successfully!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
