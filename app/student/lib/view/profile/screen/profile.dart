// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// // Your Model Imports
// import 'package:model/student/classhistory_model.dart';
// import 'package:model/student/classrecord_model.dart';
// import 'package:model/student/student_model.dart';
//
// // Your Provider and Controller Imports
// import 'package:student/backend/student/student_controller.dart';
// import 'package:student/backend/student/student_provider.dart';
//
// // Your Common Widgets
// import 'package:model/utils/loader.dart';
// import 'package:student/view/common/appbar_common.dart';
//
// import '../../../backend/class/class_controller.dart';
//
// class Profile extends StatefulWidget {
//   const Profile({super.key});
//
//   @override
//   State<Profile> createState() => _ProfileState();
// }
//
// class _ProfileState extends State<Profile> {
//   final Color primaryColor = const Color(0xFF6A5ACD);
//   final Color primaryTextColor = const Color(0xFF333333);
//   final Color secondaryTextColor = const Color(0xFF6c757d);
//   final Color successColor = const Color(0xFF28a745);
//   final Color errorColor = const Color(0xFFDC3545);
//   final Color screenBackground = const Color(0xfff5f7fa);
//
//   final StudentController _studentController = StudentController();
//   final ClassController _classController = ClassController();
//   final String? _currentUserId = FirebaseAuth.instance.currentUser?.uid;
//   String _selectedClassId = "";
//   int _classFee = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _fetchStudentData();
//     });
//   }
//
//   void _fetchStudentData() {
//     final studentProvider = Provider.of<StudentProvider>(context, listen: false);
//     if (studentProvider.getSingleStudent.isEmpty && _currentUserId != null) {
//       _studentController.readSingleStudent(studentId: _currentUserId!, studentProvider: studentProvider);
//     }
//   }
//
//   void _fetchClassFee(String classId, StudentModel student) async {
//     final classModel = await _classController.getClassById(classId);
//     if (classModel != null) {
//       try {
//         final year = student.classHistory.firstWhere((h) => h.classId == classId).year;
//         final classInfo = classModel.years[year]?.classes[classId];
//         if (classInfo != null) {
//           setState(() {
//             _classFee = classInfo.fee;
//           });
//         }
//       } catch (e) {
//         setState(() {
//           _classFee = 0;
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: screenBackground,
//       appBar: AppbarCommon("Student Profile", showBack: true),
//       body: Consumer<StudentProvider>(
//         builder: (context, provider, child) {
//           if (provider.isLoading) {
//             return const Center(child: Loader());
//           }
//
//           if (provider.error != null) {
//             return Center(
//               child: Text(
//                 provider.error!,
//                 style: const TextStyle(fontSize: 16, color: Colors.red),
//                 textAlign: TextAlign.center,
//               ),
//             );
//           }
//
//           if (provider.getSingleStudent.isEmpty) {
//             return const Center(
//               child: Text("No Student Data Found.", style: TextStyle(fontSize: 16)),
//             );
//           }
//
//           final StudentModel student = provider.getSingleStudent.first;
//
//           // Set initial class and fetch fee on first load
//           if (_selectedClassId.isEmpty && student.classHistory.isNotEmpty) {
//             _selectedClassId = student.classHistory.last.classId;
//             _fetchClassFee(_selectedClassId, student);
//           }
//
//           // CORRECTED: Get the year from classHistory to access the nested map
//           final String? currentYear = student.classHistory
//               .firstWhere(
//                 (h) => h.classId == _selectedClassId,
//             orElse: () => ClassHistory(year: '', classId: '', result: ''),
//           )
//               .year;
//
//           ClassRecord? currentClassRecord;
//           if (currentYear != null && currentYear.isNotEmpty) {
//             currentClassRecord = student.classRecords[currentYear]?[_selectedClassId];
//           }
//
//           final String rollNo = currentClassRecord?.rollNo.toString() ?? "Not assigned";
//
//           return ListView(
//             padding: const EdgeInsets.all(16.0),
//             children: [
//               _buildProfileHeader(student),
//               const SizedBox(height: 24),
//               if (student.classHistory.isNotEmpty) ...[
//                 _buildClassSelectorDropdown(student),
//                 const SizedBox(height: 16),
//               ],
//               _buildFeeStatusCard(currentClassRecord),
//               const SizedBox(height: 16),
//               _buildAcademicInfoCard(student, rollNo),
//               const SizedBox(height: 16),
//               _buildPersonalInfoCard(student),
//               const SizedBox(height: 16),
//               _buildContactInfoCard(student),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildProfileHeader(StudentModel student) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             CircleAvatar(
//               radius: 50,
//               backgroundColor: primaryColor.withOpacity(0.1),
//               backgroundImage: student.profileImageUrl.isNotEmpty ? NetworkImage(student.profileImageUrl) : null,
//               child: student.profileImageUrl.isEmpty
//                   ? Icon(
//                 Icons.person,
//                 size: 50,
//                 color: primaryColor,
//               )
//                   : null,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               student.name,
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryTextColor),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 8),
//             if (_selectedClassId.isNotEmpty)
//               Chip(
//                 label: Text("Class: $_selectedClassId"),
//                 backgroundColor: primaryColor.withOpacity(0.1),
//                 labelStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
//               ),
//             const SizedBox(height: 8),
//             Text(
//               "Admission No: ${student.id}",
//               style: TextStyle(fontSize: 14, color: secondaryTextColor),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildClassSelectorDropdown(StudentModel studentData) {
//     return DropdownButtonFormField<String>(
//       value: _selectedClassId.isEmpty && studentData.classHistory.isNotEmpty
//           ? studentData.classHistory.last.classId
//           : _selectedClassId.isEmpty ? null : _selectedClassId,
//       decoration: InputDecoration(
//         labelText: 'Select Class',
//         fillColor: Colors.white,
//         filled: true,
//         labelStyle: TextStyle(color: primaryColor),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: primaryColor, width: 2),
//         ),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       ),
//       items: studentData.classHistory.map((classData) {
//         return DropdownMenuItem<String>(
//           value: classData.classId,
//           child: Text("Class ${classData.classId} (${classData.year})"),
//         );
//       }).toList(),
//       onChanged: (String? newValue) {
//         if (newValue != null) {
//           setState(() {
//             _selectedClassId = newValue;
//           });
//           _fetchClassFee(newValue, studentData);
//         }
//       },
//     );
//   }
//
//   Widget _buildFeeStatusCard(ClassRecord? classRecord) {
//     if (classRecord == null) {
//       return Card(
//         elevation: 2,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: const Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Text("No fee data available for this class."),
//         ),
//       );
//     }
//
//     final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
//     final feeStatus = classRecord.feeStatus;
//
//     final totalFee = _classFee > 0 ? _classFee : (feeStatus.paid + feeStatus.due);
//     final double paidPercentage = totalFee > 0 ? feeStatus.paid / totalFee : 0.0;
//
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Fee Details",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor),
//             ),
//             Text(
//               "Status for Class: $_selectedClassId",
//               style: TextStyle(fontSize: 14, color: secondaryTextColor),
//             ),
//             const Divider(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Paid: ${currencyFormat.format(feeStatus.paid)}',
//                   style: TextStyle(fontSize: 16, color: successColor, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   'Due: ${currencyFormat.format(feeStatus.due)}',
//                   style: TextStyle(fontSize: 16, color: feeStatus.due > 0 ? errorColor : primaryTextColor, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: LinearProgressIndicator(
//                 value: paidPercentage,
//                 minHeight: 12,
//                 backgroundColor: Colors.grey[300],
//                 valueColor: AlwaysStoppedAnimation<Color>(successColor),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Align(
//               alignment: Alignment.centerRight,
//               child: Text('Total Fees: ${currencyFormat.format(totalFee)}'),
//             ),
//             const Divider(height: 24),
//             Text("Payment History", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: primaryTextColor)),
//             const SizedBox(height: 8),
//             if (classRecord.feePayments.isEmpty)
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Text("No payments made for this class yet.", style: TextStyle(color: secondaryTextColor)),
//               ),
//             ...classRecord.feePayments.map((payment) => ListTile(
//               contentPadding: EdgeInsets.zero,
//               leading: Icon(Icons.receipt_long, color: primaryColor.withOpacity(0.8)),
//               title: Text("Paid ${currencyFormat.format(payment.amount)}"),
//               subtitle: Text("on ${payment.date} via ${payment.mode}"),
//             )),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoCardTemplate({required String title, required List<Widget> children}) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor),
//             ),
//             const Divider(height: 20),
//             ...children,
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAcademicInfoCard(StudentModel student, String rollNo) {
//     return _buildInfoCardTemplate(
//       title: "Academic Information",
//       children: [
//         _buildInfoTile(
//           icon: Icons.format_list_numbered_rtl_outlined,
//           title: "Roll Number",
//           value: rollNo,
//         ),
//         _buildInfoTile(
//           icon: Icons.calendar_today_outlined,
//           title: "Admission Date",
//           value: student.admissionDate,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPersonalInfoCard(StudentModel student) {
//     return _buildInfoCardTemplate(
//       title: "Personal Information",
//       children: [
//         _buildInfoTile(
//           icon: Icons.cake_outlined,
//           title: "Date of Birth",
//           value: student.dob,
//         ),
//         _buildInfoTile(
//           icon: Icons.wc_outlined,
//           title: "Gender",
//           value: student.gender,
//         ),
//         _buildInfoTile(
//           icon: Icons.home_outlined,
//           title: "Address",
//           value: student.address,
//           isMultiLine: true,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildContactInfoCard(StudentModel student) {
//     return _buildInfoCardTemplate(
//       title: "Contact Details",
//       children: [
//         _buildInfoTile(
//           icon: Icons.phone_outlined,
//           title: "Student Contact",
//           value: student.contact,
//         ),
//         _buildInfoTile(
//           icon: Icons.supervisor_account_outlined,
//           title: "Parent Contact",
//           value: student.parentContact,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildInfoTile({required IconData icon, required String title, required String value, bool isMultiLine = false}) {
//     return ListTile(
//       contentPadding: EdgeInsets.zero,
//       leading: Icon(icon, color: primaryColor, size: 24),
//       title: Text(
//         title,
//         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//       ),
//       subtitle: Text(
//         value.isNotEmpty ? value : 'Not available',
//         style: TextStyle(fontSize: 15, color: value.isNotEmpty ? secondaryTextColor : Colors.grey[500]),
//       ),
//       isThreeLine: isMultiLine,
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Your Model Imports
import 'package:model/student/classhistory_model.dart';
import 'package:model/student/classrecord_model.dart';
import 'package:model/student/student_model.dart';
import 'package:model/class/class_model.dart'; // Import the correct ClassModel

// Your Provider and Controller Imports
import 'package:student/backend/student/student_controller.dart';
import 'package:student/backend/student/student_provider.dart';

// Your Common Widgets
import 'package:model/utils/loader.dart';
import 'package:student/view/common/appbar_common.dart';

import '../../../backend/class/class_controller.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Color primaryColor = const Color(0xFF6A5ACD);
  final Color primaryTextColor = const Color(0xFF333333);
  final Color secondaryTextColor = const Color(0xFF6c757d);
  final Color successColor = const Color(0xFF28a745);
  final Color errorColor = const Color(0xFFDC3545);
  final Color screenBackground = const Color(0xfff5f7fa);

  final StudentController _studentController = StudentController();
  final ClassController _classController = ClassController();
  final String? _currentUserId = FirebaseAuth.instance.currentUser?.uid;
  String _selectedClassId = "";
  int _classFee = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchStudentData();
    });
  }

  void _fetchStudentData() {
    final studentProvider = Provider.of<StudentProvider>(context, listen: false);
    if (studentProvider.getSingleStudent.isEmpty && _currentUserId != null) {
      _studentController.readSingleStudent(studentId: _currentUserId!, studentProvider: studentProvider);
    }
  }

  void _fetchClassFee(String classId, StudentModel student) async {
    // Correctly get the year for the selected class from class history
    final String? classYear = student.classHistory
        .firstWhere(
          (h) => h.classId == classId,
      orElse: () => ClassHistory(year: '', classId: '', result: ''),
    )
        .year;

    // Check if the year is valid
    if (classYear == null || classYear.isEmpty) {
      setState(() {
        _classFee = 0;
      });
      return;
    }

    // Now, call the corrected ClassController method to get the data for that year.
    // Assuming your ClassController.getClassById has been updated to accept a year
    // and return the new simplified ClassModel.
    final ClassModel? classModel = await _classController.getClassByYear(classYear);

    if (classModel != null) {
      final classInfo = classModel.classes[classId]; // CORRECTED line
      if (classInfo != null) {
        setState(() {
          _classFee = classInfo.fee;
        });
      }
    } else {
      // Handle the case where the class document for the year doesn't exist
      setState(() {
        _classFee = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackground,
      appBar: AppbarCommon("Student Profile", showBack: true),
      body: Consumer<StudentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: Loader());
          }

          if (provider.error != null) {
            return Center(
              child: Text(
                provider.error!,
                style: const TextStyle(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (provider.getSingleStudent.isEmpty) {
            return const Center(
              child: Text("No Student Data Found.", style: TextStyle(fontSize: 16)),
            );
          }

          final StudentModel student = provider.getSingleStudent.first;

          if (_selectedClassId.isEmpty && student.classHistory.isNotEmpty) {
            _selectedClassId = student.classHistory.last.classId;
            _fetchClassFee(_selectedClassId, student);
          }

          final String? currentYear = student.classHistory
              .firstWhere(
                (h) => h.classId == _selectedClassId,
            orElse: () => ClassHistory(year: '', classId: '', result: ''),
          )
              .year;

          ClassRecord? currentClassRecord;
          if (currentYear != null && currentYear.isNotEmpty) {
            currentClassRecord = student.classRecords[currentYear]?[_selectedClassId];
          }

          final String rollNo = currentClassRecord?.rollNo.toString() ?? "Not assigned";

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildProfileHeader(student),
              const SizedBox(height: 24),
              if (student.classHistory.isNotEmpty) ...[
                _buildClassSelectorDropdown(student),
                const SizedBox(height: 16),
              ],
              _buildFeeStatusCard(currentClassRecord),
              const SizedBox(height: 16),
              _buildAcademicInfoCard(student, rollNo),
              const SizedBox(height: 16),
              _buildPersonalInfoCard(student),
              const SizedBox(height: 16),
              _buildContactInfoCard(student),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(StudentModel student) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: primaryColor.withOpacity(0.1),
              backgroundImage: student.profileImageUrl.isNotEmpty ? NetworkImage(student.profileImageUrl) : null,
              child: student.profileImageUrl.isEmpty
                  ? Icon(
                Icons.person,
                size: 50,
                color: primaryColor,
              )
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              student.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryTextColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            if (_selectedClassId.isNotEmpty)
              Chip(
                label: Text("Class: $_selectedClassId"),
                backgroundColor: primaryColor.withOpacity(0.1),
                labelStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
              ),
            const SizedBox(height: 8),
            Text(
              "Admission No: ${student.id}",
              style: TextStyle(fontSize: 14, color: secondaryTextColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassSelectorDropdown(StudentModel studentData) {
    return DropdownButtonFormField<String>(
      value: _selectedClassId.isEmpty && studentData.classHistory.isNotEmpty
          ? studentData.classHistory.last.classId
          : _selectedClassId.isEmpty ? null : _selectedClassId,
      decoration: InputDecoration(
        labelText: 'Select Class',
        fillColor: Colors.white,
        filled: true,
        labelStyle: TextStyle(color: primaryColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: studentData.classHistory.map((classData) {
        return DropdownMenuItem<String>(
          value: classData.classId,
          child: Text("Class ${classData.classId} (${classData.year})"),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedClassId = newValue;
          });
          _fetchClassFee(newValue, studentData);
        }
      },
    );
  }

  Widget _buildFeeStatusCard(ClassRecord? classRecord) {
    if (classRecord == null) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("No fee data available for this class."),
        ),
      );
    }

    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    final feeStatus = classRecord.feeStatus;

    final totalFee = _classFee > 0 ? _classFee : (feeStatus.paid + feeStatus.due);
    final double paidPercentage = totalFee > 0 ? feeStatus.paid / totalFee : 0.0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Fee Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor),
            ),
            Text(
              "Status for Class: $_selectedClassId",
              style: TextStyle(fontSize: 14, color: secondaryTextColor),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Paid: ${currencyFormat.format(feeStatus.paid)}',
                  style: TextStyle(fontSize: 16, color: successColor, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Due: ${currencyFormat.format(feeStatus.due)}',
                  style: TextStyle(fontSize: 16, color: feeStatus.due > 0 ? errorColor : primaryTextColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: paidPercentage,
                minHeight: 12,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(successColor),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text('Total Fees: ${currencyFormat.format(totalFee)}'),
            ),
            const Divider(height: 24),
            Text("Payment History", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: primaryTextColor)),
            const SizedBox(height: 8),
            if (classRecord.feePayments.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text("No payments made for this class yet.", style: TextStyle(color: secondaryTextColor)),
              ),
            ...classRecord.feePayments.map((payment) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.receipt_long, color: primaryColor.withOpacity(0.8)),
              title: Text("Paid ${currencyFormat.format(payment.amount)}"),
              subtitle: Text("on ${payment.date} via ${payment.mode}"),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCardTemplate({required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor),
            ),
            const Divider(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildAcademicInfoCard(StudentModel student, String rollNo) {
    return _buildInfoCardTemplate(
      title: "Academic Information",
      children: [
        _buildInfoTile(
          icon: Icons.format_list_numbered_rtl_outlined,
          title: "Roll Number",
          value: rollNo,
        ),
        _buildInfoTile(
          icon: Icons.calendar_today_outlined,
          title: "Admission Date",
          value: student.admissionDate,
        ),
      ],
    );
  }

  Widget _buildPersonalInfoCard(StudentModel student) {
    return _buildInfoCardTemplate(
      title: "Personal Information",
      children: [
        _buildInfoTile(
          icon: Icons.cake_outlined,
          title: "Date of Birth",
          value: student.dob,
        ),
        _buildInfoTile(
          icon: Icons.wc_outlined,
          title: "Gender",
          value: student.gender,
        ),
        _buildInfoTile(
          icon: Icons.home_outlined,
          title: "Address",
          value: student.address,
          isMultiLine: true,
        ),
      ],
    );
  }

  Widget _buildContactInfoCard(StudentModel student) {
    return _buildInfoCardTemplate(
      title: "Contact Details",
      children: [
        _buildInfoTile(
          icon: Icons.phone_outlined,
          title: "Student Contact",
          value: student.contact,
        ),
        _buildInfoTile(
          icon: Icons.supervisor_account_outlined,
          title: "Parent Contact",
          value: student.parentContact,
        ),
      ],
    );
  }

  Widget _buildInfoTile({required IconData icon, required String title, required String value, bool isMultiLine = false}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: primaryColor, size: 24),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      subtitle: Text(
        value.isNotEmpty ? value : 'Not available',
        style: TextStyle(fontSize: 15, color: value.isNotEmpty ? secondaryTextColor : Colors.grey[500]),
      ),
      isThreeLine: isMultiLine,
    );
  }
}