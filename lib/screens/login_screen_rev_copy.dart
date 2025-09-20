import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import 'package:login_portal/routes/app_routes.dart';
import 'package:login_portal/controllers/student_controller.dart';
import 'package:login_portal/screens/sibling_information_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../utils/funtions.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fatherQatarIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  bool _isSignup = false;
  String _password = '';
  bool _isLoading = false;
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _showBiometricButton = false;

  // Add these for secure storage and biometrics
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isBiometricSupported = false;


  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack));

    _animationController.forward();

    // Check if biometric credentials exist
    _checkBiometricCredentials();

    // Check if biometric authentication is supported
    _checkBiometricSupport();
  }

  // Check if biometric authentication is supported
  Future<void> _checkBiometricSupport() async {
    try {
      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      List<BiometricType> availableBiometrics = await _localAuth.getAvailableBiometrics();

      print("Can check biometrics: $canCheckBiometrics"); // Debug info
      print("Available biometrics: $availableBiometrics"); // Debug info

      setState(() {
        _isBiometricSupported = canCheckBiometrics && availableBiometrics.isNotEmpty;
      });
    } on PlatformException catch (e) {
      print("PlatformException checking biometric support: ${e.code} - ${e.message}");
      setState(() {
        _isBiometricSupported = false;
      });
    } catch (e) {
      print("Error checking biometric support: $e");
      setState(() {
        _isBiometricSupported = false;
      });
    }
  }

  // Check if we have saved credentials
  Future<void> _checkBiometricCredentials() async {
    try {
      final String? savedId = await _secureStorage.read(key: 'saved_qatar_id');
      setState(() {
        _showBiometricButton = savedId != null && savedId.isNotEmpty;
      });

      // If we have saved credentials, pre-fill the ID field
      if (savedId != null && savedId.isNotEmpty) {
        _fatherQatarIdController.text = savedId;
      }
    } catch (e) {
      print("Error checking saved credentials: $e");
    }
  }

  // Save credentials securely after successful login
  Future<void> _saveCredentials(String qatarId, String password) async {
    try {
      await _secureStorage.write(key: 'saved_qatar_id', value: qatarId);
      await _secureStorage.write(key: 'saved_password', value: password);
      setState(() {
        _showBiometricButton = true;
      });
    } catch (e) {
      print("Error saving credentials: $e");
    }
  }


  // Remove saved credentials
  Future<void> _removeCredentials() async {
    try {
      await _secureStorage.delete(key: 'saved_qatar_id');
      await _secureStorage.delete(key: 'saved_password');
      setState(() {
        _showBiometricButton = false;
      });
    } catch (e) {
      print("Error removing credentials: $e");
    }
  }

  // Authenticate with biometrics and login

// Replace your existing _authenticateWithBiometrics method with this improved version
  Future<void> _authenticateWithBiometrics() async {
    try {
      // First, check if biometrics are available
      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        showErrorSnackBar(context,'Biometric authentication not available on this device');
        return;
      }

      // Check available biometrics
      List<BiometricType> availableBiometrics = await _localAuth.getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        showErrorSnackBar(context,'No biometric methods are set up on this device');
        return;
      }

      print("Available biometrics: $availableBiometrics"); // Debug info

      // Attempt authentication with better error handling
      bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to login to your account',
        options: const AuthenticationOptions(
          biometricOnly: false, // Allow PIN/Pattern as fallback
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        print("Biometric authentication successful"); // Debug info

        // Get saved credentials
        final String? savedId = await _secureStorage.read(key: 'saved_qatar_id');
        final String? savedPassword = await _secureStorage.read(key: 'saved_password');

        if (savedId != null && savedPassword != null && savedId.isNotEmpty && savedPassword.isNotEmpty) {
          print("Retrieved saved credentials successfully"); // Debug info

          // Set the controllers with saved values
          _fatherQatarIdController.text = savedId;
          _passwordController.text = savedPassword; // Add this line
          setState(() {
            _password = savedPassword;
          });

          // Perform the login
          _login();
        } else {
          print("No valid saved credentials found"); // Debug info
          showErrorSnackBar(context,'No saved credentials found. Please login manually first.');
        }
      } else {
        print("User cancelled biometric authentication"); // Debug info
        // User cancelled authentication - don't show error message
      }
    } on PlatformException catch (e) {
      print("PlatformException during biometric auth: ${e.code} - ${e.message}"); // Debug info

      // Handle specific platform exceptions
      switch (e.code) {
        case 'NotAvailable':
          showErrorSnackBar(context,'Biometric authentication is not available');
          break;
        case 'NotEnrolled':
          showErrorSnackBar(context,'No biometric credentials are enrolled. Please set up fingerprint or face unlock in device settings.');
          break;
        case 'LockedOut':
          showErrorSnackBar(context,'Biometric authentication is temporarily locked. Try again later.');
          break;
        case 'PermanentlyLockedOut':
          showErrorSnackBar(context,'Biometric authentication is permanently locked. Please use device PIN/password.');
          break;
        case 'UserCancel':
        // User cancelled - don't show error
          break;
        case 'UserFallback':
          showErrorSnackBar(context,'Authentication cancelled. Please use manual login.');
          break;
        default:
          showErrorSnackBar(context,'Biometric authentication error: ${e.message ?? 'Unknown error'}');
      }
    } catch (e) {
      print("General exception during biometric auth: $e"); // Debug info
      showErrorSnackBar(context,'Biometric authentication failed: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();       // Stops and frees animation resources
    _fatherQatarIdController.dispose();   // Releases memory used by text field
    _emailController.dispose();           // Same here
    _passwordController.dispose();        // You added this to fix form sync
    super.dispose();                      // Always call the parent class's dispose
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
            'https://pers.tngqatar.online/Controler/Public/PerspectiveApi.php?father_qatar_id=$fatherQatarId&password=${generateMd5Hash(_password)}&Action=$actionToken',
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

          // Save credentials if "Remember Me" is checked
          if (_rememberMe) {
            await _saveCredentials(fatherQatarId, _password);
          }
          // else {
          //   // Remove credentials if "Remember Me" is unchecked
          //   await _removeCredentials();
          // }

          if (data['status'] == "success" && data['data'] != null) {
            final List<dynamic> siblingsData = data['data'];
            if (siblingsData.length > 1) {
              Get.offNamed(
                AppRoutes.siblingsScreen,
                arguments: siblingsData,
              );
            } else {
              sc.setStudent(
                json: siblingsData[0],
                hasSiblingsFlag: false,
                sibs: null,
              );
              sc.update();
              Get.offNamed(AppRoutes.dashboardScreen);
            }
          } else {
            showErrorSnackBar(context,data['message'] ?? 'An unknown error occurred');
          }
        } else {
          showErrorSnackBar(context,'Failed to retrieve data! Please try again.');
        }
      } catch (e) {
        showErrorSnackBar(context,'Network error! Please check your connection.');
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
          showSignupSuccessModal(context, onProceed: () async {
            setState(() {
              _isSignup = false;
            });
            await _removeCredentials();
          });
        } else {
          showErrorSnackBar(context,data['message'] ?? 'Signup failed.');
        }
      } catch (e) {
        showErrorSnackBar(context,'Network error. Please try again.');
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final isTablet = screenSize.shortestSide >= 600;
    final isLargeScreen = screenSize.width > 1200;

    // Responsive values
    final headerHeight = isPortrait
        ? (isTablet ? screenSize.height * 0.28 : screenSize.height * 0.30)
        : (isTablet ? screenSize.height * 0.55 : screenSize.height * 0.60);

    final titleFontSize = isTablet ? 32.0 : (isLargeScreen ? 36.0 : 28.0);
    final subtitleFontSize = isTablet ? 18.0 : (isLargeScreen ? 20.0 : 16.0);
    final logoSize = isTablet ? 120.0 : (isLargeScreen ? 140.0 : 100.0);
    final horizontalPadding = isTablet ? 32.0 : (isLargeScreen ? 48.0 : 24.0);
    final cardPadding = isTablet ? 32.0 : (isLargeScreen ? 40.0 : 24.0);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Enhanced gradient background
            Container(
              height: headerHeight,
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
                  bottomLeft: Radius.circular(isTablet ? 45.0 : 35.0),
                  bottomRight: Radius.circular(isTablet ? 45.0 : 35.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
            ),

            // Decorative elements
            Positioned(
              top: -80,
              right: -80,
              child: Container(
                width: isTablet ? 200 : 160,
                height: isTablet ? 200 : 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              top: 60,
              left: -40,
              child: Container(
                width: isTablet ? 120 : 100,
                height: isTablet ? 120 : 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),

            // Main content
            SingleChildScrollView(
              child: Column(
                children: [
                  // Header section
                  Container(
                    height: headerHeight,
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: isTablet ? 80 : 70,
                                  height: isTablet ? 80 : 70,
                                  margin: EdgeInsets.only(bottom: 20),
                                  padding: EdgeInsets.all(isTablet ? 12 : 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(isTablet ? 25 : 20),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 2
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(isTablet ? 20 : 15),
                                    child: Image.asset(
                                      'assets/tng_logo.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Text(
                                  'The Next Generation',
                                  style: TextStyle(
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                // SizedBox(height: 12),
                                Text(
                                  _isSignup ? 'Create your account' : 'Please sign in',
                                  style: TextStyle(
                                    fontSize: subtitleFontSize,
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content container
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      minHeight: screenSize.height - headerHeight,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(isTablet ? 45.0 : 35.0),
                        topRight: Radius.circular(isTablet ? 45.0 : 35.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 20,
                          offset: Offset(0, -8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(cardPadding),
                      child: Column(
                        children: [
                          // Handle indicator
                          Container(
                            width: isTablet ? 60 : 50,
                            height: isTablet ? 5 : 4,
                            margin: EdgeInsets.only(bottom: isTablet ? 40 : 30),
                            decoration: BoxDecoration(
                              color: Color(0xFFE0E0E0),
                              borderRadius: BorderRadius.circular(isTablet ? 3 : 2),
                            ),
                          ),

                          // // Logo section
                          // // Logo section
                          // FadeTransition(
                          //   opacity: _fadeAnimation,
                          //   child: Container(
                          //     width: logoSize,
                          //     height: logoSize,
                          //     margin: EdgeInsets.only(bottom: isTablet ? 50 : 40),
                          //     decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       shape: BoxShape.circle,
                          //       boxShadow: [
                          //         BoxShadow(
                          //           color: Color(0xFF00A19C).withOpacity(0.2),
                          //           blurRadius: 20,
                          //           spreadRadius: 2,
                          //           offset: Offset(0, 8),
                          //         ),
                          //       ],
                          //       border: Border.all(
                          //         color: Color(0xFF00A19C).withOpacity(0.1),
                          //         width: 2,
                          //       ),
                          //     ),
                          //     child: Padding(
                          //       padding: EdgeInsets.all(logoSize * 0.15),
                          //       child: ClipOval(
                          //         child: Image.asset(
                          //           'assets/tng_logo.png',
                          //           fit: BoxFit.contain,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          // Form section
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: isLargeScreen ? 500 : double.infinity,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (_showBiometricButton && _isBiometricSupported && !_isSignup)
                                    Column(
                                      children: [
                                        _buildBiometricButton(),
                                        SizedBox(height: isTablet ? 24 : 20),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Divider(
                                                color: Colors.grey.shade300,
                                                thickness: 1,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 12),
                                              child: Text(
                                                'OR',
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Divider(
                                                color: Colors.grey.shade300,
                                                thickness: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: isTablet ? 24 : 20),
                                      ],
                                    ),
                                  _buildInputField(
                                    'ID Number',
                                    'Enter your Qatar ID',
                                    _fatherQatarIdController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(11),
                                    ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty)
                                        return 'Please enter your Qatar ID';
                                      if (value.length != 11)
                                        return 'Qatar ID must be exactly 11 digits';
                                      return null;
                                    },
                                    prefixIcon: Icons.credit_card,
                                  ),

                                  if (!_isSignup) ...[
                                    SizedBox(height: isTablet ? 24 : 20),
                                    _buildPasswordField(),
                                  ],

                                  if (_isSignup) ...[
                                    SizedBox(height: isTablet ? 24 : 20),
                                    _buildInputField(
                                      'Email',
                                      'Enter your email address',
                                      _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (_isSignup && (value == null || value.isEmpty))
                                          return 'Please enter your email';
                                        if (_isSignup && !value!.contains('@'))
                                          return 'Please enter a valid email';
                                        return null;
                                      },
                                      prefixIcon: Icons.email_outlined,
                                    ),
                                  ],

                                  SizedBox(height: isTablet ? 32 : 24),

                                  // Remember me checkbox (only for login)
                                  if (!_isSignup) ...[
                                    _buildRememberMeCheckbox(),
                                    SizedBox(height: isTablet ? 32 : 24),
                                  ],

                                  // Action button
                                  _buildActionButton(),

                                  SizedBox(height: isTablet ? 24 : 20),

                                  // Toggle button
                                  _buildToggleButton(),
                                ],
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
      ),
    );
  }

  Widget _buildBiometricButton() {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final isLargeScreen = MediaQuery.of(context).size.width > 1200;

    return Container(
      width: double.infinity,
      height: isTablet ? 64 : 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        border: Border.all(
          color: Color(0xFF00A19C),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          onTap: _isLoading ? null : _authenticateWithBiometrics,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.fingerprint,
                  color: Color(0xFF00A19C),
                  size: isTablet ? 28 : 24,
                ),
                SizedBox(width: 12),
                Text(
                  'Login with Biometrics',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : (isLargeScreen ? 19 : 16),
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00A19C),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      String label,
      String hint,
      TextEditingController controller, {
        TextInputType keyboardType = TextInputType.text,
        List<TextInputFormatter>? inputFormatters,
        String? Function(String?)? validator,
        IconData? prefixIcon,
      }) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final isLargeScreen = MediaQuery.of(context).size.width > 1200;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTablet ? 18 : (isLargeScreen ? 19 : 16),
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3440),
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: isTablet ? 12 : 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontSize: isTablet ? 16 : 14,
            ),
            prefixIcon: prefixIcon != null
                ? Container(
              margin: EdgeInsets.only(left: 12, right: 12),
              child: Icon(
                prefixIcon,
                color: Color(0xFF00A19C),
                size: isTablet ? 24 : 20,
              ),
            )
                : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
              borderSide: BorderSide(color: Color(0xFFE5E9F0), width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
              borderSide: BorderSide(color: Color(0xFFE5E9F0), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
              borderSide: BorderSide(color: Color(0xFF00A19C), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
              borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: prefixIcon != null ? 0 : (isTablet ? 20 : 16),
              vertical: isTablet ? 20 : 16,
            ),
          ),
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2E3440),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final isLargeScreen = MediaQuery.of(context).size.width > 1200;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
            fontSize: isTablet ? 18 : (isLargeScreen ? 19 : 16),
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3440),
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: isTablet ? 12 : 8),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          validator: (value) {
            if (!_isSignup && (value == null || value.isEmpty)) {
              return 'Please enter your password';
            }
            return null;
          },
          onChanged: (value) {
            _password = value;
          },
          decoration: InputDecoration(
            hintText: 'Enter your password',
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontSize: isTablet ? 16 : 14,
            ),
            prefixIcon: Container(
              margin: EdgeInsets.only(left: 12, right: 12),
              child: Icon(
                Icons.lock_outline,
                color: Color(0xFF00A19C),
                size: isTablet ? 24 : 20,
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey.shade600,
                size: isTablet ? 24 : 20,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
              borderSide: BorderSide(color: Color(0xFFE5E9F0), width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
              borderSide: BorderSide(color: Color(0xFFE5E9F0), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
              borderSide: BorderSide(color: Color(0xFF00A19C), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
              borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 0,
              vertical: isTablet ? 20 : 16,
            ),
          ),
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2E3440),
          ),
        ),
      ],
    );
  }

  Widget _buildRememberMeCheckbox() {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Row(
      children: [
        Transform.scale(
          scale: isTablet ? 1.2 : 1.0,
          child: Checkbox(
            value: _rememberMe,
            onChanged: (value) {
              setState(() {
                _rememberMe = value ?? false;
              });
            },
            activeColor: Color(0xFF00A19C),
            checkColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        SizedBox(width: 8),
        Text(
          'Enable Biometric Login',
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            color: Color(0xFF5E6B7A),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final isLargeScreen = MediaQuery.of(context).size.width > 1200;

    return Container(
      width: double.infinity,
      height: isTablet ? 64 : 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00B8A9), Color(0xFF00A19C)],
        ),
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF00A19C).withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          onTap: _isLoading ? null : (_isSignup ? _signup : _login),
          child: Center(
            child: _isLoading
                ? SizedBox(
              width: isTablet ? 28 : 24,
              height: isTablet ? 28 : 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
                : Text(
              _isSignup ? 'Create Account' : 'Sign In',
              style: TextStyle(
                fontSize: isTablet ? 18 : (isLargeScreen ? 19 : 16),
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton() {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final isLargeScreen = MediaQuery.of(context).size.width > 1200;

    return Center(
      child: TextButton(
        onPressed: () {
          setState(() {
            _isSignup = !_isSignup;
            _animationController.reset();
            _animationController.forward();
          });
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 24 : 16,
            vertical: isTablet ? 16 : 12,
          ),
        ),
        child: Text(
          _isSignup
              ? 'Already have an account? Sign in'
              : 'Don\'t have an account? Sign up or Forgot Password',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF00A19C),
            fontWeight: FontWeight.w600,
            fontSize: isTablet ? 16 : (isLargeScreen ? 17 : 14),
          ),
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