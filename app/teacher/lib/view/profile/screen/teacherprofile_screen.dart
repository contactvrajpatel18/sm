import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:model/teacher/teacher_model.dart';
import 'package:model/utils/loader.dart';
import 'package:provider/provider.dart';
import 'package:teacher/backend/teacher/teacher_controller.dart';
import 'package:teacher/backend/teacher/teacher_provider.dart';
import 'package:teacher/view/common/appbar_common.dart';

class TeacherProfileScreen extends StatefulWidget {
  const TeacherProfileScreen({super.key});

  @override
  State<TeacherProfileScreen> createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
  final Color primaryColor = const Color(0xFF6A5ACD); // Slate Blue
  final Color primaryTextColor = const Color(0xFF333333); // Dark Grey
  final Color secondaryTextColor = const Color(0xFF6c757d); // Muted Grey
  final Color successColor = const Color(0xFF28a745); // Green
  final Color errorColor = const Color(0xFFDC3545); // Red
  final Color screenBackground = const Color(0xfff5f7fa); // Light Greyish Blue

  final TeacherController teacherController = TeacherController();
  final String? teacherId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<TeacherProvider>(context, listen: false);

      if (provider.getteacherdata.isEmpty && teacherId != null) {
        teacherController.readTeacher(teacherId!, provider);
      }
    });
  }

  // Helper method to format the assigned classes map into a readable string
  String _formatAssignedClasses(Map<String, List<String>> assignedClasses) {
    if (assignedClasses.isEmpty) {
      return 'No classes assigned.';
    }

    final formattedEntries = assignedClasses.entries.map((entry) {
      final year = entry.key;
      final classes = entry.value.join(', ');
      return '$year: $classes';
    }).toList();

    return formattedEntries.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackground,
      appBar: AppbarCommon("Teacher Profile", showBack: true),
      body: Consumer<TeacherProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: Loader());
          }

          if (provider.getteacherdata.isEmpty) {
            return const Center(
              child: Text("No Teacher Data Found.", style: TextStyle(fontSize: 16)),
            );
          }

          final TeacherModel teacherData = provider.getteacherdata.first;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildProfileHeader(context, teacherData),
              const SizedBox(height: 24),
              _buildContactInfoCard(context, teacherData),
              const SizedBox(height: 16),
              _buildProfessionalInfoCard(context, teacherData),
              const SizedBox(height: 16),
              _buildPersonalInfoCard(context, teacherData),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, TeacherModel teacher) {
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
              backgroundImage: teacher.profileImageUrl.isNotEmpty ? NetworkImage(teacher.profileImageUrl) : null,
              child: teacher.profileImageUrl.isEmpty
                  ? Icon(
                Icons.person,
                size: 50,
                color: primaryColor,
              )
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              teacher.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryTextColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(teacher.isActive ? "Active" : "Inactive"),
              backgroundColor: teacher.isActive ? successColor.withOpacity(0.1) : errorColor.withOpacity(0.1),
              labelStyle: TextStyle(
                color: teacher.isActive ? successColor : errorColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Teacher ID: ${teacher.id}",
              style: TextStyle(fontSize: 14, color: secondaryTextColor),
            ),
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

  Widget _buildContactInfoCard(BuildContext context, TeacherModel teacherData) {
    return _buildInfoCardTemplate(
      title: "Contact Details",
      children: [
        _buildInfoTile(
          icon: Icons.phone_outlined,
          title: "Phone Number",
          value: teacherData.contact,
        ),
        _buildInfoTile(
          icon: Icons.email_outlined,
          title: "Email",
          value: teacherData.email,
        ),
      ],
    );
  }

  Widget _buildProfessionalInfoCard(BuildContext context, TeacherModel teacherData) {
    return _buildInfoCardTemplate(
      title: "Professional Information",
      children: [
        _buildInfoTile(
          icon: Icons.calendar_today_outlined,
          title: "Joining Date",
          value: teacherData.joiningDate,
        ),
        _buildInfoTile(
          icon: Icons.book_outlined,
          title: "Subjects Taught",
          value: teacherData.subjects.join(', '),
          isMultiLine: true,
        ),
        _buildInfoTile(
          icon: Icons.class_outlined,
          title: "Assigned Classes",
          value: _formatAssignedClasses(teacherData.assignedClasses), // Use the new helper method
          isMultiLine: true,
        ),
      ],
    );
  }

  Widget _buildPersonalInfoCard(BuildContext context, TeacherModel teacherData) {
    return _buildInfoCardTemplate(
      title: "Personal Information",
      children: [
        _buildInfoTile(
          icon: Icons.cake_outlined,
          title: "Date of Birth",
          value: teacherData.dob,
        ),
        _buildInfoTile(
          icon: Icons.wc_outlined,
          title: "Gender",
          value: teacherData.gender,
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