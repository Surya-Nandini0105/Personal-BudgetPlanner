import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import '../utils/app_theme.dart';
import '../models/transaction_model.dart';
import 'add_transaction_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static final _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '${AppConstants.currencySymbol} ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting
                Text(
                  'Welcome Back!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Here\'s your financial summary',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                const SizedBox(height: 20),

                // Summary Cards Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: [
                    _buildSummaryCard(
                      context,
                      'Total Income',
                      provider.totalIncome,
                      Icons.arrow_downward_rounded,
                      const [Color(0xFF43A047), Color(0xFF66BB6A)],
                    ),
                    _buildSummaryCard(
                      context,
                      'Total Expenses',
                      provider.totalExpenses,
                      Icons.arrow_upward_rounded,
                      const [Color(0xFFE53935), Color(0xFFEF5350)],
                    ),
                    _buildSummaryCard(
                      context,
                      'Balance',
                      provider.availableBalance,
                      Icons.account_balance_wallet,
                      const [Color(0xFF1565C0), Color(0xFF42A5F5)],
                    ),
                    _buildSummaryCard(
                      context,
                      'Monthly Savings',
                      provider.monthlySavings,
                      Icons.savings,
                      const [Color(0xFFFF8F00), Color(0xFFFFB74D)],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Quick Actions
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _navigateToAddTransaction(
                            context, TransactionType.income),
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text('Add Income'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.incomeColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _navigateToAddTransaction(
                            context, TransactionType.expense),
                        icon: const Icon(Icons.remove_circle_outline),
                        label: const Text('Add Expense'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.expenseColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Recent Transactions Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Transactions',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to transaction history tab
                        // This is handled by the parent navigation
                      },
                      child: const Text('See All'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Recent Transactions List
                if (provider.recentTransactions.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.receipt_long,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No transactions yet',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Add your first income or expense',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  ...provider.recentTransactions
                      .map((t) => _buildTransactionTile(context, t)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    double amount,
    IconData icon,
    List<Color> gradientColors,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, color: Colors.white70, size: 20),
            ],
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              _currencyFormat.format(amount),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(BuildContext context, TransactionModel t) {
    final isIncome = t.type == TransactionType.income;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: (AppConstants.categoryColors[t.category] ??
                  Colors.grey)
              .withValues(alpha: 0.15),
          child: Icon(
            AppConstants.categoryIcons[t.category] ?? Icons.more_horiz,
            color:
                AppConstants.categoryColors[t.category] ?? Colors.grey,
            size: 20,
          ),
        ),
        title: Text(
          t.title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          '${t.category} • ${DateFormat('dd MMM yyyy').format(t.date)}',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        trailing: Text(
          '${isIncome ? '+' : '-'} ${_currencyFormat.format(t.amount)}',
          style: TextStyle(
            color: isIncome ? AppTheme.incomeColor : AppTheme.expenseColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  void _navigateToAddTransaction(
      BuildContext context, TransactionType type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddTransactionScreen(type: type),
      ),
    );
  }
}
