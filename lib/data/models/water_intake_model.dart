class WaterIntake {
  final String id;
  final String userId;
  final double amount; // in milliliters
  final DateTime timestamp;
  final String date; // YYYY-MM-DD format for easy querying

  WaterIntake({
    required this.id,
    required this.userId,
    required this.amount,
    required this.timestamp,
    required this.date,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
      'date': date,
    };
  }

  // Create from Firestore Map
  factory WaterIntake.fromMap(Map<String, dynamic> map) {
    double convert(String value) {
      return double.parse(value);
    }

    return WaterIntake(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      amount: convert(map['amount'] ?? 0),
      timestamp: DateTime.parse(map['timestamp']),
      date: map['date'] ?? '',
    );
  }

  // Helper to create date string from DateTime
  static String dateFromDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }
}

class DailyWaterGoal {
  final String userId;
  final double goalAmount; // in milliliters
  final DateTime date;
  final double consumedAmount;

  DailyWaterGoal({
    required this.userId,
    required this.goalAmount,
    required this.date,
    this.consumedAmount = 0,
  });

  // Calculate progress percentage
  double get progressPercentage {
    if (goalAmount == 0) return 0;
    return (consumedAmount / goalAmount * 100).clamp(0, 100);
  }

  // Check if goal is completed
  bool get isCompleted => consumedAmount >= goalAmount;

  // Remaining amount to reach goal
  double get remainingAmount {
    final remaining = goalAmount - consumedAmount;
    return remaining > 0 ? remaining : 0;
  }

  // Copy with method
  DailyWaterGoal copyWith({
    String? userId,
    double? goalAmount,
    DateTime? date,
    double? consumedAmount,
  }) {
    return DailyWaterGoal(
      userId: userId ?? this.userId,
      goalAmount: goalAmount ?? this.goalAmount,
      date: date ?? this.date,
      consumedAmount: consumedAmount ?? this.consumedAmount,
    );
  }
}
