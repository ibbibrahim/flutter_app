import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? selectedCard;
  bool showWelcome = true;

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

  void _showFatherDetails() {
    setState(() {
      selectedCard = 'Profile';
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> studentData =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    String studentFullName =
        '${studentData['FirstName']}${studentData['MiddleName']} ${studentData['LastName']}';
    String fatherFullName =
        '${studentData['FatherFirstName']}${studentData['FatherMiddleName']} ${studentData['FatherLastName']}';
    String motherFullName =
        '${studentData['MotherFirstName']}${studentData['MotherMiddleName']} ${studentData['MotherLastName']}';

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height * 0.3
                : MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
          ),
          Positioned(
            top: 60,
            right: 0,
            child: Material(
              shape: CircleBorder(),
              color: Colors.transparent,
              child: IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: _logout,
                iconSize: 25.0,
                padding: EdgeInsets.all(5.0),
                splashRadius: 30.0,
              ),
            ),
          ),
          Positioned(
            top: 60,
            right: 35,
            child: Material(
              shape: CircleBorder(),
              color: Colors.transparent,
              child: IconButton(
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                onPressed: _showFatherDetails,
                iconSize: 30.0,
                padding: EdgeInsets.all(5.0),
                splashRadius: 30.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Welcome, $fatherFullName',
                        speed: Duration(milliseconds: 200),
                        textStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        curve: Curves.easeInOut,
                      ),
                      TypewriterAnimatedText(
                        '',
                        speed: Duration(milliseconds: 100),
                        textStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        curve: Curves.easeInOut,
                        textAlign: TextAlign.start,
                        cursor: '',
                        // This handles the backspace effect by starting with an empty string
                      ),
                    ],
                    totalRepeatCount: 1,
                    onFinished: () {
                      setState(() {
                        showWelcome = false;
                      });
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    '${studentData['StudentID']} - $studentFullName',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    '${studentData['Section']} - ${studentData['Campus']}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: Stack(
                      children: <Widget>[
                        selectedCard == null
                            ? GridView.count(
                          crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait
                              ? 3 // 2 cards per row in portrait mode
                              : 4, // 3 cards per row in landscape mode
                          childAspectRatio: 1, // Make cards square
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          padding: EdgeInsets.all(6.0),
                          children: <Widget>[
                            _buildCard(Icons.info, () {
                              _showCard('Basic Information');
                            }),
                            _buildCard(Icons.person_2, () {
                              _showCard('Parent Information');
                            }),
                            _buildCard(Icons.school, () {
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
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          top: 0,
                          child: Center(
                            child: Opacity(
                              opacity: 0.2, // Adjust opacity as needed
                              child: Image.asset(
                                'assets/tng_logo.png',
                                width: 100.0, // Adjust size as needed
                                height: 100.0, // Adjust size as needed
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildGenderAvatar(Map<String, dynamic> studentData) {
    String avatarPath = studentData['G'] == 'M'
        ? 'assets/boy.png'
        : 'assets/girl.png';

    return Positioned(
      top: 50,
      left: 20,
      child: Padding(
        padding: const EdgeInsets.all(4.0), // Adjust the padding as needed
        child: CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.white, // Optional: add a background color to the border
          child: CircleAvatar(
            radius: 26.0, // Slightly smaller to create the padding effect
            backgroundImage: AssetImage(avatarPath),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(IconData icon, VoidCallback onTap) {
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
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  if (cardName == 'Basic Information') ...[
                    _buildInfoTableCard('Basic Information', [
                      ['Name', studentFullName],
                      ['QID', studentData['QID']],
                      ['DOB', studentData['DOB']],
                      ['Age', studentData['Age'].toString()],
                      ['Gender', studentData['G'] == 'M' ? 'Male' : 'Female'],
                      ['Religion', studentData['ReligionID'] == '1' ? 'Islam' : 'Other'],
                    ], onBack),

                  ] else if (cardName == 'Profile') ...[
                    _buildInfoTableCard('Profile', [
                      ['Name', fatherFullName],
                      ['QID', studentData['FatherQatarID']],
                      ['Company', studentData['FatherCompany'] ?? 'N/A'],
                      ['Nationality', studentData['Nationality']],
                      ['Phone', studentData['FatherCellPhone']],
                    ], onBack),
                  ] else if (cardName == 'Parent Information') ...[
                    _buildInfoTableCard('Parent Information', [
                      ['Father Name', fatherFullName],
                      ['Father QID', studentData['FatherQatarID']],
                      ['Father Company', studentData['FatherCompany'] ?? 'N/A'],
                      ['Father Nationality', studentData['Nationality']],
                      ['Father Phone', studentData['FatherCellPhone']],

                      ['Mother Name', motherFullName],
                      ['Mother QID', studentData['MotherQatarID'] ?? 'N/A'],
                      ['Mother Company', studentData['MotherCompany'] ?? 'N/A'],
                      ['Mother Nationality', studentData['Nationality']],
                      ['Mother Phone', studentData['MotherCellPhone']],
                    ], onBack),
                  ] else if (cardName == 'Enrollment Information') ...[
                    _buildInfoTableCard('Enrollment Information', [
                      ['Enrollment Information', 'Placeholder'],
                    ], onBack),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTableCard(String title, List<List<String>> data, VoidCallback onBack) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: onBack,
                  color: Colors.blueAccent,
                ),
                SizedBox(width: 4.0),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
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


  Future<void> _logout() async {
    //Clear any saved session data (e.g., SharedPreferences)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigate back to the login screen
    Navigator.pushReplacementNamed(context, '/');
  }
}
