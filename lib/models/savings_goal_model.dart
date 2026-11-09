import 'package:uuid/uuid.dart';

class SavingsGoalModel {
  final String id;
  final String title;
  final double targetAmount;
  final double savedAmount;
  final DateTime createdDate;
  final DateTime? targetDate;

  SavingsGoalModel({
    String? id,
    required this.title,
    required this.targetAmount,
    this.savedAmount = 0.0,
    DateTime? createdDate,
    this.targetDate,
  }) : id = id ?? const Uuid().v4(),
       createdDate = createdDate ?? DateTime.now();

  double get progress => targetAmount > 0 ? (savedAmount / targetAmount).clamp(0.0, 1.0) : 0.0;
  double get remainingAmount => (targetAmount - savedAmount).clamp(0.0, double.infinity);
  bool get isCompleted => savedAmount >= targetAmount;

  SavingsGoalModel copyWith({
    String? id,
    String? title,
    double? targetAmount,
    double? savedAmount,
    DateTime? createdDate,
    DateTime? targetDate,
  }) {
    return SavingsGoalModel(
      id: id ?? this.id,
      title: title ?? this.title,
      targetAmount: targetAmount ?? this.targetAmount,
      savedAmount: savedAmount ?? this.savedAmount,
      createdDate: createdDate ?? this.createdDate,
      targetDate: targetDate ?? this.targetDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'targetAmount': targetAmount,
      'savedAmount': savedAmount,
      'createdDate': createdDate.toIso8601String(),
      'targetDate': targetDate?.toIso8601String(),
    };
  }

  factory SavingsGoalModel.fromJson(Map<String, dynamic> json) {
    return SavingsGoalModel(
      id: json['id'] as String,
      title: json['title'] as String,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      savedAmount: (json['savedAmount'] as num).toDouble(),
      createdDate: DateTime.parse(json['createdDate'] as String),
      targetDate: json['targetDate'] != null ? DateTime.parse(json['targetDate'] as String) : null,
    );
  }
}
