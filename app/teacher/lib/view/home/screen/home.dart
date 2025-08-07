// import 'package:flutter/material.dart';
// import 'package:teacher/view/common/appbar_home.dart';
// import 'package:teacher/view/common/drawer.dart';
//
// class Home extends StatefulWidget {
//   const Home({super.key});
//
//   @override
//   State<Home> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<Home> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       drawer: Drawerr(),
//       appBar: AppbarHome(),
//
//       body: Center(
//         child: Text('Home Screen', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//       ),
//     );
//   }
// }


// lib/screens/teacher_home_screen.dart
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:teacher/backend/student/student_controller.dart';
// import 'package:teacher/backend/teacher/teacher_controller.dart';
//
//
// class TeacherHomeScreen extends StatefulWidget {
//
//   const TeacherHomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
// }
//
//
// class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
//   final StudentController _firestoreService = StudentController();
//   final TeacherController _fi = TeacherController();
//   final String? teacherId = FirebaseAuth.instance.currentUser?.uid;
//
//   List<String> _assignedClasses = [];
//   String? _selectedClassId;
//   List<Map<String, dynamic>> _studentsInClass = [];
//   bool _isLoading = true;
//   String _errorMessage = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchTeacherData();
//   }
//
//   Future<void> _fetchTeacherData() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//     });
//     try {
//       final teacherData = await _fi.getTeacher(teacherId!);
//       if (teacherData != null && teacherData.containsKey('assignedClasses')) {
//         _assignedClasses = List<String>.from(teacherData['assignedClasses']);
//         if (_assignedClasses.isNotEmpty) {
//           setState(() {
//             _selectedClassId = _assignedClasses.first; // Select the first class by default
//           });
//           _fetchStudentsForSelectedClass(_selectedClassId!);
//         } else {
//           setState(() {
//             _isLoading = false;
//           });
//         }
//       } else {
//         setState(() {
//           _errorMessage = 'Teacher data not found or no assigned classes.';
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error fetching teacher data: $e';
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _fetchStudentsForSelectedClass(String classId) async {
//     setState(() {
//       _isLoading = true;
//       _studentsInClass = []; // Clear previous students
//     });
//     try {
//       final studentIds = await _firestoreService.getStudentsInClass(classId);
//       if (studentIds.isNotEmpty) {
//         final studentsData = await _firestoreService.getStudentsByIds(studentIds);
//         setState(() {
//           _studentsInClass = studentsData;
//         });
//       } else {
//         setState(() {
//           _studentsInClass = []; // No students found
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error fetching students for class: $e';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Teacher Home'),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _errorMessage.isNotEmpty
//           ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)))
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Select Class:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             _assignedClasses.isEmpty
//                 ? const Text('No classes assigned.')
//                 : DropdownButton<String>(
//               value: _selectedClassId,
//               hint: const Text('Choose a class'),
//               onChanged: (String? newValue) {
//                 if (newValue != null) {
//                   setState(() {
//                     _selectedClassId = newValue;
//                   });
//                   _fetchStudentsForSelectedClass(newValue);
//                 }
//               },
//               items: _assignedClasses
//                   .map<DropdownMenuItem<String>>((String classId) {
//                 return DropdownMenuItem<String>(
//                   value: classId,
//                   child: Text(classId),
//                 );
//               }).toList(),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Students in Selected Class:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: _studentsInClass.isEmpty
//                   ? const Center(child: Text('No students found in this class.'))
//                   : ListView.builder(
//                 itemCount: _studentsInClass.length,
//                 itemBuilder: (context, index) {
//                   final student = _studentsInClass[index];
//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Name: ${student['name'] ?? 'N/A'}',
//                             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                           ),
//                           Text('Gender: ${student['gender'] ?? 'N/A'}'),
//                           Text('DOB: ${student['dob'] ?? 'N/A'}'),
//                           Text('Contact: ${student['contact'] ?? 'N/A'}'),
//                           Text('Parent Contact: ${student['parentContact'] ?? 'N/A'}'),
//                           // You can add more student details here
//                           // Example: Show current roll number from classRecords
//                           if (student['classRecords'] != null && _selectedClassId != null)
//                             Text('Roll No (${_selectedClassId!}): '
//                                 '${student['classRecords'][_selectedClassId!]?['rollNo'] ?? 'N/A'}'),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// screens/teacher_home_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:model/class/class_model.dart';
import 'package:model/student/student_model.dart';
import 'package:model/teacher/teacher_model.dart';
import 'package:provider/provider.dart';
import 'package:teacher/backend/class/class_controller.dart';
import 'package:teacher/backend/class/class_provider.dart';
import 'package:teacher/backend/student/student_controller.dart';
import 'package:teacher/backend/teacher/teacher_controller.dart';
import 'package:teacher/backend/teacher/teacher_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedClassId;
  final TeacherController _teacherController = TeacherController();
  final ClassController _classDataController = ClassController();
  final StudentController _studentDataController = StudentController();

  final String? teacherId = FirebaseAuth.instance.currentUser?.uid;

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

  // Function to load students for a selected class - now uses the new, more direct approach
  Future<void> _loadStudentsForClass(String classId) async {
    final teacherProvider = Provider.of<TeacherProvider>(context, listen: false);
    final classDataProvider = Provider.of<ClassProvider>(context, listen: false);

    teacherProvider.setLoading(true);
    classDataProvider.setLoading(true); // Set loading for the class data provider as well

    try {
      // 1. Fetch the ClassModel directly from the controller
      final ClassModel? selectedClass = await _classDataController.getClassById(classId);

      if (selectedClass != null) {
        // 2. Set the ClassProvider's data explicitly
        classDataProvider.setClassData([selectedClass]);

        // 3. Get the list of student IDs
        final List<String> studentIds = selectedClass.students;

        // 4. Fetch StudentDataModels using the student IDs
        final List<StudentModel> students = await _studentDataController.getStudentsByIds(studentIds);

        // 5. Update the TeacherProvider with the fetched students
        teacherProvider.setSelectedClassStudents(students);
      } else {
        teacherProvider.setSelectedClassStudents([]);
        teacherProvider.setError('No class data found for the selected class.');
        classDataProvider.setError('No class data found for the selected class.');
      }
    } catch (e) {
      teacherProvider.setError('Failed to load students: $e');
      classDataProvider.setError('Failed to load students: $e');
    } finally {
      teacherProvider.setLoading(false);
      classDataProvider.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Teacher Home', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
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

          final List<String> assignedClasses = currentTeacher.assignedClasses;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome message
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

                // Class selection dropdown
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
                    value: _selectedClassId,
                    hint: const Text('Choose a Class'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedClassId = newValue;
                        if (newValue != null) {
                          _loadStudentsForClass(newValue);
                        } else {
                          teacherProvider.setSelectedClassStudents([]);
                        }
                      });
                    },
                    items: assignedClasses.map<DropdownMenuItem<String>>((String classId) {
                      return DropdownMenuItem<String>(
                        value: classId,
                        child: Text('Class $classId'),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                Expanded(
                  child: (teacherProvider.selectedClassStudents.isEmpty && _selectedClassId != null)
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
                              // Header with Name and ID
                              Text(
                                'Name: ${student.name}',
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                              ),
                              const SizedBox(height: 8),
                              const Divider(height: 1, color: Colors.deepPurple),
                              const SizedBox(height: 12),

                              // Key details in a structured layout
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

  // Helper function to build a consistent row for student details
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
