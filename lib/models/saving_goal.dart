//Savings Model

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