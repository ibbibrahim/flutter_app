import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

import 'package:login_portal/utils/funtions.dart';

class StudentAchievementsScreen extends StatefulWidget {
  final String studentId;

  StudentAchievementsScreen({required this.studentId});

  @override
  _StudentAchievementsScreenState createState() => _StudentAchievementsScreenState();
}

class _StudentAchievementsScreenState extends State<StudentAchievementsScreen> {
  Map<String, dynamic> achievementsData = {};
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchAchievementsData();
  }

  Future<void> fetchAchievementsData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://pers.tngqatar.online/Controler/Public/PerspectiveApi.php?Action=${generateMd5Hash('getStudentAchievements')}&student_id=${widget.studentId}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          achievementsData = Map<String, dynamic>.from(data);
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
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'Student Achievements',
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : hasError
                  ? Center(child: Text("Error loading achievements data"))
                  : SingleChildScrollView(
                child: Column(
                  children: [
                    _buildAchievementSection(
                      'Leadership Roles',
                      achievementsData['LeadershipRoles'] ?? [],
                    ),
                    _buildAchievementSection(
                      'Awards and Appreciations',
                      achievementsData['AwardsAndAppreciations'] ?? [],
                    ),
                    _buildAchievementSection(
                      'Events and Awards',
                      achievementsData['EventsAndAwards'] ?? [],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementSection(String title, List<dynamic> data) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 16.0),
            data.isEmpty
                ? Text('No Data Available', style: TextStyle(color: Colors.grey))
                : Column(
              children: data.map<Widget>((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title == 'Leadership Roles')
                        Text('Role: ${item['LeadershipRole']}, Session: ${item['Session']}'),
                      if (title == 'Awards and Appreciations')
                        Text('Type: ${item['AppreciationType']}, Awarded on: ${item['AwardingDate']}'),
                      if (title == 'Events and Awards')
                        Text('Event: ${item['Event']}, Role: ${item['Role']}, Award: ${item['Award']}'),
                      SizedBox(height: 4),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
