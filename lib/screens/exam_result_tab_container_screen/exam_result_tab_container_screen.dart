import 'package:get/get.dart';
import 'package:login_portal/screens/exam_exam_schedule_screen/exam_exam_schedule_screen.dart';
import 'package:login_portal/utils/size_utils.dart';

import '../../utils/app_decoration.dart';
import '../../utils/image_constant.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/appbar_image_2.dart';
import '../../widgets/appbar_title.dart';
import '../../widgets/custom_app_bar.dart';
import '../exam_result_page/exam_result_page.dart';
import 'controller/exam_result_tab_container_controller.dart';
import 'package:flutter/material.dart';

class ExamResultTabContainerScreen
    extends GetWidget<ExamResultTabContainerController> {
  const ExamResultTabContainerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
        body: Column(children: [
          Container(
              padding: EdgeInsets.symmetric(vertical: 23.v),
              decoration: AppDecoration.white,
              child: CustomAppBar(
                  leadingWidth: 44.h,
                  leading: AppbarImage2(
                      svgPath: ImageConstant.imgArrowleft,
                      margin: EdgeInsets.only(
                          left: 20.h, top: 5.v, bottom: 4.v),
                      onTap: () {
                        onTapArrowleftone();
                      }),
                  centerTitle: true,
                  title: AppbarTitle(text: "lbl_exam".tr))),
          Expanded(
            child: Column(children: [
              SizedBox(height: 18.v),
              Container(
                  height: 32.v,
                  width: 388.h,
                  child: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      controller: controller.tabviewController,
                      labelPadding: EdgeInsets.zero,
                      labelColor: theme.colorScheme.primary,
                      labelStyle: TextStyle(
                          fontSize: 16.fSize,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w700),
                      unselectedLabelColor: appTheme.gray700,
                      unselectedLabelStyle: TextStyle(
                          fontSize: 16.fSize,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w400),
                      indicatorColor: theme.colorScheme.primary,
                      tabs: [
                        Tab(child: Text("lbl_exam_schedule".tr)),
                        Tab(child: Text("lbl_result".tr))
                      ])),
              Expanded(
                  // height: 747.v,
                  child: TabBarView(
                      controller: controller.tabviewController,
                      children: [ExamExamScheduleScreen(),ExamResultPage()]))
            ]),
          )
        ]));
  }

  /// Navigates to the previous screen.
  ///
  /// When the action is triggered, this function uses the [Get] package to
  /// navigate to the previous screen in the navigation stack.
  onTapArrowleftone() {
    Get.back();
  }
}
