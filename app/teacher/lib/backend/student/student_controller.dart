import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:model/student/student_model.dart';
import 'student_provider.dart';

class StudentController {
  final StudentProvider studentProvider;
  final _studentCollection = FirebaseFirestore.instance.collection('students');

  StudentController(this.studentProvider);

  Future<List<StudentModel>?> addFetchStudentsByIds(
       {
         required List<String> ids,
        required String classId,
        required String year,
      }) async {
    studentProvider.setLoading(true);
    try {
      final existingStudents = studentProvider.getStudents(classId, year);
      print("📚 Existing Students in Provider [$classId-$year]: $existingStudents");

      if (existingStudents.isNotEmpty) {
        print("⚠️ All students already exist for [$classId-$year], skipping fetch...");
        return null;
      }

      final futures = ids.map((id) => _studentCollection.doc(id).get());
      final snapshots = await Future.wait(futures);

      final fetchedStudents = snapshots
          .where((doc) => doc.exists && doc.data() != null)
          .map((doc) => StudentModel.fromMap(doc.data()!))
          .toList();

      if (fetchedStudents.isEmpty) {
        print("❌ No Firestore documents found for given IDs");
        studentProvider.setError("data not found.");
        return null;
      }

      studentProvider.setStudents(fetchedStudents, classId, year);
      // print("✅ addFetchStudentsByIds($classId-$year) : $fetchedStudents");
      return null;

    } catch (e) {
      print("🔥 Error addFetchStudentsByIds : $e");
      studentProvider.setError("Failed to load data. Please try again.");
      return null;
    } finally {
      studentProvider.setLoading(false);
    }
  }



}
