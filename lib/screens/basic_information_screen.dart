import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:login_portal/screens/student_address_update_screen.dart';

import '../controllers/student_controller.dart';

class BasicInformationScreen extends StatelessWidget {
  const BasicInformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final studentData = Get.find<StudentController>().student;
    final studentFullName = studentData['Student Full Name'];


    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    print('studentData:\n${const JsonEncoder.withIndent('  ').convert(studentData)}');
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
                        'Student Details',
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
                          builder: (_) => AddressUpdateScreen(
                            studentId: studentData['StudentID'].toString(),
                            fatherQatarId: studentData['FatherQatarID'].toString(),
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

          // Content Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildInfoTableCard(
                      context,
                      'Basic Information',
                      [
                        {'icon': Icons.person_outline, 'value': studentFullName},
                        {'icon': Icons.credit_card, 'value': studentData['QID']},
                        {'icon': Icons.calendar_today, 'value': studentData['DOB']},
                        {'icon': Icons.cake, 'value': studentData['Age'].toString()},
                        {'icon': Icons.auto_stories, 'value': studentData['ReligionID'] == '1' ? 'Islam' : 'Other'},
                      ],studentData
                    ),
                    const SizedBox(height: 16),
                    _buildInfoTableCard(
                      context,
                      'Address',
                      [
                        {'icon': Icons.numbers, 'value': studentData['UnitNo'].toString()},
                        {'icon': Icons.home, 'value': studentData['HosueNo']},
                        {'icon': Icons.signpost, 'value': studentData['StreetNo'].toString()},
                        {'icon': Icons.route, 'value': studentData['StreetName']},
                        {'icon': Icons.location_city, 'value': studentData['ZoneNo'].toString()},
                        {'icon': Icons.map, 'value': studentData['ZoneName']},
                        {'icon': Icons.markunread_mailbox, 'value': studentData['ZipCode'] ?? 'N/A'},
                        {'icon': Icons.apartment, 'value': studentData['FlatVilla'] == 0 ? 'Flat' : 'Villa'},
                        {'icon': Icons.business, 'value': studentData['CompoundName'] ?? 'N/A'},
                        {'icon': Icons.place, 'value': studentData['NearestLandmark'] ?? 'N/A'},
                        {'icon': Icons.location_city, 'value': studentData['City'].toString()},
                        {'icon': Icons.location_on, 'value': studentData['State'] ?? 'N/A'},
                      ], studentData
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

  Widget _buildInfoTableCard(BuildContext context, String title, List<Map<String, dynamic>> data, Map<String, dynamic> studentData) {
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
          children: <Widget>[
            Row(
              children: [
                Icon(
                  title == 'Basic Information' ? Icons.person_outline : Icons.home_outlined,
                  size: 20,
                  color: colorScheme.primary,
                ),
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
            const SizedBox(height: 16.0),

            if (title == 'Address')
              _buildBluePlateBox(
                context,
                studentData['HosueNo'].toString(),
                studentData['ZoneNo'].toString(),
                studentData['StreetNo'].toString(),
                studentData['UnitNo']?.toString(), // Pass unit number if present
              ),




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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, // Reduced from 12
                          vertical: 12.0,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            item['icon'],
                            color: colorScheme.primary,
                            size: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                          vertical: 12.0,
                        ),
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

  Widget _buildBluePlateBox(
      BuildContext context,
      String building,
      String zone,
      String street,
      [String? unitNo] // optional
      ) {
    final textTheme = Theme.of(context).textTheme;
    final isCompound = unitNo != null && unitNo.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: isCompound
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 🔹 Top: Unit Number Full Width
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Color(0xFF0026A6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: [
                Text(
                  'Unit Number',
                  style: textTheme.labelMedium?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  unitNo!,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 5),

          // 🔹 Bottom Row: Zone, Street, Building
          Row(
            children: [
              _buildBox('Zone', zone, textTheme),
              const SizedBox(width: 4),
              _buildBox('Street', street, textTheme),
              const SizedBox(width: 4),
              _buildBox('Building No', building, textTheme),
            ],
          ),
        ],
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 🟦 Standard: Building Full Width
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Color(0xFF0026A6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: [
                Text(
                  'Building No.',
                  style: textTheme.labelMedium?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  building,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),

          Row(
            children: [
              _buildBox('Zone', zone, textTheme),
              const SizedBox(width: 4),
              _buildBox('Street', street, textTheme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBox(String label, String value, TextTheme textTheme) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Color(0xFF0026A6),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
