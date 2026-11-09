import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';
import '../models/budget_model.dart';
import '../models/savings_goal_model.dart';
import '../utils/constants.dart';

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // ── Transactions ──────────────────────────────────────────────

  Future<List<TransactionModel>> getTransactions() async {
    final String? data = _prefs?.getString(AppConstants.transactionsKey);
    if (data == null || data.isEmpty) return [];
    final List<dynamic> jsonList = json.decode(data) as List<dynamic>;
    return jsonList
        .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveTransactions(List<TransactionModel> transactions) async {
    final String data =
        json.encode(transactions.map((t) => t.toJson()).toList());
    await _prefs?.setString(AppConstants.transactionsKey, data);
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    final transactions = await getTransactions();
    transactions.add(transaction);
    await saveTransactions(transactions);
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    final transactions = await getTransactions();
    final index = transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      transactions[index] = transaction;
      await saveTransactions(transactions);
    }
  }

  Future<void> deleteTransaction(String id) async {
    final transactions = await getTransactions();
    transactions.removeWhere((t) => t.id == id);
    await saveTransactions(transactions);
  }

  // ── Budgets ───────────────────────────────────────────────────

  Future<List<BudgetModel>> getBudgets() async {
    final String? data = _prefs?.getString(AppConstants.budgetsKey);
    if (data == null || data.isEmpty) return [];
    final List<dynamic> jsonList = json.decode(data) as List<dynamic>;
    return jsonList
        .map((e) => BudgetModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveBudgets(List<BudgetModel> budgets) async {
    final String data = json.encode(budgets.map((b) => b.toJson()).toList());
    await _prefs?.setString(AppConstants.budgetsKey, data);
  }

  Future<void> addOrUpdateBudget(BudgetModel budget) async {
    final budgets = await getBudgets();
    final index = budgets.indexWhere(
        (b) => b.month == budget.month && b.year == budget.year);
    if (index != -1) {
      budgets[index] = budget;
    } else {
      budgets.add(budget);
    }
    await saveBudgets(budgets);
  }

  Future<BudgetModel?> getBudgetForMonth(int month, int year) async {
    final budgets = await getBudgets();
    try {
      return budgets.firstWhere((b) => b.month == month && b.year == year);
    } catch (_) {
      return null;
    }
  }

  // ── Savings Goals ─────────────────────────────────────────────

  Future<List<SavingsGoalModel>> getSavingsGoals() async {
    final String? data = _prefs?.getString(AppConstants.savingsGoalsKey);
    if (data == null || data.isEmpty) return [];
    final List<dynamic> jsonList = json.decode(data) as List<dynamic>;
    return jsonList
        .map((e) => SavingsGoalModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveSavingsGoals(List<SavingsGoalModel> goals) async {
    final String data = json.encode(goals.map((g) => g.toJson()).toList());
    await _prefs?.setString(AppConstants.savingsGoalsKey, data);
  }

  Future<void> addSavingsGoal(SavingsGoalModel goal) async {
    final goals = await getSavingsGoals();
    goals.add(goal);
    await saveSavingsGoals(goals);
  }

  Future<void> updateSavingsGoal(SavingsGoalModel goal) async {
    final goals = await getSavingsGoals();
    final index = goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      goals[index] = goal;
      await saveSavingsGoals(goals);
    }
  }

  Future<void> deleteSavingsGoal(String id) async {
    final goals = await getSavingsGoals();
    goals.removeWhere((g) => g.id == id);
    await saveSavingsGoals(goals);
  }

  // ── Theme ─────────────────────────────────────────────────────

  Future<bool> getIsDarkMode() async {
    return _prefs?.getBool(AppConstants.themeKey) ?? false;
  }

  Future<void> setIsDarkMode(bool isDark) async {
    await _prefs?.setBool(AppConstants.themeKey, isDark);
  }

  // ── Reset ─────────────────────────────────────────────────────

  Future<void> clearAllData() async {
    await _prefs?.remove(AppConstants.transactionsKey);
    await _prefs?.remove(AppConstants.budgetsKey);
    await _prefs?.remove(AppConstants.savingsGoalsKey);
  }
}
