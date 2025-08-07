import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:model/teacher/teacher_model.dart';
import 'package:teacher/backend/teacher/teacher_provider.dart';

class TeacherController {
  final _TeacherCollection = FirebaseFirestore.instance.collection('teachers');

  Future<void> readTeacher(String teacherId, TeacherProvider teacherprovider) async {
    teacherprovider.setLoading(true);
    try {
      final doc = await _TeacherCollection.doc(teacherId).get();

      if (doc.exists && doc.data() != null) {
        final Teacher = TeacherModel.fromMap(doc.data()!);
        teacherprovider.setTeacher([Teacher]);
      } else {
        teacherprovider.setError('Teacher Data not found.');
      }
    } catch (e) {
      teacherprovider.setError('Failed to load Data. Please try again.');
    } finally {
      teacherprovider.setLoading(false);
    }
  }

  // Future<Map<String, dynamic>?> getTeacher(String teacherId) async {
  //   final doc = await _TeacherCollection.doc(teacherId).get();
  //   return doc.data();
  // }
}
