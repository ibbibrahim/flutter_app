import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_portal/screens/dashboard_screen/dashboard_screen.dart';
import 'dart:io';
import 'package:flutter/services.dart'; // For SystemNavigator.pop


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
  Future<bool> onExit(BuildContext context) async {
    if (selectedIndex.value != 0) {
      selectedIndex.value = 0;
      onChange(DashboardScreen());
      update();
      return Future.value(false);
    } else {
      await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Are you sure you want to exit?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      margin: const EdgeInsets.only(left: 15, bottom: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Center(
                        child: Text(
                          'No',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      if (Platform.isIOS) {
                        exit(0);
                      } else {
                        SystemNavigator.pop();
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 15, bottom: 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: const Center(
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
      return Future.value(false);
    }
  }
}
