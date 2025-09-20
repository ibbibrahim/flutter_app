import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:login_portal/controllers/student_controller.dart';
import 'package:login_portal/routes/app_routes.dart';

class SiblingInformationScreen extends StatelessWidget {
  final List<dynamic> siblings;

  SiblingInformationScreen({required this.siblings});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Enhanced gradient background
          Container(
            height: MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height * 0.35
                : MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF00B8A9),
                  Color(0xFF00A19C),
                  Color(0xFF008B86),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35.0),
                bottomRight: Radius.circular(35.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
          ),

          // Decorative circles for visual enhancement
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1 ),
              ),
            ),
          ),
          Positioned(
            top: 80,
            right: 20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          // Logo/Brand placeholder - positioned for better visibility
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13), // Slightly smaller than container
                child: Image.asset(
                  'assets/tng_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Enhanced logout button
          Positioned(
            top: 50,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: _logout,
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.logout_rounded,
                      color: Colors.white,
                      size: 24.0,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Main content
          Padding(
            padding: const EdgeInsets.only(top: 130.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Enhanced title section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Student',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Choose which sibling to continue with',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                // Enhanced content container
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(20, 25, 20, 20),
                    decoration: BoxDecoration(
                      color: Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35.0),
                        topRight: Radius.circular(35.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 15,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Content indicator
                        Container(
                          width: 50,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Color(0xFFE0E0E0),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Enhanced ListView
                        Expanded(
                          child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            itemCount: siblings.length,
                            separatorBuilder: (context, index) => SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              return _buildSiblingCard(context, index);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Enhanced notification message
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: StreamBuilder<RemoteMessage>(
              stream: FirebaseMessaging.onMessage,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final message = snapshot.data!;
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF2E3440), Color(0xFF3B4252)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFF4A90E2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.notifications,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            message.notification?.body ?? 'You have a new message!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSiblingCard(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFFAFBFC)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF4A90E2).withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Color(0xFF4A90E2).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            final sc = Get.find<StudentController>();

            sc.setStudent(
              json: siblings[index],
              hasSiblingsFlag: true,
              sibs: siblings,
            );
            sc.update();

            Navigator.pushReplacementNamed(
              context,
              '/dashboard',
              arguments: {
                'student': siblings[index],
                'siblings': siblings,
                'hasSiblings': true
              },
            );
          },
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                // Student avatar placeholder
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF4A90E2).withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _getInitials(siblings[index]['Student Full Name'] ?? 'N/A'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),

                // Student information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        siblings[index]['Student Full Name'] ?? 'N/A',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E3440),
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Color(0xFF4A90E2).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'ID: ${siblings[index]['StudentID']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF4A90E2),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Color(0xFF28A745).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              siblings[index]['Section'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF28A745),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Enhanced arrow icon
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF4A90E2).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFF4A90E2),
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    List<String> names = name.trim().split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.length == 1 && names[0].isNotEmpty) {
      return names[0][0].toUpperCase();
    }
    return 'N/A';
  }

  Future<void> _logout() async {
    // Clear local saved session
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Clear and delete StudentController
    if (Get.isRegistered<StudentController>()) {
      final sc = Get.find<StudentController>();
      sc.clearStudent();               // Clear values (optional)
      Get.delete<StudentController>(); // Unregister and dispose
    }

    // Navigate to login, clearing route history
    Get.offAllNamed(AppRoutes.loginScreen);
  }
}