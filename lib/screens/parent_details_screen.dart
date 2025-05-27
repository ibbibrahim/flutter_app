import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

import '../controllers/student_controller.dart';

class ParentDetailsScreen extends StatelessWidget {
  const ParentDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final studentData = Get.find<StudentController>().student;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Column(
        children: [
          // App Bar Section
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
                    icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    'Parent Details',
                    style: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Parent Info Cards
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoCard(
                      context,
                      title: 'Father\'s Details',
                      icon: Icons.man,
                        data: [
                          {
                            'icon': Icons.person,
                            'value': studentData['Father Full Name'] ?? 'N/A'
                          },
                          {
                            'icon': Icons.badge, // for QID
                            'value': studentData['FatherQatarID'] ?? 'N/A'
                          },
                          {
                            'icon': Icons.work, // occupation
                            'value': studentData['FatherOccupation'] ?? 'N/A'
                          },
                          {
                            'icon': Icons.auto_stories, // religion
                            'value': studentData['ReligionID'] == '1' ? 'Islam' : 'Other'
                          },
                          {
                            'icon': Icons.flag, // nationality
                            'value': studentData['Nationality'] ?? 'N/A'
                          },

                          {
                            'icon': Icons.email_outlined, // primary email
                            'value': studentData['FatherEmail1'] ?? 'N/A'
                          },
                          {
                            'icon': Icons.alternate_email, // secondary email
                            'value': studentData['FatherEmail2'] ?? 'N/A'
                          },

                          {
                            'icon': Icons.phone_android, // mobile
                            'value': studentData['FatherCellPhone'] ?? 'N/A'
                          },
                          {
                            'icon': Icons.phone, // landline
                            'value': studentData['FatherHomePhone'] ?? 'N/A'
                          },
                        ]

                    ),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      context,
                      title: 'Mother\'s Details',
                      icon: Icons.woman,
                      data: [
                        {
                          'icon': Icons.person,
                          'value': studentData['Mother Name'] ?? 'N/A'
                        },
                        {
                          'icon': Icons.badge, // QID
                          'value': studentData['MotherQatarID'] ?? 'N/A'
                        },
                        {
                          'icon': Icons.work_outline, // Occupation (if available)
                          'value': studentData['MotherOccupation'] ?? 'N/A'
                        },
                        {
                          'icon': Icons.auto_stories, // Religion
                          'value': studentData['ReligionID'] == '1' ? 'Islam' : 'Other'
                        },
                        {
                          'icon': Icons.flag, // Nationality
                          'value': studentData['Nationality'] ?? 'N/A'
                        },
                        {
                          'icon': Icons.email_outlined,
                          'value': studentData['MotherEmail1'] ?? 'N/A'
                        },
                        {
                          'icon': Icons.phone_android,
                          'value': studentData['MotherCellPhone'] ?? 'N/A'
                        },
                        {
                          'icon': Icons.phone, // Home phone if any (optional)
                          'value': studentData['MotherHomePhone'] ?? 'N/A'
                        },
                      ],

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

  Widget _buildInfoCard(BuildContext context, {
    required String title,
    required IconData icon,
    required List<Map<String, dynamic>> data,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: colorScheme.surfaceVariant,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: colorScheme.primary),
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
                border: Border.all(
                  color: colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.5),
                  1: FlexColumnWidth(2.5),
                },
                children: data.map((item) {
                  return TableRow(
                    decoration: BoxDecoration(
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
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(item['icon'], color: colorScheme.primary, size: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 12.0),
                        child: Text(
                          item['value'].toString(),
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
