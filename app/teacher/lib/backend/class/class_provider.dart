import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:model/class/class_model.dart';

class ClassProvider with ChangeNotifier {
  List<ClassModel> _classData = [];
  bool _isLoading = false;
  String? _error;

  List<ClassModel> get getclassdata => UnmodifiableListView(_classData);
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setClassData(List<ClassModel> setclassdata) {
    _classData = setclassdata;
    _error = null;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String errorMessage) {
    _error = errorMessage;
    _classData = [];
    notifyListeners();
  }

  void clearData() {
    _classData = [];
    _error = null;
  }

}