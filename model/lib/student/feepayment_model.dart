class FeePayment {
  final String date;
  final int amount;
  final String mode;

  FeePayment({
    required this.date,
    required this.amount,
    required this.mode,
  });

  factory FeePayment.fromMap(Map<String, dynamic> map) {
    return FeePayment(
      date: map['date'] ?? '',
      amount: map['amount'] ?? 0,
      mode: map['mode'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'amount': amount,
      'mode': mode,
    };
  }

  @override
  String toString() {
    return 'FeePayment(date: $date, amount: $amount, mode: $mode)';
  }
}
