import 'package:flutter/material.dart';
import 'screens/login_screen_rev_copy.dart';
import 'screens/dashboard_screen.dart';
import 'package:login_portal/screens/sibling_information_screen.dart';

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_api.dart';
import 'utils/notification_provider.dart'; // Import provider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NotificationProvider()), // Add provider
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parent Portal',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/siblings': (context) => SiblingInformationScreen(
          siblings: ModalRoute.of(context)!.settings.arguments as List<dynamic>,
        ),
      },
    );
  }
}
