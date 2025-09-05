class SelectedClassYear {
  late final String currentClass;
  final String currentYear;

  SelectedClassYear({required this.currentClass, required this.currentYear});

  @override
  String toString() => "$currentClass ($currentYear)";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SelectedClassYear &&
              runtimeType == other.runtimeType &&
              currentClass == other.currentClass &&
              currentYear == other.currentYear;

  @override
  int get hashCode => currentYear.hashCode ^ currentYear.hashCode;
}