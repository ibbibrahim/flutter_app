import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';

import 'package:login_portal/routes/app_routes.dart';
import 'package:login_portal/controllers/student_controller.dart';
import 'package:login_portal/screens/sibling_information_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../utils/funtions.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fatherQatarIdController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isSignup = false; // Toggle flag for signup mode


  bool _isLoading = false;
  bool _rememberMe = false;

  String _generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String actionToken = generateMd5Hash('getSiblingsDetails');
      String fatherQatarId = _fatherQatarIdController.text;

      try {
        final response = await http.get(
          Uri.parse(
            'https://pers.tngqatar.online/Controler/Public/PerspectiveApi.php?father_qatar_id=$fatherQatarId&Action=$actionToken',
          ),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          final sc = Get.put(StudentController(), permanent: true);

          final fcmToken = await FirebaseMessaging.instance.getToken();

          print("==== Login Success Debug Info ====");
          print("User ID (Father Qatar ID): $fatherQatarId");
          print("FCM Token: $fcmToken");
          if (fcmToken != null) {
            await sendTokenToServer(fatherQatarId, fcmToken);
          }
          if (data['status'] == "success" && data['data'] != null) {
            final List<dynamic> siblingsData = data['data'];
            if (siblingsData.length > 1) {
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => SiblingInformationScreen(siblings: siblingsData),
              //   ),
              // );

              Get.offNamed(
                AppRoutes.siblingsScreen,
                arguments: siblingsData, // still pass the list
              );
            } else {
              sc.setStudent(
                json: siblingsData[0],
                hasSiblingsFlag: false,
                sibs: null,
              );
              sc.update();
              // land on new bottom-nav container
              Get.offNamed(AppRoutes.dashboardScreen);

              // Navigator.pushReplacementNamed(
              //   context,
              //   '/dashboard',
              //   arguments: {'student': siblingsData.isNotEmpty ? siblingsData[0] : null, 'hasSiblings': false},
              // );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text(data['message'] ?? 'An unknown error occurred')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to retrieve data! Please try again.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Network error! Please check your connection.')),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final qid = _fatherQatarIdController.text.trim();
      final email = _emailController.text.trim();
      final actionToken = generateMd5Hash('parentSignup');

      try {
        final response = await http.post(
          Uri.parse('https://pers.tngqatar.online/Controler/Public/PerspectiveApi.php?Action=$actionToken'),
          body: {
            'qid': qid,
            'email': email,
          },
        );

        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Signup successful. Check your email to set your password.')),
          );
          setState(() {
            _isSignup = false; // Switch to login screen
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Signup failed.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Network error. Please try again.')),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00A19C), // Teal background color
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button and header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IconButton(
                  //   icon: Icon(Icons.arrow_back, color: Colors.white),
                  //   onPressed: () => Navigator.pop(context),
                  // ),
                  SizedBox(height: 20),
                  Text(
                    'The Next Generation',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Log in to continue',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Main content
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Logo/Icon
                          Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/tng_logo.png',
                                  width: 60,
                                  height: 60,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40),

                          // ID Number field
                          Text(
                            'ID Number',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _fatherQatarIdController,
                            decoration: InputDecoration(
                              hintText: 'Enter your Qatar ID',
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(11),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Please enter your Qatar ID';
                              if (value.length != 11) return 'Qatar ID must be exactly 11 digits';
                              return null;
                            },
                          ),

                          if (_isSignup) ...[
                            SizedBox(height: 16),
                            Text(
                              'Email',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: 'Enter your email',
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (_isSignup && (value == null || value.isEmpty)) return 'Please enter your email';
                                return null;
                              },
                            ),
                          ],
                          SizedBox(height: 24),

// Only show Remember Me in login mode
                          if (!_isSignup)
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value ?? false;
                                    });
                                  },
                                  activeColor: Color(0xFF00A19C),
                                ),
                                Text(
                                  'Remember me',
                                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          SizedBox(height: 32),

                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : (_isSignup ? _signup : _login),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF00A19C),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                  : Text(
                                _isSignup ? 'Sign Up' : 'Log In',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),

                          SizedBox(height: 12),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _isSignup = !_isSignup;
                                });
                              },
                              child: Text(
                                _isSignup
                                    ? 'Already have an account? Log in'
                                    : 'Don\'t have an account? Sign up',
                                style: TextStyle(color: Color(0xFF00A19C), fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendTokenToServer(String fatherQatarId, String token) async {
    try {
      final response = await http.post(
        Uri.parse("https://pers.tngqatar.online/Controler/Public/PerspectiveApi.php"),
        body: {
          'Action': 'storeFCMToken',
          'father_qatar_id': fatherQatarId,
          'fcm_token': token,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == "success") {
          print("FCM token stored successfully.");
        } else {
          print("Error storing token: ${data["message"]}");
        }
      } else {
        print("HTTP error ${response.statusCode}");
      }
    } catch (e) {
      print("Exception sending token: $e");
    }
  }

}
