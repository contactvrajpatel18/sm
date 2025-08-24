import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:model/class/class_model.dart';

import 'class_provider.dart';

class ClassController {
  final _classCollection = FirebaseFirestore.instance.collection('classes');

  Future<ClassModel?> getClassById(String classId) async {
    try {
      final doc = await _classCollection.doc(classId).get();
      if (doc.exists && doc.data() != null) {
        return ClassModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error fetching class data: $e');
      return null;
    }
  }


   Future<ClassModel?> getClassByYear(String year) async {
      try {
     final doc = await _classCollection.doc(year).get();
      if (doc.exists && doc.data() != null) {
      // The data is directly a map of class IDs to ClassInfo
      return ClassModel.fromMap(doc.data()!);
     }
      return null;
     } catch (e) {
      print('Error fetching class data: $e');
      return null;
      }

   }

    Future<void> readClassDats(String classId, ClassProvider classprovider) async {
    classprovider.setLoading(true);
    try {
      final doc = await _classCollection.doc(classId).get();

      if (doc.exists && doc.data() != null) {
        final ClassData = ClassModel.fromMap(doc.data()!);
        classprovider.setClassData([ClassData]);
      } else {
        classprovider.setError('Class Data not found.');
      }
    } catch (e) {
      classprovider.setError('Failed to load Data. Please try again.');
    } finally {
      classprovider.setLoading(false);
    }
  }
}











