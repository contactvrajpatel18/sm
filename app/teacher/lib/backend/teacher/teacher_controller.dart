import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:model/teacher/teacher_model.dart';
import 'package:teacher/backend/teacher/teacher_provider.dart';


class TeacherController {

  final TeacherProvider teacherProvider;
  final _TeacherCollection = FirebaseFirestore.instance.collection('teachers');

  TeacherController(this.teacherProvider);

  Future<TeacherModel?> fetchSingleTeacher({required String teacherId}) async {
    teacherProvider.setLoading(true);
    try {
      final doc = await _TeacherCollection.doc(teacherId).get();

      if (!doc.exists || doc.data() == null) {
        print("❌ No Firestore document found for teacherId: $teacherId");
        teacherProvider.setError("data not found.");
        return null;
      }

      final teacherData = TeacherModel.fromMap(doc.data()!);
      teacherProvider.setTeacher([teacherData]);
      // print("✅ fetchSingleTeacher() : $teacherData");
      return teacherData;
    } catch (e) {
      print("🔥 Error fetchSingleTeacher : $e");
      teacherProvider.setError("Failed to load data. Please try again.");
      return null;
    } finally {
      teacherProvider.setLoading(false);
    }
  }

}
