import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:model/student/student_model.dart';
import 'student_provider.dart';

class StudentController {

  final _studentCollection = FirebaseFirestore.instance.collection('students');

  Future<void> readSingleStudent({required String studentId, required StudentProvider studentProvider}) async {
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

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<String>> getStudentsInClass(String classId) async {
    final doc = await _db.collection('classes').doc(classId).get();
    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('students') && data['students'] is List) {
        return List<String>.from(data['students']);
      }
    }
    return [];
  }

  Future<List<StudentModel>> getStudentsByIds(List<String> studentIds) async {
    if (studentIds.isEmpty) {
      return []; // Return an empty list if no IDs are provided
    }

    List<StudentModel> students = [];
    try {
      for (String id in studentIds) {
        final doc = await _studentCollection.doc(id).get();
        if (doc.exists && doc.data() != null) {
          students.add(StudentModel.fromMap(doc.data()!));
        }
      }
      return students;
    } catch (e) {
      print('Error fetching students by IDs: $e');
      // You might want to throw an exception or return a specific error state
      return []; // Return an empty list on error
    }
  }

}