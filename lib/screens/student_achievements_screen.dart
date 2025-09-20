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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Column(
        children: [
          // Header Bar
          Container(
            height: MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height * 0.12
                : MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16.0),
                bottomRight: Radius.circular(16.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 56.0, 16.0, 16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    'Student Achievements',
                    style: textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Body
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : hasError
                  ? const Center(child: Text("Error loading achievements data"))
                  : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildAchievementCard(context, "Leadership Roles", achievementsData['LeadershipRoles'] ?? []),
                    _buildAchievementCard(context, "Awards and Appreciations", achievementsData['AwardsAndAppreciations'] ?? []),
                    _buildAchievementCard(context, "Events and Awards", achievementsData['EventsAndAwards'] ?? []),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(BuildContext context, String title, List<dynamic> data) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorScheme.surfaceVariant,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              children: [
                Icon(Icons.star_rounded, size: 20, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: textTheme.titleLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Data Table
            data.isEmpty
                ? Text('No Data Available', style: TextStyle(color: Colors.grey.shade600))
                : Column(
              children: data.map<Widget>((item) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border.all(color: colorScheme.outlineVariant),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title == 'Leadership Roles') ...[
                        _buildItemRow("Role", item['LeadershipRole']),
                        _buildItemRow("Session", item['Session']),
                      ],
                      if (title == 'Awards and Appreciations') ...[
                        _buildItemRow("Type", item['AppreciationType']),
                        _buildItemRow("Awarded On", item['AwardingDate']),
                      ],
                      if (title == 'Events and Awards') ...[
                        _buildItemRow("Event", item['Event']),
                        _buildItemRow("Role", item['Role']),
                        _buildItemRow("Award", item['Award']),
                      ],
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

  Widget _buildItemRow(String label, String? value) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
