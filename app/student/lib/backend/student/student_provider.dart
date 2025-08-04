import 'package:flutter/material.dart';
import 'dart:collection';

import 'package:model/student/student_model.dart';

class StudentProvider with ChangeNotifier {
  List<StudentModel> _student = [];
  bool _isLoading = false;
  String? _error;

  List<StudentModel> get getSingleStudent => UnmodifiableListView(_student);
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setSingleStudent(List<StudentModel> student) {
    _student = student;
    _error = null;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String errorMessage) {
    _error = errorMessage;
    _student = [];
    notifyListeners();
  }

  void clearData() {
    _student = [];
    _error = null;
  }

}