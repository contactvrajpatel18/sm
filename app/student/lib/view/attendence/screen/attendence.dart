import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:model/coman/selected_class_year.dart';
import 'package:model/student/classrecord_model.dart';
import 'package:model/student/student_model.dart';
import 'package:model/utils/loader.dart';
import 'package:provider/provider.dart';
import 'package:student/backend/student/student_controller.dart';
import 'package:student/backend/student/student_provider.dart';
import 'package:student/view/common/colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:model/utils/date.dart';


class Attendence extends StatefulWidget {
  const Attendence({super.key});

  @override
  State<Attendence> createState() => _AttendenceState();
}
class _AttendenceState extends State<Attendence> {
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  SelectedClassYear? selectedClassYear;

  late StudentProvider studentProvider;
  late StudentController studentController;

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
      studentController.fetchSingleStudentById(studentId: currentUserId!);
    }
  }

  Map<DateTime, String> attendanceMap(StudentModel studentData) {
    final Map<DateTime, String> attendanceMap = {};

    if (selectedClassYear == null) return attendanceMap;

    final classRecord = studentData.classRecords[selectedClassYear!.currentYear]?[selectedClassYear!.currentClass];

    if (classRecord == null) return attendanceMap;

    classRecord.attendance.forEach((monthString, days) {
      final parts = monthString.split('-');
      if (parts.length != 2) return;

      final year = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      if (year == null || month == null) return;

      days.forEach((dayString, status) {
        final day = int.tryParse(dayString);
        if (day != null) {
          final date = DateTime(year, month, day);
          attendanceMap[date] = status;
        }
      });
    });

    return attendanceMap;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title:  Text('Attendance'),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Consumer<StudentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return  Center(child: Loader());
          }

          if (provider.error != null) {
            return Center(
              child: Padding(
                padding:  EdgeInsets.all(16.0),
                child: Text(
                  "Error: ${provider.error}",
                  textAlign: TextAlign.center,
                  style:  TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
            );
          }

          if (provider.getSingleStudent.isEmpty) {
            return  Center(
              child: Text("No student profile found.", style: TextStyle(fontSize: 16)),
            );
          }

          final StudentModel studentData = provider.getSingleStudent.first;


          if (selectedClassYear == null && studentData.classHistory.isNotEmpty) {
            selectedClassYear = SelectedClassYear(
              currentClass: studentData.classHistory.last.classId,
              currentYear: studentData.classHistory.last.year,
            );
          }
          String currentRollNo = "Not assigned";
          ClassRecord? currentClassRecord;

          if (selectedClassYear != null) {
            currentClassRecord = studentData.classRecords[selectedClassYear!.currentYear]?[selectedClassYear!.currentClass];
            currentRollNo = currentClassRecord?.rollNo.toString() ?? "Not assigned";
          }

          final Map<DateTime, String> attendance = attendanceMap(studentData);

          int totalPresent = 0;
          int totalAbsent = 0;

          attendance.values.forEach((status) {
            if (status == 'P') {
              totalPresent++;
            } else if (status == 'A') {
              totalAbsent++;
            }
          });

          final int totalDays = totalPresent + totalAbsent;
          final double attendancePercentage = totalDays > 0 ? (totalPresent / totalDays) * 100 : 0.0;

          return ListView(
            padding:  EdgeInsets.all(16.0),
            children: [
              _buildClassAndRollHeader(studentData, currentRollNo),
               SizedBox(height: 20),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: TableCalendar(
                    firstDay: Date.stringToDateTime(studentData.admissionDate),
                    lastDay: Date.getCurrentDate(),
                    focusedDay: Date.getCurrentDate(),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: TextStyle(color: Colors.white),
                    ),
                    headerStyle:  HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        final normalizedDay = DateTime(day.year, day.month, day.day);
                        final status = attendance[normalizedDay];
                        if (status == 'P') {
                          return _buildAttendanceCell(day, Colors.green);
                        } else if (status == 'A') {
                          return _buildAttendanceCell(day, Colors.red);
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
               SizedBox(height: 24),
               Text(
                'Attendance Statistics',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
               SizedBox(height: 16),
              _buildStatsWrap(
                context,
                totalPresent,
                totalAbsent,
                totalDays,
                attendancePercentage,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildClassAndRollHeader(StudentModel student, String rollNumber) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding:  EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildClassSelectorDropdown(student)),
             SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                 Text(
                  'Roll No.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  rollNumber,
                  style:  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
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

  Widget _buildAttendanceCell(DateTime day, Color color) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        width: 36,
        height: 36,
        alignment: Alignment.center,
        child: Text(
          '${day.day}',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildStatsWrap(BuildContext context, int present, int absent, int total, double percentage) {
    final double screenWidth = MediaQuery.of(context).size.width;
     double horizontalPadding = 16.0 * 2;
     double cardSpacing = 12.0;
    final double cardWidth = (screenWidth - horizontalPadding - cardSpacing) / 2;

    return Wrap(
      spacing: cardSpacing,
      runSpacing: cardSpacing,
      children: [
        SizedBox(
          width: cardWidth,
          child: _buildStatCard(
            icon: Icons.check_circle_outline,
            label: 'Present',
            value: '$present days',
            color: Colors.green,
          ),
        ),
        SizedBox(
          width: cardWidth,
          child: _buildStatCard(
            icon: Icons.cancel_outlined,
            label: 'Absent',
            value: '$absent days',
            color: Colors.red,
          ),
        ),
        SizedBox(
          width: cardWidth,
          child: _buildStatCard(
            icon: Icons.calendar_today_outlined,
            label: 'Total Days',
            value: '$total days',
            color: Colors.blueGrey,
          ),
        ),
        SizedBox(
          width: cardWidth,
          child: _buildPercentageStatCard(
            label: 'Attendance Rate',
            percentage: percentage,
            color: Colors.teal,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({required IconData icon, required String label, required String value, required Color color}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 30),
             SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                 SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPercentageStatCard({required String label, required double percentage, required Color color}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.pie_chart_outline, color: color, size: 30),
                SizedBox(
                  width: 34,
                  height: 34,
                  child: CircularProgressIndicator(
                    value: percentage / 100,
                    strokeWidth: 4,
                    backgroundColor: color.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                 SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}