// class Transaction {
//   String id;
//   String userId;
//   String type; // "income" or "expense"
//   String category;
//   double amount;
//   DateTime date;
//   String description;
//   String? savingGoalId; // ✅ Add this field

//   Transaction({
//     required this.id,
//     required this.userId,
//     required this.type,
//     required this.category,
//     required this.amount,
//     required this.date,
//     required this.description,
//      this.savingGoalId, // ✅ Assign here
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'user_id': userId,
//       'type': type,
//       'category': category,
//       'amount': amount,
//       'date': date.toIso8601String(),
//       'description': description,
//       'saving_goal_id': savingGoalId, // ✅ Optional field
//     };
//   }

//   static Transaction fromMap(Map<String, dynamic> map) {
//     return Transaction(
//       id: map['id'],
//       userId: map['user_id'],
//       type: map['type'],
//       category: map['category'],
//       amount: map['amount'],
//       date: DateTime.parse(map['date']),
//       description: map['description'],
//       savingGoalId: map['saving_goal_id'], // ✅ Load from DB
//     );
//   }
// } 
class Transaction {
  String id;
  String userId;
  String type; // "income" or "expense"
  String category;
  double amount;
  DateTime date;
  String description;
  String? savingGoalId; // ✅ Add this field

  Transaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.category,
    required this.amount,
    required this.date,
    required this.description,
     this.savingGoalId, // ✅ Assign here
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
      'saving_goal_id': savingGoalId, // ✅ Optional field
    };
  }

  // ✅ REPLACE THIS METHOD:
  static Transaction fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      type: map['type'] ?? '',
      category: map['category'] ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0, // ✅ Updated this line
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      description: map['description'] ?? '',
      savingGoalId: map['saving_goal_id']?.toString(), // ✅ Updated this line
    );
  }
}