class ClassSelection {
  final String classId;
  final String year;

  ClassSelection({required this.classId, required this.year});

  @override
  String toString() => "$classId ($year)";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ClassSelection &&
              runtimeType == other.runtimeType &&
              classId == other.classId &&
              year == other.year;

  @override
  int get hashCode => classId.hashCode ^ year.hashCode;
}