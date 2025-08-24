class ClassHistory {
  final String year;
  final String classId;
  final String result;

  ClassHistory({
    required this.year,
    required this.classId,
    required this.result,
  });

  factory ClassHistory.fromMap(Map<String, dynamic> map) {
    return ClassHistory(
      year: map['year'] ?? '',
      classId: map['classId'] ?? '',
      result: map['result'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'classId': classId,
      'result': result,
    };
  }

  @override
  String toString() {
    return 'ClassHistory(year: $year, classId: $classId, result: $result)';
  }
}
