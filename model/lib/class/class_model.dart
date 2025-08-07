class ClassModel {
  final String teacherId;
  final List<String> students;

  ClassModel({
    required this.teacherId,
    required this.students,
  });

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      teacherId: map['teacherId'],
      students: List<String>.from(map['students']),
    );
  }

  Map<String, dynamic> toMap() => {
    'teacherId': teacherId,
    'students': students,
  };

  @override
  String toString() {
    return 'SchoolClass(teacherId: $teacherId, students: $students)';
  }
}
