import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? selectedCard;

  void _showCard(String cardName) {
    setState(() {
      selectedCard = cardName;
    });
  }

  void _goBack() {
    setState(() {
      selectedCard = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> studentData =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    String studentFullName =
        '${studentData['FirstName']} ${studentData['MiddleName']} ${studentData['LastName']}';
    String fatherFullName =
        '${studentData['FatherFirstName']} ${studentData['FatherMiddleName']} ${studentData['FatherLastName']}';
    String motherFullName =
        '${studentData['MotherFirstName']} ${studentData['MotherMiddleName']} ${studentData['MotherLastName']}';

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height * 0.3
                : MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: Material(
              shape: CircleBorder(),
              color: Colors.transparent,
              child: IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Implement logout functionality here
                },
                iconSize: 30.0,
                padding: EdgeInsets.all(10.0),
                splashRadius: 30.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Welcome, $fatherFullName',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 60),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: selectedCard == null
                        ? GridView.count(
                      crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait
                          ? 3 // 2 cards per row in portrait mode
                          : 4, // 3 cards per row in landscape mode
                      childAspectRatio: 1, // Make cards square
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      padding: EdgeInsets.all(16.0),
                      children: <Widget>[
                        _buildCard('Basic Information', Icons.info, () {
                          _showCard('Basic Information');
                        }),
                        _buildCard('Parent Information', Icons.person_2, () {
                          _showCard('Parent Information');
                        }),
                        _buildCard('Enrollment Information', Icons.school, () {
                          _showCard('Enrollment Information');
                        }),
                      ],
                    )
                        : _buildDetailsView(
                      cardName: selectedCard!,
                      studentData: studentData,
                      studentFullName: studentFullName,
                      fatherFullName: fatherFullName,
                      motherFullName: motherFullName,
                      onBack: _goBack,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 35, // Adjust size as needed
              color: Colors.blueAccent, // Adjust color as needed
            ),
            SizedBox(height: 8.0),
            Align(
              alignment: Alignment.center,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 8, // Adjust font size as needed
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center, // Center align text
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsView({
    required String cardName,
    required Map<String, dynamic> studentData,
    required String studentFullName,
    required String fatherFullName,
    required String motherFullName,
    required VoidCallback onBack,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: onBack,
            ),
            Text(
              cardName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        if (cardName == 'Basic Information') ...[
          Text('Student Name: $studentFullName'),
          Text('Student QID: ${studentData['QID']}'),
          Text('DOB: ${studentData['DOBDMY']}'),
          Text('Join Date: ${studentData['JoinDate']}'),
          Text('Age: ${studentData['Age']}'),
          Text('Gender: ${studentData['G'] == 'M' ? 'Male' : 'Female'}'),
          Text('Religion: ${studentData['ReligionID'] == '1' ? 'Islam' : 'Other'}'),
        ] else if (cardName == 'Parent Information') ...[
          Text('Father Name: $fatherFullName'),
          Text('Father QID: ${studentData['FatherQatarID']}'),
          Text('Father Company: ${studentData['FatherCompany'] ?? 'N/A'}'),
          Text('Father Nationality: ${studentData['Nationality']}'),
          Text('Father Phone: ${studentData['FatherCellPhone']}'),
          SizedBox(height: 20),
          Text('Mother Name: $motherFullName'),
          Text('Mother QID: ${studentData['MotherQatarID'] ?? 'N/A'}'),
          Text('Mother Company: ${studentData['MotherCompany'] ?? 'N/A'}'),
          Text('Mother Nationality: ${studentData['Nationality']}'),
          Text('Mother Phone: ${studentData['MotherCellPhone']}'),
        ] else if (cardName == 'Enrollment Information') ...[
          Text('Enrollment Information Placeholder'),
        ],
      ],
    );
  }
}
