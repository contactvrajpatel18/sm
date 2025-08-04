class FeeStatus {
  final int total;
  final int paid;
  final int due;

  FeeStatus({
    required this.total,
    required this.paid,
    required this.due,
  });

  factory FeeStatus.fromMap(Map<String, dynamic> map) {
    return FeeStatus(
      total: map['total'] ?? 0,
      paid: map['paid'] ?? 0,
      due: map['due'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total': total,
      'paid': paid,
      'due': due,
    };
  }

  @override
  String toString() {
    return 'FeeStatus(total: $total, paid: $paid, due: $due)';
  }
}
