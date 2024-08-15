import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:login_portal/screens/SiblingInformationScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fatherQatarIdController = TextEditingController();

  bool _isLoading = false;

  String _generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Hash the inputs

      String hashedFatherQatarId = _fatherQatarIdController.text;

      final response = await http.get(
        Uri.parse(
          'https://175a-37-211-16-85.ngrok-free.app/tng_api/index.php?father_qatar_id=${_fatherQatarIdController.text}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (false) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed! ${data['error']}')),
          );
        } else {
          if (data is List && data.length > 1) {
            // Multiple siblings
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SiblingInformationScreen(siblings: data),
              ),
            );
          } else {
            // Single record
            Navigator.pushReplacementNamed(
              context,
              '/dashboard',
              arguments: data[0],
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed! Please try again.')),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        image: DecorationImage(
            image: AssetImage('assets/pngwing.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: EdgeInsets.only(left: 35, top: 160),
              child: Text(
                'Welcome\n to TNG Portal',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: _fatherQatarIdController,
                                  decoration: InputDecoration(
                                    labelText: 'Father Qatar ID',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(11),
                                  ],
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your Father Qatar ID';
                                    }
                                    if (value.length != 11) {
                                      return 'Father Qatar ID must be exactly 11 digits';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 30),

                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          _isLoading ? CircularProgressIndicator() :
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Login in',
                                style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: _login,
                                    icon: Icon(
                                      Icons.arrow_forward,
                                    )),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
