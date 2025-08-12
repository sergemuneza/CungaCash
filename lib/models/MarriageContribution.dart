class MarriageContribution {
  final String userId;
  final double amount;
  final String referenceCode;
  final DateTime date;

  MarriageContribution({
    required this.userId,
    required this.amount,
    required this.referenceCode,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'amount': amount,
      'referenceCode': referenceCode,
      'date': date.toIso8601String(),
    };
  }

  factory MarriageContribution.fromMap(Map<String, dynamic> map) {
    return MarriageContribution(
      userId: map['userId'],
      amount: map['amount'],
      referenceCode: map['referenceCode'],
      date: DateTime.parse(map['date']),
    );
  }
}
