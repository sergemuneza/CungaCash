// class SavingGoal {
//   final String id;
//   final String title;
//   final double targetAmount;
//   final double savedAmount;
//   final DateTime deadline;

//   SavingGoal({
//     required this.id,
//     required this.title,
//     required this.targetAmount,
//     required this.savedAmount,
//     required this.deadline,
//   });

//   // 🔁 Convert class instance to map (for DB or API)
//   Map<String, dynamic> toMap() => {
//         'id': id,
//         'title': title,
//         'targetAmount': targetAmount,
//         'savedAmount': savedAmount,
//         'deadline': deadline.toIso8601String(),
//       };

//   // 🔁 Create instance from map (e.g. from DB or API)
//   factory SavingGoal.fromMap(Map<String, dynamic> map) => SavingGoal(
//         id: map['id'],
//         title: map['title'],
//         targetAmount: (map['targetAmount'] as num).toDouble(),
//         savedAmount: (map['savedAmount'] as num).toDouble(),
//         deadline: DateTime.parse(map['deadline']),
//       );

//   // ✅ Getter for remaining amount
//   double get remainingAmount => targetAmount - savedAmount;

//   // ✅ Getter for progress percentage (0.0 - 1.0)
//   double get progress => (targetAmount == 0) ? 0 : (savedAmount / targetAmount);

//   // ✅ Optionally, readable string for UI
//   String get formattedDeadline => "${deadline.day}/${deadline.month}/${deadline.year}";
// }
class SavingGoal {
  final int? id; // Nullable int instead of required String
  final String title;
  final double targetAmount;
  final double savedAmount;
  final DateTime deadline;

  SavingGoal({
    this.id, // Optional parameter - no "required" keyword
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
    required this.deadline,
  });

  // Updated toMap method - exclude id for new records
  Map<String, dynamic> toMap() {
    final map = {
      'title': title,
      'targetAmount': targetAmount,
      'savedAmount': savedAmount,
      'deadline': deadline.toIso8601String(),
    };
    
    // Only include id if it's not null (for updates)
    if (id != null) {
      map['id'] = id as Object;
    }
    
    return map;
  }

  factory SavingGoal.fromMap(Map<String, dynamic> map) {
    return SavingGoal(
      id: map['id'], // This will be an int from the database
      title: map['title'],
      targetAmount: map['targetAmount'],
      savedAmount: map['savedAmount'],
      deadline: DateTime.parse(map['deadline']),
    );
  }
}