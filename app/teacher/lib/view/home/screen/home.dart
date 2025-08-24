import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:model/student/student_model.dart';
import 'package:model/teacher/teacher_model.dart';
import 'package:provider/provider.dart';
import 'package:teacher/backend/class/class_controller.dart';
import 'package:teacher/backend/student/student_controller.dart';
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
  String? _selectedClassYearId;
  final TeacherController _teacherController = TeacherController();
  final StudentController _studentDataController = StudentController();
  final ClassController _classDataController = ClassController();

  final String? teacherId = FirebaseAuth.instance.currentUser?.uid;
  bool _isInitialLoadComplete = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (teacherId != null) {
        _teacherController.readTeacher(
          teacherId!,
          Provider.of<TeacherProvider>(context, listen: false),
        );
      } else {
        Provider.of<TeacherProvider>(context, listen: false).setError('User not logged in.');
      }
    });
  }

  void _loadInitialClass(TeacherModel teacher) {
    if (_isInitialLoadComplete) return;

    final List<MapEntry<String, String>> assignedClassEntries = [];
    teacher.assignedClasses.forEach((year, classIds) {
      for (var classId in classIds) {
        assignedClassEntries.add(MapEntry(year, classId));
      }
    });

    if (assignedClassEntries.isNotEmpty) {
      final initialEntry = assignedClassEntries.first;
      final initialUniqueId = "${initialEntry.value}-${initialEntry.key}";

      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _selectedClassYearId = initialUniqueId;
        });
        _loadStudentsForClass(teacher, initialEntry.value, initialEntry.key);
      });
      _isInitialLoadComplete = true;
    }
  }

  Future<void> _loadStudentsForClass(TeacherModel teacher, String classId, String classYear) async {
    final teacherProvider = Provider.of<TeacherProvider>(context, listen: false);
    teacherProvider.setLoading(true);

    try {
      final classDoc = await _classDataController.getClassByYear(classYear);
      List<String> studentIds = [];

      if (classDoc != null && classDoc.classes.containsKey(classId)) {
        final classInfo = classDoc.classes[classId];
        if (classInfo != null) {
          studentIds = classInfo.students;
        }
      } else {
        teacherProvider.setSelectedClassStudents([]);
      }

      final List<StudentModel> students = await _studentDataController.getStudentsByIds(studentIds);
      teacherProvider.setSelectedClassStudents(students);

    } catch (e) {
      teacherProvider.setError('Failed to load students: $e');
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
            return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
          }
          if (teacherProvider.error != null) {
            return Center(child: Text('Error: ${teacherProvider.error}', style: const TextStyle(color: Colors.red)));
          }

          final TeacherModel? currentTeacher = teacherProvider.getteacherdata.isNotEmpty
              ? teacherProvider.getteacherdata.first
              : null;

          if (currentTeacher == null) {
            return const Center(child: Text('No teacher data found.'));
          }

          _loadInitialClass(currentTeacher);

          final List<MapEntry<String, String>> assignedClassEntries = [];
          currentTeacher.assignedClasses.forEach((year, classIds) {
            for (var classId in classIds) {
              assignedClassEntries.add(MapEntry(year, classId));
            }
          });

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Welcome, ${currentTeacher.name}!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                if (assignedClassEntries.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Select a Class:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.deepPurple, width: 1.5),
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: const SizedBox(),
                          value: _selectedClassYearId,
                          hint: const Text('Choose a Class'),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedClassYearId = newValue;
                            });
                            if (newValue != null) {
                              final parts = newValue.split('-');
                              final classId = parts[0];
                              final year = parts[1];
                              _loadStudentsForClass(currentTeacher, classId, year);
                            } else {
                              teacherProvider.setSelectedClassStudents([]);
                            }
                          },
                          items: assignedClassEntries.map<DropdownMenuItem<String>>((MapEntry<String, String> entry) {
                            final year = entry.key;
                            final classId = entry.value;
                            return DropdownMenuItem<String>(
                              value: '$classId-$year',
                              // Display format changed to "Class (Year)"
                              child: Text('Class $classId ($year)'),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  )
                else
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: Text('No classes have been assigned to you yet.', style: TextStyle(fontSize: 16, color: Colors.black54)),
                    ),
                  ),

                const SizedBox(height: 24),

                Expanded(
                  child: _selectedClassYearId == null
                      ? const Center(child: Text('Please select a class to view students.'))
                      : teacherProvider.selectedClassStudents.isEmpty
                      ? const Center(child: Text('No students found for this class.'))
                      : ListView.builder(
                    itemCount: teacherProvider.selectedClassStudents.length,
                    itemBuilder: (context, index) {
                      final student = teacherProvider.selectedClassStudents[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name: ${student.name}',
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                              ),
                              const SizedBox(height: 8),
                              const Divider(height: 1, color: Colors.deepPurple),
                              const SizedBox(height: 12),
                              _buildStudentDetailRow('ID', student.id),
                              _buildStudentDetailRow('Gender', student.gender),
                              _buildStudentDetailRow('DOB', student.dob),
                              _buildStudentDetailRow('Contact', student.contact),
                              _buildStudentDetailRow('Parent Contact', student.parentContact),
                              _buildStudentDetailRow('Address', student.address),
                              _buildStudentDetailRow('Admission Date', student.admissionDate),
                              _buildStudentDetailRow('Class History', '${student.classHistory.length} entries'),
                              _buildStudentDetailRow('Class Records', '${student.classRecords.length} records'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStudentDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}