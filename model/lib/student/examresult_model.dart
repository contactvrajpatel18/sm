class ExamResult {
  final Map<String, int> subjects; // e.g. { "Math": 68, "Science": 72 }
  final int total;
  final double percentage;
  final String grade;

  ExamResult({
    required this.subjects,
    required this.total,
    required this.percentage,
    required this.grade,
  });

  factory ExamResult.fromMap(Map<String, dynamic> map) {
    final copy = Map<String, dynamic>.from(map);
    // extract known keys
    int total = (copy.remove('total') ?? 0) as int;
    double percentage = (copy.remove('percentage') ?? 0).toDouble();
    String grade = copy.remove('grade') ?? '';

    // remaining are subjects
    Map<String, int> subjects =
    copy.map((k, v) => MapEntry(k, (v as num).toInt()));

    return ExamResult(
      subjects: subjects,
      total: total,
      percentage: percentage,
      grade: grade,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ...subjects,
      'total': total,
      'percentage': percentage,
      'grade': grade,
    };
  }

  @override
  String toString() {
    return 'ExamResult(subjects: $subjects, total: $total, '
        'percentage: $percentage, grade: $grade)';
  }
}