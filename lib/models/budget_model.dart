import 'package:uuid/uuid.dart';

class BudgetModel {
  final String id;
  final double monthlyBudget;
  final int month; // 1-12
  final int year;

  BudgetModel({
    String? id,
    required this.monthlyBudget,
    required this.month,
    required this.year,
  }) : id = id ?? const Uuid().v4();

  BudgetModel copyWith({
    String? id,
    double? monthlyBudget,
    int? month,
    int? year,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'monthlyBudget': monthlyBudget,
      'month': month,
      'year': year,
    };
  }

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'] as String,
      monthlyBudget: (json['monthlyBudget'] as num).toDouble(),
      month: json['month'] as int,
      year: json['year'] as int,
    );
  }
}
