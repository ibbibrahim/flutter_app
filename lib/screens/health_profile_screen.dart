import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

import 'package:login_portal/utils/funtions.dart';
import 'package:login_portal/screens/student_health_update_screen.dart';

class HealthProfileScreen extends StatefulWidget {
  final String studentId;
  final String fatherQatarId;

  HealthProfileScreen({required this.studentId, required this.fatherQatarId});

  @override
  _HealthProfileScreenState createState() => _HealthProfileScreenState();
}
class _HealthProfileScreenState extends State<HealthProfileScreen> {
  Map<String, dynamic> healthData = {};
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchHealthData();
  }

  Future<void> fetchHealthData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://pers.tngqatar.online/Controler/Public/PerspectiveApi.php?Action=${generateMd5Hash('getStudentHealthProfile')}&student_id=${widget.studentId}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          healthData = Map<String, dynamic>.from(data);
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        'Health Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StudentHealthProfileScreen(
                            studentId: widget.studentId,
                            fatherQatarId: widget.fatherQatarId,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 2,
                    ),
                    icon: Icon(Icons.edit, size: 18),
                    label: Text("Edit", style: TextStyle(fontSize: 14)),
                  ),
                ],
              )
              ,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : hasError
                  ? Center(child: Text("Error loading health profile data"))
                  : SingleChildScrollView( // Wrap content with SingleChildScrollView
                child: _buildInfoTableCard('Health Profile Details', [
                  ['Health Card Number', healthData['HealthcardNumber'] ?? 'N/A'],
                  ['Blood Group', healthData['BloodGroup'] ?? 'N/A'],
                  ['Weight (kg)', healthData['WeightInKg']?.toString() ?? 'N/A'],
                  ['Height (feet)', healthData['HeightInFeet']?.toString() ?? 'N/A'],
                  ['Height (inches)', healthData['HeightInInches']?.toString() ?? 'N/A'],
                  ['BMI', healthData['StudentBMI']?.toString() ?? 'N/A'],
                  ['Illness / Medical conditions', parseHtmlString(healthData['Allergies'] ?? 'N/A')],
                  ['Allergies / Medication', parseHtmlString(healthData['Precautions'] ?? 'N/A')],
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTableCard(String title, List<List<String>> data) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 16.0),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
              },
              border: TableBorder.all(color: Colors.grey[300]!),
              children: data.map((row) {
                // Apply light red background to entire row for 'Allergies' and 'Precautions'
                if (row[0] == 'Illness / Medical conditions' || row[0] == 'Allergies / Medication') {
                  return TableRow(
                    decoration: BoxDecoration(
                      color: Colors.red[100], // Light red background for the entire row
                    ),
                    children: row.map((cell) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          cell,
                          style: TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return TableRow(
                    children: row.map((cell) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          cell,
                          style: TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                  );
                }
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
