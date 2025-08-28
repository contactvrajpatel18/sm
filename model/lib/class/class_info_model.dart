class ClassInfo {
  final String teacherId;
  final int fee;
  final List<String> students;

  ClassInfo({
    required this.teacherId,
    required this.fee,
    required this.students,
  });

  factory ClassInfo.fromMap(Map<String, dynamic> map) {
    return ClassInfo(
      teacherId: map['teacherId'] ?? '',
      fee: map['fee'] ?? 0,
      students: List<String>.from(map['students'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'teacherId': teacherId,
      'fee': fee,
      'students': students,
    };
  }

  @override
  String toString() {
    return 'ClassInfo(teacherId: $teacherId, fee: $fee, students: $students)';
  }

}
