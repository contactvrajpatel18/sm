import 'class_info_model.dart';

class ClassModel {
  final Map<String, ClassInfo> classes;

  ClassModel({required this.classes});

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      classes: map.map(
            (classId, value) => MapEntry(
          classId,
          ClassInfo.fromMap(value as Map<String, dynamic>),
        ),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return classes.map(
          (classId, info) => MapEntry(classId, info.toMap()),
    );
  }

  @override
  String toString() {
    return 'ClassModel(classes: $classes)';
  }
}