import 'package:flutter/material.dart';
import 'package:get/get.dart';


import './controller/bottom_controller.dart';
import 'package:login_portal/widgets/custom_bottom_bar.dart';

class HomeContainerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Ensure controller is available
    final BottomBarController ctrl = Get.put(BottomBarController());

    return WillPopScope(
      onWillPop: () => ctrl.onExit(context),
      child: Scaffold(
        body: GetBuilder<BottomBarController>(
          builder: (_) => ctrl.viewWidget,
        ),
        bottomNavigationBar: CustomBottomBar(
          onChanged: (_) {}, // we already update via controller
        ),
      ),
    );
  }
}
