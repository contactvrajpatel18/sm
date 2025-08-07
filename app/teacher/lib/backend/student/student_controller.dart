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
      // Firestore's `whereIn` clause allows up to 10 items.
      // If you have more than 10 student IDs, you need to split the queries.
      // For simplicity, let's assume max 10 for now or fetch individually.

      // If you are certain studentIds will always be 10 or less:
      // final querySnapshot = await _studentDataCollection.where(FieldPath.documentId, whereIn: studentIds).get();
      // for (var doc in querySnapshot.docs) {
      //   students.add(StudentDataModel.fromMap(doc.data()));
      // }

      // More robust for potentially more than 10 student IDs (fetches them one by one)
      // This is less efficient for large lists but safer for any number of IDs.
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

// Future<List<Map<String, dynamic>>> getStudentsByIds(List<String> studentIds) async {
  //   if (studentIds.isEmpty) {
  //     return [];
  //   }
  //
  //   final List<Map<String, dynamic>> studentsData = [];
  //   // Firestore's in-query has a limit of 10.
  //   // If you have more than 10 students, you'll need to paginate or make multiple queries.
  //   // For simplicity, let's assume a reasonable number or handle pagination if needed.
  //   // A common approach for 'in' queries is to batch them.
  //   const int chunkSize = 10;
  //   for (int i = 0; i < studentIds.length; i += chunkSize) {
  //     final chunk = studentIds.sublist(i, (i + chunkSize > studentIds.length) ? studentIds.length : i + chunkSize);
  //     final querySnapshot = await _db.collection('students').where(FieldPath.documentId, whereIn: chunk).get();
  //     for (var doc in querySnapshot.docs) {
  //       studentsData.add(doc.data());
  //     }
  //   }
  //   return studentsData;
  // }
}
