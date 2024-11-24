import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

import 'package:login_portal/utils/funtions.dart';

class BusDetailsScreen extends StatefulWidget {
  final String studentId;

  BusDetailsScreen({required this.studentId});

  @override
  _BusDetailsScreenState createState() => _BusDetailsScreenState();
}

class _BusDetailsScreenState extends State<BusDetailsScreen> {
  Map<String, dynamic> busData = {};
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchBusData();
  }

  Future<void> fetchBusData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://pers.tngqatar.online/Controler/Public/PerspectiveApi.php?Action=${generateMd5Hash('getStudentBusDetails')}&student_id=${widget.studentId}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          busData = Map<String, dynamic>.from(data);
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
                    'Bus Details',
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
                  ? Center(child: Text("Error loading bus details"))
                  : SingleChildScrollView( // Wrap content with SingleChildScrollView
                child: _buildInfoTableCard('Bus Transport Details', [
                  ['Bus Transport No', busData['PickupTransport']?['TranportNumber'].toString() ?? 'N/A'],
                  ['Bus License Plate', busData['PickupTransport']?['BusLicensePlateNo'].toString() ?? 'N/A'],
                  ['Driver Name', busData['PickupTransport']?['BusDriverName'] ?? 'N/A'],
                  ['Driver Mobile', busData['PickupTransport']?['BusDriverMobile1'].toString() ?? 'N/A'],
                  ['Attendant Name', busData['PickupTransport']?['BusAttendantName'] ?? 'N/A'],
                  ['Attendant Mobile', busData['PickupTransport']?['BusAttendantMobile1'] ?? 'N/A'],
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
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
