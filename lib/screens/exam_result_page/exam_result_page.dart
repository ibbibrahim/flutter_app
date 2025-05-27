
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../utils/custom_text_style.dart';
import '../../widgets/insulin_chart.dart';
import '../exam_result_page/widgets/examprogressbar_item_widget.dart';
import '../exam_result_page/widgets/subjectslist_item_widget.dart';
import 'controller/exam_result_controller.dart';
import 'models/exam_result_model.dart';
import 'models/examprogressbar_item_model.dart';
import 'models/subjectslist_item_model.dart';
import 'package:flutter/material.dart';
import 'package:login_portal/utils/size_utils.dart';


// ignore_for_file: must_be_immutable
class ExamResultPage extends StatelessWidget {
  ExamResultPage({Key? key}) : super(key: key);

  ExamResultController controller =
      Get.put(ExamResultController(ExamResultModel().obs));

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.h, top: 24.v, right: 20.h),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            InsulinChart(),
            SizedBox(
              height: 25.h,
            ),
            Align(
                alignment: Alignment.center,
                child: Container(
                    height: 40.v,
                    // color: Colors.grey,
                    child: ListView.separated(
                        padding:
                            EdgeInsets.only(left: 31.h, top: 0.v, right: 39.h),
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) {
                          return SizedBox(width: 56.h);
                        },
                        itemCount: colorList.length,
                        itemBuilder: (context, index) {
                          return SubjectslistItemWidget(
                            color: colorList[index].color,
                            text: colorList[index].text,
                            secondColor: colorList[index].secondColor,
                            secondText: colorList[index].secondText,
                          );
                        }))),
            // SizedBox(height: 10.h ,),
            Align(
                alignment: Alignment.center,
                child: Container(
                    // color: Colors.red,
                    height: 40.v,
                    child: ListView.separated(
                        padding:
                            EdgeInsets.only(left: 31.h, top: 0.v, right: 39.h),
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) {
                          return SizedBox(width: 56.h);
                        },
                        itemCount: colorListSecond.length,
                        itemBuilder: (context, index) {
                          return SubjectslistItemWidget(
                            color: colorListSecond[index].color,
                            text: colorListSecond[index].text,
                            secondColor: colorListSecond[index].secondColor,
                            secondText: colorListSecond[index].secondText,
                          );
                        }))),
            SizedBox(height: 33.v),
            Text("lbl_overall_results".tr,
                style: CustomTextStyles.titleLarge22),
            SizedBox(height: 19.v),
            Obx(() => ListView.separated(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 16.v);
                },
                itemCount: controller.examResultModelObj.value
                    .examprogressbarItemList.value.length,
                itemBuilder: (context, index) {
                  ExamprogressbarItemModel model = controller
                      .examResultModelObj
                      .value
                      .examprogressbarItemList
                      .value[index];
                  return ExamprogressbarItemWidget(model,
                      onTapExamprogressbar: () {
                    onTapExamprogressbar();
                  });
                }).marginOnly(bottom: 24.h)),
          ]),
        ),
      ],
    );
  }

  /// Navigates to the firstTermExamScreen when the action is triggered.

  /// When the action is triggered, this function uses the [Get] package to
  /// push the named route for the firstTermExamScreen.
  onTapExamprogressbar() {
    Get.toNamed(
      AppRoutes.firstTermExamScreen,
    );
  }
}
