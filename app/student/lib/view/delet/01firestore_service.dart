
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addTeacher(String id, Map<String, dynamic> data) async {
    await _db.collection('teachers').doc(id).set(data);
  }

  Future<void> addClass(String classId, Map<String, dynamic> data) async {
    await _db.collection('classes').doc(classId).set(data);
  }

  Future<void> addStudent(String studentId, Map<String, dynamic> data) async {
    await _db.collection('students').doc(studentId).set(data);
  }

  Future<void> addFormerStudent(String studentId, Map<String, dynamic> data) async {
    await _db.collection('formerStudents').doc(studentId).set(data);
  }

  Future<void> addAttendance(String classId, String date, Map<String, String> records) async {
    await _db.collection('classes').doc(classId).collection('attendance').doc(date).set({
      'date': date,
      'records': records,
    });
  }
}
