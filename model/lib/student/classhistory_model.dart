class ClassHistoryEntry {
  final String year;
  final String classId;

  ClassHistoryEntry({required this.year, required this.classId});

  factory ClassHistoryEntry.fromMap(Map<String, dynamic> map) {
    return ClassHistoryEntry(
      year: map['year'] ?? '',
      classId: map['classId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'classId': classId,
    };
  }

  @override
  String toString() {
    return 'ClassHistoryEntry(year: $year, classId: $classId)';
  }
}
