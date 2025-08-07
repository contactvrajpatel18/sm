import 'package:flutter/material.dart';
import 'package:model/student/student_model.dart';
import 'dart:collection';
import 'package:model/teacher/teacher_model.dart';

class TeacherProvider with ChangeNotifier {
  List<TeacherModel> _teacher = [];
  bool _isLoading = false;
  String? _error;
  List<StudentModel> _selectedClassStudents = [];

  List<TeacherModel> get getteacherdata => UnmodifiableListView(_teacher);
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<StudentModel> get selectedClassStudents => UnmodifiableListView(_selectedClassStudents); // This getter exposes the student data

  void setTeacher(List<TeacherModel> setteacher) {
    _teacher = setteacher;
    _error = null;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String errorMessage) {
    _error = errorMessage;
    _teacher = [];
    _selectedClassStudents = [];
    notifyListeners();
  }

  void clearData() {
    _teacher = [];
    _error = null;
    _selectedClassStudents = [];
  }

  // void setSelectedClassStudents(List<StudentModel> students) {
  //   _selectedClassStudents = students;
  //   notifyListeners();
  // }

  // Method to set students for the selected class
  void setSelectedClassStudents(List<StudentModel> students) {
    _selectedClassStudents = students;
    notifyListeners();
  }

}