class FeeStatus {
  final int paid;
  final int due;

  FeeStatus({required this.paid, required this.due});

  factory FeeStatus.fromMap(Map<String, dynamic> map) {
    return FeeStatus(
      paid: map['paid'] ?? 0,
      due: map['due'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'paid': paid,
      'due': due,
    };
  }

  @override
  String toString() {
    return 'FeeStatus(paid: $paid, due: $due)';
  }
}
