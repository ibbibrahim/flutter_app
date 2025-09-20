import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';

import 'package:login_portal/controllers/student_controller.dart';
import 'package:login_portal/screens/swipeable_calendar_view.dart';
import 'package:login_portal/utils/funtions.dart';

import 'dashboard_screen/dashboard_screen.dart';
import 'home_container_screen/controller/bottom_controller.dart';

class AttendanceScreen extends StatefulWidget {
  AttendanceScreen({Key? key}) : super(key: key);

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<Map<String, dynamic>> attendanceData = [];
  List<Map<String, dynamic>> sessions = [];
  String selectedSessionId = '';
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await fetchSessions();
    await fetchAttendanceData();
  }

  Future<void> fetchSessions() async {
    try {
      final response = await http.get(Uri.parse(
        'https://pers.tngqatar.online/Controler/Public/PerspectiveApi.php?Action=${generateMd5Hash('getAcademicSessions')}',
      ));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        if (data.isNotEmpty) {
          setState(() {
            sessions = List<Map<String, dynamic>>.from(data);
            selectedSessionId = data.last['id'].toString(); // default to current
          });
        }
      }
    } catch (e) {
      print("Error loading sessions: $e");
    }
  }

  Future<void> fetchAttendanceData() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    final sc = Get.find<StudentController>();
    final studentId = sc.student['StudentID'].toString();

    try {
      final response = await http.get(
        Uri.parse(
          'https://pers.tngqatar.online/Controler/Public/PerspectiveApi.php?Action=${generateMd5Hash('getStudentAttendance')}&student_id=$studentId&session_id=$selectedSessionId',
        ),
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          attendanceData = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height * 0.1
                : MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(2.0, 40.0, 16.0, 16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: handleBackButton,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'Attendance',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Session dropdown
          if (sessions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                children: [
                  Text("Session:", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButton<String>(
                      value: selectedSessionId,
                      isExpanded: true,
                      items: sessions.map((session) {
                        final isSelected = session['id'].toString() == selectedSessionId;
                        return DropdownMenuItem<String>(
                          value: session['id'].toString(),
                          child: Text(
                            session['name'],
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.blue : Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedSessionId = value;
                          });
                          fetchAttendanceData();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

          // Attendance data
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : hasError
                  ? Center(child: Text("Error loading attendance data"))
                  : attendanceData.isEmpty
                  ? Center(child: Text("No attendance data available for this session."))
                  : SingleChildScrollView(
                child: _buildAttendanceTable(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: attendanceData.length,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          itemBuilder: (context, index) {
            final monthData = attendanceData[index];
            final String month = monthData['month'];
            final int present = monthData['present_count'];
            final int absent = monthData['absent_count'];

            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SwipeableCalendarView(
                        attendanceData: attendanceData,
                        initialIndex: index,
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        month.substring(0, 3),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('$present',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold)),
                            Text('Present',
                                style: TextStyle(color: Colors.green)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('$absent',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold)),
                            Text('Absent', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void handleBackButton() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      final bottomCtrl = Get.find<BottomBarController>();
      bottomCtrl.selectedIndex.value = 0;
      bottomCtrl.onChange(DashboardScreen());
      bottomCtrl.update();
    }
  }

}
