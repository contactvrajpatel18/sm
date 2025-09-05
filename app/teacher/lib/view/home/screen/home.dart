// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:model/coman/selected_class_year.dart';
// import 'package:model/student/student_model.dart';
// import 'package:model/teacher/teacher_model.dart';
// import 'package:provider/provider.dart';
// import 'package:teacher/backend/class/class_controller.dart';
// import 'package:teacher/backend/class/class_provider.dart';
// import 'package:teacher/backend/student/student_controller.dart';
// import 'package:teacher/backend/student/student_provider.dart';
// import 'package:teacher/backend/teacher/teacher_controller.dart';
// import 'package:teacher/backend/teacher/teacher_provider.dart';
// import 'package:teacher/view/common/appbar_home.dart';
// import 'package:teacher/view/common/drawer.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//
//   SelectedClassYear? selectedClassYear;
//
//
//   late TeacherProvider teacherProvider;
//   late TeacherController teacherController;
//
//   late StudentProvider studentProvider;
//   late StudentController studentController;
//
//   late ClassProvider classProvider;
//   late ClassController classController;
//
//   // final TeacherController _teacherController = TeacherController();
//   // final StudentController _studentDataController = StudentController();
//   // final ClassController _classDataController = ClassController();
//
//
//   final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
//   bool _isInitialLoadComplete = false;
//
//
//   final StudentController studentDataController = StudentController();
//   final ClassController classDataController = ClassController();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       loadTeacherData();
//     });
//   }
//
//
//   void loadTeacherData() {
//
//     teacherProvider = Provider.of<TeacherProvider>(context, listen: false);
//     teacherController = TeacherController(teacherProvider);
//     if (teacherProvider.getSingleTeacher.isEmpty && currentUserId != null) {
//       teacherController.fetchSingleTeacher(teacherId: currentUserId!);
//     }
//
//
//   }
//
//
//   void loadInitialClass(TeacherModel teacher) {
//     if (_isInitialLoadComplete) return;
//
//     final List<MapEntry<String, String>> assignedClassEntries = [];
//     teacher.assignedClasses.forEach((year, classIds) {
//       for (var classId in classIds) {
//         assignedClassEntries.add(MapEntry(year, classId));
//       }
//     });
//
//     if (assignedClassEntries.isNotEmpty) {
//       final initialEntry = assignedClassEntries.first;
//       final initialUniqueId = "${initialEntry.value}-${initialEntry.key}";
//
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         setState(() {
//           selectedClassYear!.currentClass = initialUniqueId;
//         });
//         loadStudentsForClass(teacher, initialEntry.value, initialEntry.key);
//       });
//       _isInitialLoadComplete = true;
//     }
//   }
//
//   Future<void> loadStudentsForClass(TeacherModel teacher, String classId, String classYear) async {
//     teacherProvider.setLoading(true);
//
//     try {
//       final classDoc = await classDataController.getClassByYear(classYear);
//       List<String> studentIds = [];
//
//       if (classDoc != null && classDoc.classes.containsKey(classId)) {
//         final classInfo = classDoc.classes[classId];
//         if (classInfo != null) {
//           studentIds = classInfo.students;
//         }
//       } else {
//         teacherProvider.setSelectedClassStudents([]);
//       }
//
//       final List<StudentModel> students = await studentDataController.getStudentsByIds(studentIds);
//       teacherProvider.setSelectedClassStudents(students);
//
//     } catch (e) {
//       teacherProvider.setError('Failed to load students: $e');
//     } finally {
//       teacherProvider.setLoading(false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       drawer: const Drawerr(),
//       appBar: const AppbarHome(),
//       body: Consumer<TeacherProvider>(
//
//
//         builder: (context, teacherProvider, child) {
//           if (teacherProvider.isLoading) {
//             return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
//           }
//           if (teacherProvider.error != null) {
//             return Center(child: Text('Error: ${teacherProvider.error}', style: const TextStyle(color: Colors.red)));
//           }
//
//           final TeacherModel? currentTeacher = teacherProvider.getSingleTeacher.isNotEmpty
//               ? teacherProvider.getSingleTeacher.first
//               : null;
//
//           if (currentTeacher == null) {
//             return const Center(child: Text('No teacher data found.'));
//           }
//
//           loadInitialClass(currentTeacher);
//
//           final List<MapEntry<String, String>> assignedClassEntries = [];
//           currentTeacher.assignedClasses.forEach((year, classIds) {
//             for (var classId in classIds) {
//               assignedClassEntries.add(MapEntry(year, classId));
//             }
//           });
//
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//                   decoration: BoxDecoration(
//                     color: Colors.deepPurple.shade50,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     'Welcome, ${currentTeacher.name}!',
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.deepPurple,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//
//                 if (assignedClassEntries.isNotEmpty)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('Select a Class:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
//                       const SizedBox(height: 8),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(color: Colors.deepPurple, width: 1.5),
//                         ),
//                         child: DropdownButton<SelectedClassYear>(
//                           isExpanded: true,
//                           underline: const SizedBox(),
//                           value: selectedClassYear,
//                           hint: const Text('Choose a Class'),
//                           onChanged: (SelectedClassYear newValue) {
//                             setState(() {
//                               selectedClassYear = newValue;
//                             });
//                             if (newValue != null) {
//                              _loadStudentsForClass(currentTeacher, classId, year);
//                             } else {
//                               teacherProvider.setSelectedClassStudents([]);
//                             }
//                           },
//                           items: assignedClassEntries.map<DropdownMenuItem<String>>((MapEntry<String, String> entry) {
//                             final year = entry.key;
//                             final classId = entry.value;
//                             return DropdownMenuItem<String>(
//                               value: '$classId-$year',
//                               child: Text('Class $classId ($year)'),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ],
//                   )
//                 else
//                   const Padding(
//                     padding: EdgeInsets.symmetric(vertical: 20.0),
//                     child: Center(
//                       child: Text('No classes have been assigned to you yet.', style: TextStyle(fontSize: 16, color: Colors.black54)),
//                     ),
//                   ),
//
//                 const SizedBox(height: 24),
//
//                 Expanded(
//                   child: _selectedClassYearId == null
//                       ? const Center(child: Text('Please select a class to view students.'))
//                       : teacherProvider.selectedClassStudents.isEmpty
//                       ? const Center(child: Text('No students found for this class.'))
//                       : ListView.builder(
//                     itemCount: teacherProvider.selectedClassStudents.length,
//                     itemBuilder: (context, index) {
//                       final student = teacherProvider.selectedClassStudents[index];
//                       return Card(
//                         margin: const EdgeInsets.symmetric(vertical: 8.0),
//                         elevation: 6,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(20.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Name: ${student.name}',
//                                 style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
//                               ),
//                               const SizedBox(height: 8),
//                               const Divider(height: 1, color: Colors.deepPurple),
//                               const SizedBox(height: 12),
//                               _buildStudentDetailRow('ID', student.id),
//                               _buildStudentDetailRow('Gender', student.gender),
//                               _buildStudentDetailRow('DOB', student.dob),
//                               _buildStudentDetailRow('Contact', student.contact),
//                               _buildStudentDetailRow('Parent Contact', student.parentContact),
//                               _buildStudentDetailRow('Address', student.address),
//                               _buildStudentDetailRow('Admission Date', student.admissionDate),
//                               _buildStudentDetailRow('Class History', '${student.classHistory.length} entries'),
//                               _buildStudentDetailRow('Class Records', '${student.classRecords.length} records'),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildStudentDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '$label:',
//             style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(color: Colors.black54),
//             ),
//           ),
//         ],
//       ),
//     );
//
//
//   }
// }


/*

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
      
      print("Fetching teacher data for ID: $currentUserId");
      print(teacherProvider.getSingleTeacher);
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
      final classDoc = await classController.fetchClassByYear(year: year);

      if (classDoc == null || !classDoc.classes.containsKey(classId)) {
        studentProvider.setSingleStudent([]);
        return;
      }

      final studentIds = classDoc.classes[classId]?.students ?? [];
      await studentController.fetchStudentsByIds(studentIds);

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
            return  Center(child: Loader());
          }

          if (teacherProvider.error != null) {
            return Center(
              child: Text(
                teacherProvider.error!,
                style:  TextStyle(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (teacherProvider.getSingleTeacher.isEmpty) {
            return  Center(child: Text("No data found"));
          }

          final TeacherModel teacher = teacherProvider.getSingleTeacher.first;

          loadInitialClass(teacher);

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
                    style: TextStyle(fontSize: 16, color: Colors.black54),
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
        if (studentProvider.getSingleStudent.isEmpty) {
          return const Center(child: Text("No students found for this class."));
        }

        return ListView.builder(
          itemCount: studentProvider.getSingleStudent.length,
          itemBuilder: (context, index) {
            final student = studentProvider.getSingleStudent[index];
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
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:model/class/class_model.dart';
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

  // Future<void> loadStudentsForClass(String classId, String year) async {
  //   teacherProvider.setLoading(true);
  //   try {
  //
  //     final classDoc = await classController.fetchClassByYear(year: year);
  //     print("classDoc : $classDoc");
  //
  //     print(classDoc!.classes);
  //     print(classDoc!.classes.containsKey(classId));
  //
  //     if (classDoc == null || !classDoc.classes.containsKey(classId)) {
  //       print(classDoc!.classes);
  //       print(classDoc!.classes.containsKey(classId));
  //       studentProvider.setSingleStudent([]);
  //       return;
  //     }
  //
  //     final studentIds = classDoc.classes[classId]?.students ?? [];
  //     await studentController.fetchStudentsByIds(studentIds);
  //   } catch (e) {
  //     teacherProvider.setError("Failed to load students: $e");
  //   } finally {
  //     teacherProvider.setLoading(false);
  //   }
  // }

  // Future<void> loadStudentsForClass(String classId, String year) async {
  //   teacherProvider.setLoading(true);
  //   try {
  //     await classController.fetchClassByYear(year: year);
  //     if (classProvider.getclassdata.isNotEmpty) {
  //       final studentIds = classProvider.getclassdata.first.classes[classId]?.students;
  //       await studentController.fetchStudentsByIds(studentIds!);
  //     }
  //   } catch (e) {
  //     teacherProvider.setError("Failed to load students: $e");
  //   } finally {
  //     teacherProvider.setLoading(false);
  //   }
  // }


  // Future<void> loadStudentsForClass(String classId, String year) async {
  //   teacherProvider.setLoading(true);
  //   try {
  //     await classController.addfetchClassByYear(year: year);
  //     if (classProvider.getclassdata.isNotEmpty) {
  //       // print(classProvider.getclassdata);
  //       // print("classProvider.getclassdata : ${classProvider.getclassdata}");
  //
  //
  //       final s = classProvider.getclassdata.first.classes[classId]?.students;
  //       print(s);
  //
  //
  //
  //       final classByYear = classProvider.getclassdata
  //           .firstWhere((c) => c.id.toString() == year, orElse: () => null);
  //
  //       if (classByYear == null) {
  //         teacherProvider.setError("No data found for year $year");
  //         return ;
  //       }
  //
  //       final studentIds = classByYear.classes[classId]?.students;
  //
  //
  //
  //       await studentController.fetchStudentsByIds(studentIds!);
  //     }
  //   } catch (e) {
  //     teacherProvider.setError("Failed to load students: $e");
  //   } finally {
  //     teacherProvider.setLoading(false);
  //   }
  // }


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
         print("classProvider.getclassdata ${classProvider.getclassdata}");
        final studentIds = classByYear.classes[classId]?.students;
        if (studentIds == null || studentIds.isEmpty) {
          teacherProvider.setError("No students found for class $classId in $year");
          return;
        }

        await studentController.addFetchStudentsByIds(studentIds);
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

          // ✅ Safe initialization (instead of calling in build directly)
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
        if (studentProvider.getSingleStudent.isEmpty) {
          return const Center(child: Text("No students found for this class."));
        }

        return ListView.builder(
          itemCount: studentProvider.getSingleStudent.length,
          itemBuilder: (context, index) {
            final student = studentProvider.getSingleStudent[index];
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
