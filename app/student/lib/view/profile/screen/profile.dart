import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:model/student/student_model.dart';
import 'package:model/utils/loader.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:student/backend/student/student_controller.dart';
import 'package:student/backend/student/student_provider.dart';
import 'package:student/view/common/appbar_common.dart';

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

  final StudentController studentController = StudentController();
  final String? id = FirebaseAuth.instance.currentUser?.uid;
  String selectedClassId = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final studentProvider = Provider.of<StudentProvider>(context, listen: false);

      if (studentProvider.getSingleStudent.isEmpty && id != null) {
        studentController.readSingleStudent(studentId: id!,studentProvider: studentProvider);
      }
    });
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

          if (provider.getSingleStudent.isEmpty) {
            return const Center(
              child: Text("No Student Data Found.", style: TextStyle(fontSize: 16)),
            );
          }

          final StudentModel singleStudent = provider.getSingleStudent.first;

          if (selectedClassId.isEmpty && singleStudent.classHistory.isNotEmpty) {
            selectedClassId = singleStudent.classHistory.last.classId;
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildProfileHeader(context, singleStudent),
              const SizedBox(height: 24),
              if (singleStudent.classHistory.isNotEmpty) ...[
                _buildSelectedClassSelectorDropdown(singleStudent),
                const SizedBox(height: 16),
              ],
              _buildFeeStatusCard(context, singleStudent),
              const SizedBox(height: 16),
              _buildAcademicInfoCard(context, singleStudent),
              const SizedBox(height: 16),
              _buildPersonalInfoCard(context, singleStudent),
              const SizedBox(height: 16),
              _buildContactInfoCard(context, singleStudent),
            ],
          );
        },
      ),
    );
  }


  Widget _buildProfileHeader(BuildContext context, StudentModel profile) {
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
              backgroundImage: profile.profileImageUrl.isNotEmpty ? NetworkImage(profile.profileImageUrl) : null,
              child: profile.profileImageUrl.isEmpty
                  ? Icon(
                Icons.person,
                size: 50,
                color: primaryColor,
              )
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              profile.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryTextColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            if (selectedClassId.isNotEmpty)
              Chip(
                label: Text("Class: $selectedClassId"),
                backgroundColor: primaryColor.withOpacity(0.1),
                labelStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
              ),
            const SizedBox(height: 8),
            Text(
              "Admission No: ${profile.id}",
              style: TextStyle(fontSize: 14, color: secondaryTextColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedClassSelectorDropdown(StudentModel studentdata) {
    return DropdownButtonFormField<String>(
      value: selectedClassId,
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
      items: studentdata.classHistory.map((classData) {
        return DropdownMenuItem<String>(
          value: classData.classId,
          child: Text("Class ${classData.classId} (${classData.year})"),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            selectedClassId = newValue;
          });
        }
      },
    );
  }

  Widget _buildFeeStatusCard(BuildContext context, StudentModel profile) {
    if (selectedClassId.isEmpty) return const SizedBox.shrink();

    final classRecord = profile.classRecords[selectedClassId];
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    if (classRecord == null) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("No fee data available for Class: $selectedClassId"),
        ),
      );
    }

    final feeStatus = classRecord.feeStatus;
    final double paidPercentage = feeStatus.total > 0 ? feeStatus.paid / feeStatus.total : 0;

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
              "Status for Class: $selectedClassId",
              style: TextStyle(fontSize: 14, color: secondaryTextColor),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Paid: ${currencyFormat.format(feeStatus.paid)}', style: TextStyle(fontSize: 16, color: successColor, fontWeight: FontWeight.bold)),
                Text('Due: ${currencyFormat.format(feeStatus.due)}', style: TextStyle(fontSize: 16, color: feeStatus.due > 0 ? errorColor : primaryTextColor, fontWeight: FontWeight.bold)),
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
              child: Text('Total Fees: ${currencyFormat.format(feeStatus.total)}'),
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

  Widget _buildAcademicInfoCard(BuildContext context, StudentModel studentdata) {
    return _buildInfoCardTemplate(
      title: "Academic Information",
      children: [
        _buildInfoTile(
          icon: Icons.format_list_numbered_rtl_outlined,
          title: "Roll Number",
          value: studentdata.classRecords[selectedClassId]?.rollNo.toString() ?? "Not assigned",
        ),
        _buildInfoTile(
          icon: Icons.calendar_today_outlined,
          title: "Admission Date",
          value: studentdata.admissionDate,
        ),
      ],
    );
  }

  Widget _buildPersonalInfoCard(BuildContext context, StudentModel studentdata) {
    return _buildInfoCardTemplate(
      title: "Personal Information",
      children: [
        _buildInfoTile(
          icon: Icons.cake_outlined,
          title: "Date of Birth",
          value: studentdata.dob,
        ),
        _buildInfoTile(
          icon: Icons.wc_outlined,
          title: "Gender",
          value: studentdata.gender,
        ),
        _buildInfoTile(
          icon: Icons.home_outlined,
          title: "Address",
          value: studentdata.address,
          isMultiLine: true,
        ),
      ],
    );
  }

  Widget _buildContactInfoCard(BuildContext context, StudentModel studentdata) {
    return _buildInfoCardTemplate(
      title: "Contact Details",
      children: [
        _buildInfoTile(
          icon: Icons.phone_outlined,
          title: "Student Contact",
          value: studentdata.contact,
        ),
        _buildInfoTile(
          icon: Icons.supervisor_account_outlined,
          title: "Parent Contact",
          value: studentdata.parentContact,
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