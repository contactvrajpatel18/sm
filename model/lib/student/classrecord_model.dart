import 'examresult_model.dart';
import 'feepayment_model.dart';
import 'feestatus_model.dart';

class ClassRecord {
  final int rollNo;
  final Map<String, Map<String, String>> attendance;
  final FeeStatus feeStatus;
  final List<FeePayment> feePayments;
  final Map<String, ExamResult> results;

  ClassRecord({
    required this.rollNo,
    required this.attendance,
    required this.feeStatus,
    required this.feePayments,
    required this.results,
  });

  factory ClassRecord.fromMap(Map<String, dynamic> map) {
    return ClassRecord(
      rollNo: map['rollNo'] ?? 0,
      attendance: (map['attendance'] as Map<String, dynamic>? ?? {})
          .map((month, days) => MapEntry(
        month,
        (days as Map<String, dynamic>).map(
              (day, status) => MapEntry(day, status.toString()),
        ),
      )),
      feeStatus: FeeStatus.fromMap(map['feeStatus'] ?? {}),
      feePayments: (map['feePayments'] as List<dynamic>? ?? [])
          .map((e) => FeePayment.fromMap(e))
          .toList(),
      results: (map['results'] as Map<String, dynamic>? ?? {})
          .map((exam, data) => MapEntry(exam, ExamResult.fromMap(data))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rollNo': rollNo,
      'attendance': attendance,
      'feeStatus': feeStatus.toMap(),
      'feePayments': feePayments.map((e) => e.toMap()).toList(),
      'results': results.map((exam, res) => MapEntry(exam, res.toMap())),
    };
  }

  @override
  String toString() {
    return 'ClassRecord(rollNo: $rollNo, attendance: $attendance, '
        'feeStatus: $feeStatus, feePayments: $feePayments, results: $results)';
  }
}
