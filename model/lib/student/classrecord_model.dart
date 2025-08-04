import 'feepayment_model.dart';
import 'feestatus_model.dart';

class ClassRecord {
  final int rollNo;
  final Map<String, Map<String, String>> attendance;
  final FeeStatus feeStatus;
  final List<FeePayment> feePayments;

  ClassRecord({
    required this.rollNo,
    required this.attendance,
    required this.feeStatus,
    required this.feePayments,
  });

  factory ClassRecord.fromMap(Map<String, dynamic> map) {
    return ClassRecord(
      rollNo: map['rollNo'] ?? 0,
      attendance: (map['attendance'] as Map<String, dynamic>).map(
            (month, days) => MapEntry(
          month,
          (days as Map<String, dynamic>).map(
                (day, value) => MapEntry(day, value as String),
          ),
        ),
      ),
      feeStatus: FeeStatus.fromMap(map['feeStatus']),
      feePayments: (map['feePayments'] as List<dynamic>)
          .map((e) => FeePayment.fromMap(e))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rollNo': rollNo,
      'attendance': attendance,
      'feeStatus': feeStatus.toMap(),
      'feePayments': feePayments.map((e) => e.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'ClassRecord(rollNo: $rollNo, feeStatus: $feeStatus , feePayments: $feePayments, attendance: $attendance)';
  }
}
