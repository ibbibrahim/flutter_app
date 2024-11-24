import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AttendanceScreen extends StatefulWidget {
  final String studentId;

  AttendanceScreen({required this.studentId});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<Map<String, dynamic>> attendanceData = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchAttendanceData();
  }

  Future<void> fetchAttendanceData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://pers.tngqatar.online/Controler/Public/PerspectiveApi.php?Action=${_generateMd5Token('getStudentAttendance')}&student_id=${widget.studentId}',
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

  String _generateMd5Token(String secretKey) {
    final date = DateTime.now();
    final formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    final tokenInput = "$secretKey$formattedDate";
    return md5.convert(utf8.encode(tokenInput)).toString().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: isLoading
                  ? _buildSkeletonLoader()
                  : hasError
                  ? Center(child: Text("Error loading attendance data"))
                  : SingleChildScrollView(
                child: _buildAttendanceTable(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
              onPressed: () {
                Navigator.pop(context);
              },
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
    );
  }

  Widget _buildAttendanceTable() {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Attendance Record',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 16.0),
            Column(
              children: attendanceData.map((monthData) {
                String month = monthData['month'];
                int presentCount = monthData['present_count'];
                int absentCount = monthData['absent_count'];
                List dailyRecords = monthData['daily_records'];

                return ExpansionTile(
                  title: Text('$month'),
                  subtitle: Text('Present: $presentCount, Absent: $absentCount'),
                  children: dailyRecords.map<Widget>((dailyRecord) {
                    return ListTile(
                      title: Text(dailyRecord['date']),
                      subtitle: Text(dailyRecord['status']),
                      tileColor: dailyRecord['status'].contains('Absent')
                          ? Colors.red[100]
                          : Colors.white,
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          Container(
            height: 24,
            width: double.infinity,
            color: Colors.blueAccent,
            margin: EdgeInsets.symmetric(vertical: 8.0),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 20,
                        width: double.infinity,
                        color: Colors.grey[300],
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: 16,
                        width: 100,
                        color: Colors.grey[300],
                        margin: EdgeInsets.symmetric(vertical: 4.0),
                      ),
                      SizedBox(height: 16),
                      for (int i = 0; i < 4; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            height: 16,
                            width: double.infinity,
                            color: Colors.grey[300],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
