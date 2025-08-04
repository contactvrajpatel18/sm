import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:model/student/student_model.dart';
import 'student_provider.dart';

class StudentController {

  final _studentCollection = FirebaseFirestore.instance.collection('students');

  Future<void> readSingleStudent({required String studentId,required StudentProvider studentProvider}) async {
    studentProvider.setLoading(true);
    try {
      final doc = await _studentCollection.doc(studentId).get();

      if (doc.exists && doc.data() != null) {
        final studentData = StudentModel.fromMap(doc.data()!);
        studentProvider.setSingleStudent([studentData]);
      } else {
        studentProvider.setError('Student not found.');
      }
    } catch (e) {
      studentProvider.setError('Failed to load Data. Please try again.');
    } finally {
      studentProvider.setLoading(false);
    }
  }
}
