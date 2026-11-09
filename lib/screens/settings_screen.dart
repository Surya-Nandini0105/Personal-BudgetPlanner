import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../utils/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // App Info Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppTheme.primaryColor,
                              AppTheme.primaryLight,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Personal Budget Planner',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Version 1.0.0',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Appearance Section
              Text(
                'Appearance',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: Icon(
                        provider.isDarkMode
                            ? Icons.dark_mode
                            : Icons.light_mode,
                        color: AppTheme.primaryColor,
                      ),
                      title: const Text('Dark Mode'),
                      subtitle: Text(
                        provider.isDarkMode
                            ? 'Dark theme is active'
                            : 'Light theme is active',
                      ),
                      value: provider.isDarkMode,
                      onChanged: (_) => provider.toggleTheme(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Currency Section
              Text(
                'Currency',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.currency_rupee,
                    color: AppTheme.primaryColor,
                  ),
                  title: const Text('Currency'),
                  subtitle: const Text('Indian Rupee (₹)'),
                  trailing: const Icon(Icons.check_circle,
                      color: AppTheme.incomeColor),
                ),
              ),

              const SizedBox(height: 16),

              // Data Management Section
              Text(
                'Data Management',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.storage,
                        color: AppTheme.primaryColor,
                      ),
                      title: const Text('Storage'),
                      subtitle: const Text(
                          'Data is stored locally in your browser'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.info_outline,
                        color: AppTheme.primaryColor,
                      ),
                      title: const Text('Total Transactions'),
                      subtitle: Text(
                          '${provider.transactions.length} transactions'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.savings,
                        color: AppTheme.primaryColor,
                      ),
                      title: const Text('Savings Goals'),
                      subtitle: Text(
                          '${provider.savingsGoals.length} goals'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      ),
                      title: const Text(
                        'Reset All Data',
                        style: TextStyle(color: Colors.red),
                      ),
                      subtitle: const Text(
                        'Delete all transactions, budgets, and goals',
                      ),
                      onTap: () => _showResetDialog(context, provider),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // About Section
              Text(
                'About',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    const ListTile(
                      leading: Icon(
                        Icons.school,
                        color: AppTheme.primaryColor,
                      ),
                      title: Text('Project Type'),
                      subtitle: Text('College Project'),
                    ),
                    const Divider(height: 1),
                    const ListTile(
                      leading: Icon(
                        Icons.code,
                        color: AppTheme.primaryColor,
                      ),
                      title: Text('Technology'),
                      subtitle: Text('Flutter & Dart'),
                    ),
                    const Divider(height: 1),
                    const ListTile(
                      leading: Icon(
                        Icons.web,
                        color: AppTheme.primaryColor,
                      ),
                      title: Text('Platform'),
                      subtitle: Text('Flutter Web'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      title: const Text('Made with ❤️'),
                      subtitle: const Text(
                        'Personal Budget Planner © 2026',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _showResetDialog(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Reset All Data'),
          ],
        ),
        content: const Text(
          'This will permanently delete all your transactions, budgets, and savings goals. This action cannot be undone.\n\nAre you sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.resetAllData();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data has been reset'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Reset Everything'),
          ),
        ],
      ),
    );
  }
}
