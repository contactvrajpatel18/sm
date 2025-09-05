import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:model/student/student_model.dart';
import 'student_provider.dart';

class StudentController {
  final StudentProvider studentProvider;
  final _studentCollection = FirebaseFirestore.instance.collection('students');

  StudentController(this.studentProvider);

  Future<StudentModel?> fetchSingleStudentById({required String studentId}) async {
    studentProvider.setLoading(true);
    try {
      final doc = await _studentCollection.doc(studentId).get();

      if (!doc.exists || doc.data() == null) {
        print("❌ No Firestore document found for studentId: $studentId");
        studentProvider.setError("data not found.");
        return null;
      }

      final studentData = StudentModel.fromMap(doc.data()!);
      studentProvider.setSingleStudent([studentData]);
      // print("✅ getSingleStudent() : $studentData");
      return studentData;
    } catch (e) {
      print("🔥 Error getSingleStudent : $e");
      studentProvider.setError("Failed to load data. Please try again.");
      return null;
    } finally {
      studentProvider.setLoading(false);
    }
  }

}
