import 'package:get/get.dart';

import '../screens/first_term_exam_screen/binding/first_term_exam_binding.dart';
import '../screens/first_term_exam_screen/first_term_exam_screen.dart';
import '../screens/login_screen_rev_copy.dart';
import '../screens/dashboard_screen/dashboard_screen.dart';
import '../screens/sibling_information_screen.dart';
import '../screens/home_container_screen/home_container_screen.dart';

class AppRoutes {
  // 🔖 Route Names
  static const String loginScreen     = '/login';
  static const String dashboardScreen = '/dashboard';
  static const String siblingsScreen  = '/siblings';
  static const String firstTermExamScreen = '/first_term_exam_screen';

  // 🔰 Initial Route
  static const String initialRoute = loginScreen;

  // 🔗 Page Configuration List
  static final List<GetPage> pages = [

    GetPage(
      name: loginScreen,
      page: () => LoginScreen(),
      // Optional: add binding if needed
    ),

    GetPage(
      name: dashboardScreen,
      page: () => HomeContainerScreen(),
      // Optional: add binding if needed
    ),

    GetPage(
      name: siblingsScreen,
      page: () => SiblingInformationScreen(
        siblings: Get.arguments as List<dynamic>,
      ),
      // Optional: add binding if needed
    ),
    GetPage(
      name: firstTermExamScreen,
      page: () => FirstTermExamScreen(),
      bindings: [
        FirstTermExamBinding(),
      ],
    ),
  ];
}
