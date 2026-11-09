import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../models/budget_model.dart';
import '../models/savings_goal_model.dart';
import '../services/storage_service.dart';

class AppProvider extends ChangeNotifier {
  StorageService? _storageService;

  List<TransactionModel> _transactions = [];
  List<BudgetModel> _budgets = [];
  List<SavingsGoalModel> _savingsGoals = [];
  bool _isDarkMode = false;
  bool _isLoading = true;

  // Getters
  List<TransactionModel> get transactions => _transactions;
  List<BudgetModel> get budgets => _budgets;
  List<SavingsGoalModel> get savingsGoals => _savingsGoals;
  bool get isDarkMode => _isDarkMode;
  bool get isLoading => _isLoading;

  // Computed values
  double get totalIncome => _transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpenses => _transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get availableBalance => totalIncome - totalExpenses;

  double get currentMonthIncome {
    final now = DateTime.now();
    return _transactions
        .where((t) =>
            t.type == TransactionType.income &&
            t.date.month == now.month &&
            t.date.year == now.year)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get currentMonthExpenses {
    final now = DateTime.now();
    return _transactions
        .where((t) =>
            t.type == TransactionType.expense &&
            t.date.month == now.month &&
            t.date.year == now.year)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get monthlySavings => currentMonthIncome - currentMonthExpenses;

  List<TransactionModel> get recentTransactions {
    final sorted = List<TransactionModel>.from(_transactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(5).toList();
  }

  List<TransactionModel> get incomeTransactions =>
      _transactions.where((t) => t.type == TransactionType.income).toList();

  List<TransactionModel> get expenseTransactions =>
      _transactions.where((t) => t.type == TransactionType.expense).toList();

  // Initialize
  Future<void> initialize() async {
    _storageService = await StorageService.getInstance();
    await _loadAllData();
  }

  Future<void> _loadAllData() async {
    _isLoading = true;
    notifyListeners();

    _transactions = await _storageService!.getTransactions();
    _budgets = await _storageService!.getBudgets();
    _savingsGoals = await _storageService!.getSavingsGoals();
    _isDarkMode = await _storageService!.getIsDarkMode();

    _isLoading = false;
    notifyListeners();
  }

  // ── Transaction operations ────────────────────────────────────

  Future<void> addTransaction(TransactionModel transaction) async {
    _transactions.add(transaction);
    await _storageService!.saveTransactions(_transactions);
    notifyListeners();
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      _transactions[index] = transaction;
      await _storageService!.saveTransactions(_transactions);
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((t) => t.id == id);
    await _storageService!.saveTransactions(_transactions);
    notifyListeners();
  }

  // ── Budget operations ─────────────────────────────────────────

  Future<void> addOrUpdateBudget(BudgetModel budget) async {
    final index = _budgets.indexWhere(
        (b) => b.month == budget.month && b.year == budget.year);
    if (index != -1) {
      _budgets[index] = budget;
    } else {
      _budgets.add(budget);
    }
    await _storageService!.saveBudgets(_budgets);
    notifyListeners();
  }

  BudgetModel? getBudgetForMonth(int month, int year) {
    try {
      return _budgets.firstWhere(
          (b) => b.month == month && b.year == year);
    } catch (_) {
      return null;
    }
  }

  double getExpensesForMonth(int month, int year) {
    return _transactions
        .where((t) =>
            t.type == TransactionType.expense &&
            t.date.month == month &&
            t.date.year == year)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double getIncomeForMonth(int month, int year) {
    return _transactions
        .where((t) =>
            t.type == TransactionType.income &&
            t.date.month == month &&
            t.date.year == year)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  Map<String, double> getCategoryExpenses(int month, int year) {
    final Map<String, double> categoryMap = {};
    for (final t in _transactions) {
      if (t.type == TransactionType.expense &&
          t.date.month == month &&
          t.date.year == year) {
        categoryMap[t.category] = (categoryMap[t.category] ?? 0) + t.amount;
      }
    }
    return categoryMap;
  }

  Map<String, double> getCategoryIncome(int month, int year) {
    final Map<String, double> categoryMap = {};
    for (final t in _transactions) {
      if (t.type == TransactionType.income &&
          t.date.month == month &&
          t.date.year == year) {
        categoryMap[t.category] = (categoryMap[t.category] ?? 0) + t.amount;
      }
    }
    return categoryMap;
  }

  // ── Savings Goal operations ───────────────────────────────────

  Future<void> addSavingsGoal(SavingsGoalModel goal) async {
    _savingsGoals.add(goal);
    await _storageService!.saveSavingsGoals(_savingsGoals);
    notifyListeners();
  }

  Future<void> updateSavingsGoal(SavingsGoalModel goal) async {
    final index = _savingsGoals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _savingsGoals[index] = goal;
      await _storageService!.saveSavingsGoals(_savingsGoals);
      notifyListeners();
    }
  }

  Future<void> deleteSavingsGoal(String id) async {
    _savingsGoals.removeWhere((g) => g.id == id);
    await _storageService!.saveSavingsGoals(_savingsGoals);
    notifyListeners();
  }

  Future<void> addToSavingsGoal(String id, double amount) async {
    final index = _savingsGoals.indexWhere((g) => g.id == id);
    if (index != -1) {
      _savingsGoals[index] = _savingsGoals[index].copyWith(
        savedAmount: _savingsGoals[index].savedAmount + amount,
      );
      await _storageService!.saveSavingsGoals(_savingsGoals);
      notifyListeners();
    }
  }

  // ── Theme ─────────────────────────────────────────────────────

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _storageService!.setIsDarkMode(_isDarkMode);
    notifyListeners();
  }

  // ── Reset ─────────────────────────────────────────────────────

  Future<void> resetAllData() async {
    _transactions.clear();
    _budgets.clear();
    _savingsGoals.clear();
    await _storageService!.clearAllData();
    notifyListeners();
  }

  // ── Search and Filter ─────────────────────────────────────────

  List<TransactionModel> searchTransactions(String query) {
    final lowerQuery = query.toLowerCase();
    return _transactions.where((t) {
      return t.title.toLowerCase().contains(lowerQuery) ||
          t.category.toLowerCase().contains(lowerQuery) ||
          t.amount.toString().contains(lowerQuery);
    }).toList();
  }

  List<TransactionModel> filterTransactions({
    TransactionType? type,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _transactions.where((t) {
      if (type != null && t.type != type) return false;
      if (category != null && t.category != category) return false;
      if (startDate != null && t.date.isBefore(startDate)) return false;
      if (endDate != null) {
        final endOfDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
        if (t.date.isAfter(endOfDay)) return false;
      }
      return true;
    }).toList();
  }

  // ── Monthly data for charts ───────────────────────────────────

  Map<int, double> getMonthlyIncome(int year) {
    final Map<int, double> monthlyData = {};
    for (int i = 1; i <= 12; i++) {
      monthlyData[i] = getIncomeForMonth(i, year);
    }
    return monthlyData;
  }

  Map<int, double> getMonthlyExpenses(int year) {
    final Map<int, double> monthlyData = {};
    for (int i = 1; i <= 12; i++) {
      monthlyData[i] = getExpensesForMonth(i, year);
    }
    return monthlyData;
  }

  Map<int, double> getMonthlySavings(int year) {
    final Map<int, double> monthlyData = {};
    for (int i = 1; i <= 12; i++) {
      monthlyData[i] = getIncomeForMonth(i, year) - getExpensesForMonth(i, year);
    }
    return monthlyData;
  }
}
