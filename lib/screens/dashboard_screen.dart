import 'package:flutter/material.dart';

class DashboardScreens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieving the student data passed from the login screen
    final Map<String, dynamic> studentData =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Extracting relevant details
    String studentFullName = '${studentData['FirstName']} ${studentData['MiddleName']} ${studentData['LastName']}';
    String fatherFullName = '${studentData['FatherFirstName']} ${studentData['FatherMiddleName']} ${studentData['FatherLastName']}';

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome, $studentFullName',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                title: Text(
                  'Student Name: $studentFullName',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Father Name: $fatherFullName',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            // You can add more cards here to display additional details if needed
          ],
        ),
      ),
    );
  }
}
