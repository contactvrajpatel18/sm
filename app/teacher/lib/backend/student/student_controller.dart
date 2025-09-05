import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:model/student/student_model.dart';
import 'student_provider.dart';

class StudentController {
  final StudentProvider studentProvider;
  final _studentCollection = FirebaseFirestore.instance.collection('students');

  StudentController(this.studentProvider);



  // Future<List<StudentModel>?> addFetchStudentsByIds(List<String> ids) async {
  //   studentProvider.setLoading(true);
  //   try {
  //
  //
  //     final exists = studentProvider.getSingleStudent
  //         .any((StudentModel) => StudentModel.id == ids);
  //
  //
  //     final futures = ids.map((id) => _studentCollection.doc(id).get());
  //     final snapshots = await Future.wait(futures);
  //
  //     final students = snapshots
  //         .where((doc) => doc.exists && doc.data() != null)
  //         .map((doc) => StudentModel.fromMap(doc.data()!))
  //         .toList();
  //
  //     studentProvider.setSingleStudent(students);
  //
  //     print("✅ getSingleStudent() : $students");
  //     return students;
  //   } catch (e) {
  //     print("🔥 Error fetchStudentsByIds : $e");
  //     studentProvider.setError("Failed to load data. Please try again.");
  //     return null;
  //   } finally {
  //     studentProvider.setLoading(false);
  //   }
  // }




  Future<List<StudentModel>?> addFetchStudentsByIds(List<String> ids) async {
    studentProvider.setLoading(true);
    try {

      print("🔍 Requested IDs: $ids");
      // ✅ Get already loaded students
      final existingStudents = studentProvider.getSingleStudent;

      print("📚 Existing Students in Provider: $existingStudents");
      // ✅ Find which IDs are already present
      final existingIds = existingStudents.map((s) => s.id).toSet();

      print("🔍 Existing IDs in Provider: $existingIds");
      final missingIds = ids.where((id) => !existingIds.contains(id)).toList();

      print("🆕 Missing IDs to fetch: $missingIds");
      List<StudentModel> fetchedStudents = [];
      print("fetchedStudents : ${fetchedStudents}");

      if (missingIds.isNotEmpty) {
        // ✅ Fetch only missing ones
        final futures = missingIds.map((id) => _studentCollection.doc(id).get());
        final snapshots = await Future.wait(futures);

        fetchedStudents = snapshots
            .where((doc) => doc.exists && doc.data() != null)
            .map((doc) => StudentModel.fromMap(doc.data()!))
            .toList();


        // ✅ Add new students to provider (merge with existing ones)
        studentProvider.addStudents(fetchedStudents);
      } else {
        print("⚠️ All students already exist, skipping fetch...");
      }

      // ✅ Return all requested students (existing + fetched)
      final result = studentProvider.getSingleStudent
          .where((s) => ids.contains(s.id))
          .toList();

      print("✅ getSingleStudent() : $result");
      return result;
    } catch (e) {
      print("🔥 Error fetchStudentsByIds : $e");
      studentProvider.setError("Failed to load data. Please try again.");
      return null;
    } finally {
      studentProvider.setLoading(false);
    }
  }








  Future<List<StudentModel>?> fetchStudentsByIds(List<String> ids) async {
    studentProvider.setLoading(true);
    try {
      final futures = ids.map((id) => _studentCollection.doc(id).get());
      final snapshots = await Future.wait(futures);

      final students = snapshots
          .where((doc) => doc.exists && doc.data() != null)
          .map((doc) => StudentModel.fromMap(doc.data()!))
          .toList();

      studentProvider.setSingleStudent(students);

      print("✅ getSingleStudent() : $students");
      return students;
    } catch (e) {
      print("🔥 Error fetchStudentsByIds : $e");
      studentProvider.setError("Failed to load data. Please try again.");
      return null;
    } finally {
      studentProvider.setLoading(false);
    }
  }



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
