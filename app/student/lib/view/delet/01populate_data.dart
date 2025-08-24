import 'package:flutter/material.dart';
import 'package:student/view/delet/01firestore_service.dart';
import '01dummy_data.dart';


class PopulateDataPage extends StatelessWidget {
  final FirestoreService _service = FirestoreService();

  void populateAll() async {
    dummyTeachers.forEach((id, data) async => await _service.addTeacher(id, data));
    dummyClasses.forEach((id, data) async => await _service.addClass(id, data));
    dummyStudents.forEach((id, data) async => await _service.addStudent(id, data));
    // dummyFormerStudents.forEach((id, data) async => await _service.addFormerStudent(id, data));
    // await _service.addAttendance("1A", "2025-07-19", dummyAttendance);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Populate Dummy Data")),
      body: Center(
        child: ElevatedButton(
          onPressed: populateAll,
          child: Text("Add Dummy Data to Firestore"),
        ),
      ),
    );
  }
}
