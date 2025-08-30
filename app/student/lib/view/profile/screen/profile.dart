import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:model/class/class_model.dart';
import 'package:model/coman/selected_class_year.dart';
import 'package:provider/provider.dart';
import 'package:model/student/classrecord_model.dart';
import 'package:model/student/student_model.dart';
import 'package:student/backend/class/class_controller.dart';
import 'package:student/backend/class/class_provider.dart';
import 'package:student/backend/student/student_controller.dart';
import 'package:student/backend/student/student_provider.dart';
import 'package:model/utils/loader.dart';
import 'package:student/view/common/appbar_common.dart';
import 'package:student/view/common/colors.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  SelectedClassYear? selectedClassYear;

  late StudentProvider studentProvider;
  late StudentController studentController;
  late ClassProvider classProvider;
  late ClassController classController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadStudentAndClassData();
    });
  }

  void loadStudentAndClassData() {

    studentProvider = Provider.of<StudentProvider>(context, listen: false);
    studentController = StudentController(studentProvider);

    if (studentProvider.getSingleStudent.isEmpty && currentUserId != null) {
      studentController.fetchSingleStudent(studentId: currentUserId!);
    }

    classProvider = Provider.of<ClassProvider>(context, listen: false);
    classController = ClassController(classProvider);

    if (classProvider.getclassdata.isEmpty) {
      classController.fetchAllClass();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackground,
      appBar: AppbarCommon("Student Profile", showBack: true),
      body: Consumer2<StudentProvider, ClassProvider>(
        builder: (context, studentProvider,classProvider, child) {
          if (studentProvider.isLoading) {
            return  Center(child: Loader());
          }

          if (studentProvider.error != null) {
            return Center(
              child: Text(
                studentProvider.error!,
                style:  TextStyle(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (studentProvider.getSingleStudent.isEmpty) {
            return  Center(child: Text("No student data found"));
          }

          final StudentModel studentData = studentProvider.getSingleStudent.first;

          final List<ClassModel> classData = classProvider.getclassdata;

          if (selectedClassYear == null && studentData.classHistory.isNotEmpty) {
            selectedClassYear = SelectedClassYear(
              currentClass: studentData.classHistory.last.classId,
              currentYear: studentData.classHistory.last.year,
            );
          }

          int currentTotlaFee = 0;
          String currentRollNo = "Not assigned";
          ClassRecord? currentClassRecord;

          if (selectedClassYear != null) {
            final classByYear = classData.firstWhere(
                  (c) => c.id == selectedClassYear!.currentYear,
              orElse: () =>
                  ClassModel(id: selectedClassYear!.currentYear, classes: {}),
            );

            currentTotlaFee = classByYear.classes[selectedClassYear!.currentClass]?.fee ?? 0;

            currentClassRecord = studentData.classRecords[selectedClassYear!.currentYear]?[selectedClassYear!.currentClass];

            currentRollNo = currentClassRecord?.rollNo.toString() ?? "Not assigned";
          }

          return ListView(
            padding:  EdgeInsets.all(16),
            children: [
              _buildProfileHeader(studentData),
               SizedBox(height: 24),
              if (studentData.classHistory.isNotEmpty) ...[
                _buildClassSelectorDropdown(studentData),
                 SizedBox(height: 16),
              ],
              _buildFeeStatusCard(currentClassRecord,currentTotlaFee),
               SizedBox(height: 16),
              _buildAcademicInfoCard(studentData, currentRollNo),
               SizedBox(height: 16),
              _buildPersonalInfoCard(studentData),
               SizedBox(height: 16),
              _buildContactInfoCard(studentData),
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
        padding:  EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: primaryColor.withOpacity(0.1),
              backgroundImage: student.profileImageUrl.isNotEmpty
                  ? NetworkImage(student.profileImageUrl)
                  : null,
              child: student.profileImageUrl.isEmpty
                  ? Icon(Icons.person, size: 50, color: primaryColor)
                  : null,
            ),
             SizedBox(height: 16),
            Text(
              student.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
             SizedBox(height: 8),
            if (selectedClassYear != null)
              Chip(
                label: Text("Class ${selectedClassYear!.currentClass} (${selectedClassYear!.currentYear})"),
                backgroundColor: primaryColor.withOpacity(0.1),
                labelStyle: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
             SizedBox(height: 8),
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
    return DropdownButtonFormField<SelectedClassYear>(
      value: selectedClassYear,
      decoration: InputDecoration(
        labelText: 'Select Class',
        fillColor: Colors.white,
        filled: true,
        labelStyle: TextStyle(color: primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding:  EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      items: studentData.classHistory.map((classData) {
        final selection = SelectedClassYear(
          currentClass: classData.classId,
          currentYear: classData.year,
        );
        return DropdownMenuItem<SelectedClassYear>(
          value: selection,
          child: Text("Class ${classData.classId} (${classData.year})"),
        );
      }).toList(),
      onChanged: (SelectedClassYear? newValue) {
        if (newValue != null) {
          setState(() {
            selectedClassYear = newValue;
          });
        }
      },
    );
  }

  Widget _buildFeeStatusCard(ClassRecord? classRecord,int totalFee) {
    if (classRecord == null) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child:  Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("No fee data available for this class."),
        ),
      );
    }

    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    final feeStatus = classRecord.feeStatus;

    final double paidPercentage = totalFee > 0
        ? feeStatus.paid / totalFee
        : 0.0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Fee Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
            ),
            Text(
                "Status for Class: ${selectedClassYear!.currentClass} (${selectedClassYear!.currentYear})",
                style: TextStyle(fontSize: 14, color: secondaryTextColor),
            ),
             Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Paid: ${currencyFormat.format(feeStatus.paid)}',
                  style: TextStyle(
                    fontSize: 16,
                    color: successColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Due: ${currencyFormat.format(feeStatus.due)}',
                  style: TextStyle(
                    fontSize: 16,
                    color: feeStatus.due > 0 ? errorColor : primaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
             SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: paidPercentage,
                minHeight: 12,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(successColor),
              ),
            ),
             SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text('Total Fees: ${currencyFormat.format(totalFee)}'),
            ),
             Divider(height: 24),
            Text(
              "Payment History",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: primaryTextColor,
              ),
            ),
             SizedBox(height: 8),
            if (classRecord.feePayments.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "No payments made for this class yet.",
                  style: TextStyle(color: secondaryTextColor),
                ),
              ),
            ...classRecord.feePayments.map(
              (payment) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.receipt_long,
                  color: primaryColor.withOpacity(0.8),
                ),
                title: Text("Paid ${currencyFormat.format(payment.amount)}"),
                subtitle: Text("on ${payment.date} via ${payment.mode}"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCardTemplate({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
            ),
            Divider(height: 20),
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

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    bool isMultiLine = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: primaryColor, size: 24),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      subtitle: Text(
        value.isNotEmpty ? value : 'Not available',
        style: TextStyle(
          fontSize: 15,
          color: value.isNotEmpty ? secondaryTextColor : Colors.grey[500],
        ),
      ),
      isThreeLine: isMultiLine,
    );
  }
}
