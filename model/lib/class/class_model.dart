import 'class_info_model.dart';

class ClassModel {
  final String id;
  final Map<String, ClassInfo> classes;

  ClassModel({
    required this.id,
    required this.classes,
  });

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    final classEntries = Map<String, ClassInfo>.fromEntries(
      map.entries.where((e) => e.key != "id").map(
            (e) => MapEntry(e.key, ClassInfo.fromMap(e.value)),
      ),
    );
    return ClassModel(
      id: map['id'] ?? '',
      classes: classEntries,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      ...classes.map((key, value) => MapEntry(key, value.toMap())),
    };
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('\nClassModel(\n');
    buffer.write('  id: $id,\n');
    classes.forEach((classId, info) {
      buffer.write('  $classId: $info,\n');
    });
    buffer.write(')');
    return buffer.toString();
  }
}
