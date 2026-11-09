import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../models/transaction_model.dart';
import '../utils/constants.dart';
import '../utils/app_theme.dart';
import 'add_transaction_screen.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _searchQuery = '';
  TransactionType? _typeFilter;
  String? _categoryFilter;

  static final _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '${AppConstants.currencySymbol} ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        List<TransactionModel> transactions = provider.transactions;

        // Apply search
        if (_searchQuery.isNotEmpty) {
          transactions = provider.searchTransactions(_searchQuery);
        }

        // Apply type filter
        if (_typeFilter != null) {
          transactions =
              transactions.where((t) => t.type == _typeFilter).toList();
        }

        // Apply category filter
        if (_categoryFilter != null) {
          transactions = transactions
              .where((t) => t.category == _categoryFilter)
              .toList();
        }

        // Sort by date
        transactions.sort((a, b) => b.date.compareTo(a.date));

        return Scaffold(
          body: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search transactions...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildFilterChip('All', _typeFilter == null, () {
                      setState(() {
                        _typeFilter = null;
                        _categoryFilter = null;
                      });
                    }),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      'Income',
                      _typeFilter == TransactionType.income,
                      () {
                        setState(() {
                          _typeFilter = TransactionType.income;
                          _categoryFilter = null;
                        });
                      },
                      color: AppTheme.incomeColor,
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      'Expense',
                      _typeFilter == TransactionType.expense,
                      () {
                        setState(() {
                          _typeFilter = TransactionType.expense;
                          _categoryFilter = null;
                        });
                      },
                      color: AppTheme.expenseColor,
                    ),
                    const SizedBox(width: 8),
                    // Category Filter
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        setState(() {
                          _categoryFilter = value == 'All' ? null : value;
                        });
                      },
                      itemBuilder: (context) {
                        final categories = _typeFilter == TransactionType.income
                            ? AppConstants.incomeCategories
                            : _typeFilter == TransactionType.expense
                                ? AppConstants.expenseCategories
                                : {
                                    ...AppConstants.incomeCategories,
                                    ...AppConstants.expenseCategories
                                  }.toList();
                        return [
                          const PopupMenuItem(
                              value: 'All', child: Text('All Categories')),
                          ...categories.map((c) => PopupMenuItem(
                                value: c,
                                child: Row(
                                  children: [
                                    Icon(
                                      AppConstants.categoryIcons[c],
                                      size: 18,
                                      color: AppConstants.categoryColors[c],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(c),
                                  ],
                                ),
                              )),
                        ];
                      },
                      child: Chip(
                        avatar: const Icon(Icons.filter_list, size: 18),
                        label: Text(_categoryFilter ?? 'Category'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Transaction Count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${transactions.length} transactions',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Transaction List
              Expanded(
                child: transactions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No transactions found',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          return _buildTransactionCard(
                              context, transactions[index], provider);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(
      String label, bool isSelected, VoidCallback onTap,
      {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : color ?? Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isSelected
            ? (color ?? Theme.of(context).colorScheme.primary)
            : null,
      ),
    );
  }

  Widget _buildTransactionCard(
    BuildContext context,
    TransactionModel transaction,
    AppProvider provider,
  ) {
    final isIncome = transaction.type == TransactionType.income;

    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Transaction'),
            content: const Text(
                'Are you sure you want to delete this transaction?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete',
                    style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        provider.deleteTransaction(transaction.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaction deleted'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddTransactionScreen(
                  type: transaction.type,
                  transaction: transaction,
                ),
              ),
            );
          },
          leading: CircleAvatar(
            backgroundColor: (AppConstants
                        .categoryColors[transaction.category] ??
                    Colors.grey)
                .withValues(alpha: 0.15),
            child: Icon(
              AppConstants.categoryIcons[transaction.category] ??
                  Icons.more_horiz,
              color: AppConstants.categoryColors[transaction.category] ??
                  Colors.grey,
              size: 20,
            ),
          ),
          title: Text(
            transaction.title,
            style:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          subtitle: Text(
            '${transaction.category} • ${DateFormat('dd MMM yyyy').format(transaction.date)}',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isIncome ? '+' : '-'} ${_currencyFormat.format(transaction.amount)}',
                style: TextStyle(
                  color: isIncome
                      ? AppTheme.incomeColor
                      : AppTheme.expenseColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                isIncome ? 'Income' : 'Expense',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
