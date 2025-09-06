import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:model/student/student_model.dart';

class StudentProvider with ChangeNotifier {

  final Map<String, List<StudentModel>> _studentsByClass = {};
  bool _isLoading = false;
  String? _error;

  List<StudentModel> getStudents(String classId, String year) {
    final key = "${year}_$classId";
    return UnmodifiableListView(_studentsByClass[key] ?? []);
  }

  bool get isLoading => _isLoading;
  String? get error => _error;

  void addStudents(List<StudentModel> students, String classId, String year) {
    final key = "${year}_$classId";
    _studentsByClass.putIfAbsent(key, () => []);

    for (var student in students) {
      if (!_studentsByClass[key]!.any((s) => s.id == student.id)) {
        _studentsByClass[key]!.add(student);
      }
    }
    notifyListeners();
  }

  void setStudents(List<StudentModel> students, String classId, String year) {
    final key = "${year}_$classId";
    _studentsByClass[key] = students;
    _error = null;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }

  void clearData() {
    _studentsByClass.clear();
    _error = null;
  }
}
