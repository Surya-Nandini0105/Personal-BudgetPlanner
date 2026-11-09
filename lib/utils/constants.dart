import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Personal Budget Planner';
  static const String currencySymbol = '₹';

  static const List<String> incomeCategories = [
    'Salary',
    'Freelance',
    'Business',
    'Investment',
    'Rental',
    'Gift',
    'Refund',
    'Others',
  ];

  static const List<String> expenseCategories = [
    'Food',
    'Shopping',
    'Education',
    'Travel',
    'Health',
    'Bills',
    'Entertainment',
    'Others',
  ];

  static const Map<String, IconData> categoryIcons = {
    'Salary': Icons.account_balance_wallet,
    'Freelance': Icons.laptop_mac,
    'Business': Icons.business,
    'Investment': Icons.trending_up,
    'Rental': Icons.home,
    'Gift': Icons.card_giftcard,
    'Refund': Icons.replay,
    'Food': Icons.restaurant,
    'Shopping': Icons.shopping_bag,
    'Education': Icons.school,
    'Travel': Icons.flight,
    'Health': Icons.favorite,
    'Bills': Icons.receipt_long,
    'Entertainment': Icons.movie,
    'Others': Icons.more_horiz,
  };

  static const Map<String, Color> categoryColors = {
    'Salary': Color(0xFF4CAF50),
    'Freelance': Color(0xFF2196F3),
    'Business': Color(0xFF9C27B0),
    'Investment': Color(0xFFFF9800),
    'Rental': Color(0xFF795548),
    'Gift': Color(0xFFE91E63),
    'Refund': Color(0xFF607D8B),
    'Food': Color(0xFFFF5722),
    'Shopping': Color(0xFF673AB7),
    'Education': Color(0xFF3F51B5),
    'Travel': Color(0xFF00BCD4),
    'Health': Color(0xFFF44336),
    'Bills': Color(0xFFFF9800),
    'Entertainment': Color(0xFF9C27B0),
    'Others': Color(0xFF607D8B),
  };

  // SharedPreferences Keys
  static const String transactionsKey = 'transactions';
  static const String budgetsKey = 'budgets';
  static const String savingsGoalsKey = 'savings_goals';
  static const String themeKey = 'theme_mode';
}
