// Budget model


import 'package:uuid/uuid.dart';

class Budget {
  final String id;
  final String userId;
  final String name;
  final String category; // Can be 'all' for overall budget
  final double amount;
  double remaining; // ← added field
  final DateTime startDate;
  final DateTime endDate;
  final String period; // 'monthly', 'weekly', 'yearly', 'custom'
  final bool isActive;

  Budget({
    String? id,
    required this.userId,
    required this.name,
    required this.category,
    required this.amount,
    required this.remaining, // ← added to constructor
    required this.startDate,
    required this.endDate,
    required this.period,
    this.isActive = true,
  }) : id = id ?? const Uuid().v4();

  // Create a Budget from a map (coming from DB)
  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
      category: map['category'],
      amount: (map['amount'] as num).toDouble(),
      remaining: (map['remaining'] as num).toDouble(), // ← added
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      period: map['period'],
      isActive: map['is_active'] == 1,
    );
  }

  // Convert Budget to a map (for DB storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'category': category,
      'amount': amount,
      'remaining': remaining, // ← added
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'period': period,
      'is_active': isActive ? 1 : 0,
    };
  }

  // Create a copy of this Budget with given fields replaced
  Budget copyWith({
    String? id,
    String? userId,
    String? name,
    String? category,
    double? amount,
    double? remaining, // ← added
    DateTime? startDate,
    DateTime? endDate,
    String? period,
    bool? isActive,
  }) {
    return Budget(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      remaining: remaining ?? this.remaining, // ← added
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      period: period ?? this.period,
      isActive: isActive ?? this.isActive,
    );
  }
}
