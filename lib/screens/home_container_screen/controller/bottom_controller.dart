import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:login_portal/screens/dashboard_screen/dashboard_screen.dart';

/// Controls selected tab and current body widget.
class BottomBarController extends GetxController {
  var selectedIndex = 0.obs;

  // FIRST TAB IS HOME
  Widget viewWidget = DashboardScreen();

  void onChange(Widget page) {
    viewWidget = page;
    update();               // triggers GetBuilder rebuild
  }

  /// Optional: goback logic – if not on first tab, go to first tab.
  Future<bool> onExit(BuildContext ctx) async {
    if (selectedIndex.value != 0) {
      selectedIndex.value = 0;
      onChange(DashboardScreen());
      return false; // don’t close app
    }
    return true; // allow system back
  }
}
