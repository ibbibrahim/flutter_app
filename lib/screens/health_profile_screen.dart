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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Column(
        children: [
          // App Bar
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        'Health Profile',
                        style: textTheme.headlineSmall?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
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
                      backgroundColor: colorScheme.onPrimary,
                      foregroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    icon: const Icon(Icons.edit, size: 18),
                    label: Text("Edit", style: textTheme.labelLarge),
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
                  ? Center(child: CircularProgressIndicator())
                  : hasError
                  ? Center(child: Text("Error loading health profile data"))
                  : SingleChildScrollView(
                child: _buildInfoCard(context, 'Health Profile', [
                  {'label': 'Health Card Number', 'value': healthData['HealthcardNumber'] ?? 'N/A'},
                  {'label': 'Blood Group', 'value': healthData['BloodGroup'] ?? 'N/A'},
                  {'label': 'Weight (kg)', 'value': healthData['WeightInKg']?.toString() ?? 'N/A'},
                  {'label': 'Height (feet)', 'value': healthData['HeightInFeet']?.toString() ?? 'N/A'},
                  {'label': 'Height (inches)', 'value': healthData['HeightInInches']?.toString() ?? 'N/A'},
                  {'label': 'BMI', 'value': healthData['StudentBMI']?.toString() ?? 'N/A'},
                  {'label': 'Illness / Medical conditions', 'value': parseHtmlString(healthData['Allergies'] ?? 'N/A'), 'highlight': true},
                  {'label': 'Allergies / Medication', 'value': parseHtmlString(healthData['Precautions'] ?? 'N/A'), 'highlight': true},
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, List<Map<String, dynamic>> data) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorScheme.surfaceVariant,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.health_and_safety, size: 20, color: colorScheme.primary),
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
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: colorScheme.surface,
                border: Border.all(color: colorScheme.outlineVariant, width: 1),
              ),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.5),
                  1: FlexColumnWidth(2.5),
                },
                children: data.map((item) {
                  final highlight = item['highlight'] == true;
                  return TableRow(
                    decoration: BoxDecoration(
                      color: highlight ? Colors.red.shade100 : Colors.transparent,
                      border: Border(
                        bottom: BorderSide(
                          color: colorScheme.outlineVariant,
                          width: 1,
                        ),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                        child: Text(
                          item['label'],
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 12.0),
                        child: Text(
                          item['value'],
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
