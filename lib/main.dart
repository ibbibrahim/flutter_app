// lib/main.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';                     // ← for orientation lock
import 'package:intl/date_symbol_data_local.dart';          // ← for intl initialization

import 'package:firebase_core/firebase_core.dart';
import 'firebase_api.dart';                                  // ← your notification setup

import 'package:provider/provider.dart';
import 'localization/app_localization.dart';
import 'utils/notification_provider.dart';                   // ← your ChangeNotifier
import 'utils/logger.dart';


import 'package:get/get.dart';                              // ← GetX root
// import 'core/app_export.dart';                              // ← exports theme, Logger, AppLocalization
// import 'core/utils/initial_bindings.dart';                  // ← your DI bindings
import 'routes/app_routes.dart';                            // ← your GetPage list
import 'package:login_portal/utils/image_constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1️⃣ Initialize Firebase & push notifications
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();

  // 2️⃣ Lock to portrait, init logger & intl, then runApp
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    // ⬇️ Set up template logger (replace with your own if you have one)
    Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);

    // ⬇️ Prepare intl (only needed if you use localization)
    initializeDateFormatting().then((_) {
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => NotificationProvider()),
          ],
          child: MyApp(),
        ),
      );
    });
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // —————— App basics ——————
      debugShowCheckedModeBanner: false,
      title: 'Parent Portal',

      // —————— Template theming & i18n ——————
      // theme: theme,                                   // from core/app_export.dart
      translations: AppLocalization(),                // your .tr() keys
      locale: Get.deviceLocale,                       // auto device locale
      fallbackLocale: const Locale('en', 'US'),

      // —————— GetX routing & bindings ——————
      // initialBinding: InitialBindings(),              // run your DI before first screen
      initialRoute: AppRoutes.initialRoute,           // e.g. '/login'
      getPages: AppRoutes.pages,                      // your list of GetPage(...)

      // OPTIONAL: you can still mix in your old home/routes map:
      // home: LoginScreen(),
      // routes: {
      //   '/dashboard': (_) => DashboardScreen(),
      //   '/siblings':  (_) => SiblingInformationScreen(...),
      // },
      //
      // But once everything’s in AppRoutes.pages, you can remove `routes:` entirely.
    );
  }
}
