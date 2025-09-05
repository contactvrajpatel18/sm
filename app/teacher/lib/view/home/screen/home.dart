import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:model/coman/selected_class_year.dart';
import 'package:model/student/student_model.dart';
import 'package:model/teacher/teacher_model.dart';
import 'package:model/utils/loader.dart';
import 'package:provider/provider.dart';
import 'package:teacher/backend/class/class_controller.dart';
import 'package:teacher/backend/class/class_provider.dart';
import 'package:teacher/backend/student/student_controller.dart';
import 'package:teacher/backend/student/student_provider.dart';
import 'package:teacher/backend/teacher/teacher_controller.dart';
import 'package:teacher/backend/teacher/teacher_provider.dart';
import 'package:teacher/view/common/appbar_home.dart';
import 'package:teacher/view/common/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  late TeacherProvider teacherProvider;
  late TeacherController teacherController;

  late StudentProvider studentProvider;
  late StudentController studentController;

  late ClassProvider classProvider;
  late ClassController classController;

  SelectedClassYear? selectedClassYear;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadTeacherData();
    });
  }

  void loadTeacherData() {
    teacherProvider = Provider.of<TeacherProvider>(context, listen: false);
    studentProvider = Provider.of<StudentProvider>(context, listen: false);
    classProvider = Provider.of<ClassProvider>(context, listen: false);

    teacherController = TeacherController(teacherProvider);
    studentController = StudentController(studentProvider);
    classController = ClassController(classProvider);

    if (teacherProvider.getSingleTeacher.isEmpty && currentUserId != null) {
      teacherController.fetchSingleTeacher(teacherId: currentUserId!);
    }
  }

  void loadInitialClass(TeacherModel teacher) {
    final firstYear = teacher.assignedClasses.keys.first;
    final firstClassId = teacher.assignedClasses[firstYear]!.first;
    setState(() {
      selectedClassYear = SelectedClassYear(
        currentClass: firstClassId,
        currentYear: firstYear,
      );
    });

    loadStudentsForClass(firstClassId, firstYear);
  }

  Future<void> loadStudentsForClass(String classId, String year) async {
    teacherProvider.setLoading(true);
    try {
      await classController.addFetchClassByYear(year: year);

      if (classProvider.getclassdata.isNotEmpty) {
        final classByYear = classProvider.getclassdata
            .where((c) => c.id.toString() == year)
            .toList()
            .firstOrNull;

        if (classByYear == null) {
          teacherProvider.setError("No data found for year $year");
          return;
        }

        final studentIds = classByYear.classes[classId]?.students;
        if (studentIds == null || studentIds.isEmpty) {
          teacherProvider.setError("No students found for class $classId in $year");
          return;
        }

        // ✅ Pass classId & year when fetching students
        await studentController.addFetchStudentsByIds(
          studentIds,
          classId: classId,
          year: year,
        );
      }
    } catch (e) {
      teacherProvider.setError("Failed to load students: $e");
    } finally {
      teacherProvider.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: const Drawerr(),
      appBar: const AppbarHome(),
      body: Consumer<TeacherProvider>(
        builder: (context, teacherProvider, child) {
          if (teacherProvider.isLoading) {
            return const Center(child: Loader());
          }

          if (teacherProvider.error != null) {
            return Center(
              child: Text(
                teacherProvider.error!,
                style: const TextStyle(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (teacherProvider.getSingleTeacher.isEmpty) {
            return const Center(child: Text("No data found"));
          }

          final TeacherModel teacher = teacherProvider.getSingleTeacher.first;

          // ✅ Initialize first class safely
          if (selectedClassYear == null && teacher.assignedClasses.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              loadInitialClass(teacher);
            });
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(teacher),
                const SizedBox(height: 24),
                teacher.assignedClasses.isNotEmpty
                    ? _buildClassSelectorDropdown(teacher)
                    : const Center(
                  child: Text(
                    "No classes have been assigned to you yet.",
                    style:
                    TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: selectedClassYear == null
                      ? const Center(child: Text("Please select a class."))
                      : _buildStudentList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(TeacherModel teacher) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "Welcome, ${teacher.name}!",
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget _buildClassSelectorDropdown(TeacherModel teacher) {
    final entries = <SelectedClassYear>[];
    teacher.assignedClasses.forEach((year, classIds) {
      for (final classId in classIds) {
        entries.add(SelectedClassYear(currentClass: classId, currentYear: year));
      }
    });
    return DropdownButtonFormField<SelectedClassYear>(
      value: selectedClassYear,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: "Select Class",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: entries.map((entry) {
        return DropdownMenuItem<SelectedClassYear>(
          value: entry,
          child: Text("Class ${entry.currentClass} (${entry.currentYear})"),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() => selectedClassYear = value);
          loadStudentsForClass(value.currentClass, value.currentYear);
        }
      },
    );
  }

  Widget _buildStudentList() {
    return Consumer<StudentProvider>(
      builder: (context, studentProvider, _) {
        if (studentProvider.isLoading) {
          return const Center(child: Loader());
        }

        // ✅ Get students of selected class & year
        final students = studentProvider.getStudents(
          selectedClassYear!.currentClass,
          selectedClassYear!.currentYear,
        );

        if (students.isEmpty) {
          return const Center(child: Text("No students found for this class."));
        }

        return ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
            return _buildStudentCard(student);
          },
        );
      },
    );
  }

  Widget _buildStudentCard(StudentModel student) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(student.name,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple)),
            const SizedBox(height: 8),
            _buildStudentDetailRow("ID", student.id),
            _buildStudentDetailRow("Gender", student.gender),
            _buildStudentDetailRow("DOB", student.dob),
            _buildStudentDetailRow("Contact", student.contact),
            _buildStudentDetailRow("Parent Contact", student.parentContact),
            _buildStudentDetailRow("Address", student.address),
            _buildStudentDetailRow("Admission Date", student.admissionDate),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text("$label: ",
              style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value.isNotEmpty ? value : "Not available")),
        ],
      ),
    );
  }
}
