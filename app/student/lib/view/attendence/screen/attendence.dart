import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:model/student/student_model.dart';
import 'package:model/utils/loader.dart';
import 'package:provider/provider.dart';
import 'package:student/backend/student/student_controller.dart';
import 'package:student/backend/student/student_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:model/utils/date.dart';
import 'package:model/student/classhistory_model.dart';

class Attendence extends StatefulWidget {
  const Attendence({super.key});

  @override
  State<Attendence> createState() => _AttendenceState();
}

class _AttendenceState extends State<Attendence> {
  final String? _currentUserId = FirebaseAuth.instance.currentUser?.uid;

  String? _selectedClassId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final studentProvider = Provider.of<StudentProvider>(context, listen: false);
      final StudentController _controller = StudentController(studentProvider);

      if (studentProvider.getSingleStudent.isEmpty && _currentUserId != null) {
        _controller.getSingleStudent(studentId: _currentUserId!);
      }
    });
  }

  Map<DateTime, String> _parseAttendance(StudentModel student) {
    final Map<DateTime, String> attendanceMap = {};

    if (_selectedClassId != null) {
      final String? selectedYear = student.classHistory.firstWhere(
            (h) => h.classId == _selectedClassId,
        orElse: () => ClassHistory(year: '', classId: '', result: ''),
      ).year;

      if (selectedYear != null && selectedYear.isNotEmpty) {
        final classRecordsForYear = student.classRecords[selectedYear];
        if (classRecordsForYear != null) {
          final classRecord = classRecordsForYear[_selectedClassId];
          if (classRecord != null) {
            classRecord.attendance.forEach((monthString, days) {
              final parts = monthString.split('-');
              if (parts.length == 2) {
                final year = int.tryParse(parts[0]);
                final month = int.tryParse(parts[1]);
                if (year != null && month != null) {
                  days.forEach((dayString, status) {
                    final day = int.tryParse(dayString);
                    if (day != null) {
                      final date = DateTime(year, month, day);
                      attendanceMap[date] = status;
                    }
                  });
                }
              }
            });
          }
        }
      }
    }
    return attendanceMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Attendance'),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Consumer<StudentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: Loader());
          }

          if (provider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Error: ${provider.error}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
            );
          }

          if (provider.getSingleStudent.isEmpty) {
            return const Center(
              child: Text("No student profile found.", style: TextStyle(fontSize: 16)),
            );
          }

          final StudentModel student = provider.getSingleStudent.first;

          if (_selectedClassId == null && student.classHistory.isNotEmpty) {
            _selectedClassId = student.classHistory.last.classId;
          }

          final Map<DateTime, String> dynamicAttendanceMap = _parseAttendance(student);

          int totalPresent = 0;
          int totalAbsent = 0;
          dynamicAttendanceMap.values.forEach((status) {
            if (status == 'P') {
              totalPresent++;
            } else if (status == 'A') {
              totalAbsent++;
            }
          });

          final int totalDays = totalPresent + totalAbsent;
          final double attendancePercentage = totalDays > 0 ? (totalPresent / totalDays) * 100 : 0.0;

          final String? selectedYear = student.classHistory.firstWhere(
                (h) => h.classId == _selectedClassId,
            orElse: () => ClassHistory(year: '', classId: '', result: ''),
          ).year;

          String rollNumber = 'N/A';
          if (selectedYear != null && selectedYear.isNotEmpty && student.classRecords.containsKey(selectedYear)) {
            final classRecord = student.classRecords[selectedYear]?[_selectedClassId];
            if (classRecord != null) {
              rollNumber = classRecord.rollNo.toString();
            }
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildClassAndRollHeader(student, rollNumber),
              const SizedBox(height: 20),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TableCalendar(
                    firstDay: Date.stringToDateTime(student.admissionDate),
                    lastDay: Date.getCurrentDate(),
                    focusedDay: Date.getCurrentDate(),
                    calendarStyle: const CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: TextStyle(color: Colors.white),
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        final normalizedDay = DateTime(day.year, day.month, day.day);
                        final status = dynamicAttendanceMap[normalizedDay];
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
              const SizedBox(height: 24),
              const Text(
                'Attendance Statistics',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
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
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildClassSelectorDropdown(student)),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Roll No.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  rollNumber,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassSelectorDropdown(StudentModel student) {
    return DropdownButtonFormField<String>(
      value: _selectedClassId,
      decoration: InputDecoration(
        labelText: 'Select Class',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: student.classHistory.map((classData) {
        return DropdownMenuItem<String>(
          value: classData.classId,
          child: Text("Class ${classData.classId} (${classData.year})"),
        );
      }).toList().reversed.toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedClassId = newValue;
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
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildStatsWrap(BuildContext context, int present, int absent, int total, double percentage) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double horizontalPadding = 16.0 * 2;
    const double cardSpacing = 12.0;
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
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
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
        padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
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