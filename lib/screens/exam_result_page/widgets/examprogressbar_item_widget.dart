import 'package:login_portal/utils/size_utils.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../utils/app_decoration.dart';
import '../../../utils/theme_helper.dart';
import '../controller/exam_result_controller.dart';
import '../models/examprogressbar_item_model.dart';

// ignore: must_be_immutable
class ExamprogressbarItemWidget extends StatelessWidget {
  ExamprogressbarItemWidget(
    this.examprogressbarItemModelObj, {
    Key? key,
    this.onTapExamprogressbar,
  }) : super(
          key: key,
        );

  ExamprogressbarItemModel examprogressbarItemModelObj;

  var controller = Get.find<ExamResultController>();

  VoidCallback? onTapExamprogressbar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapExamprogressbar?.call();
      },
      child: Container(
        padding: EdgeInsets.all(20.h),
        decoration: AppDecoration.fillGray.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.v),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Text(
                      examprogressbarItemModelObj.examName!.value,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  SizedBox(height: 8.v),
                  Obx(
                    () => Text(
                      examprogressbarItemModelObj.examScore!.value,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            CircularPercentIndicator(
              radius: 25.0,
              lineWidth: 5.0,
              percent: 0.75,
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              animationDuration: 1000,
              backgroundColor: appTheme.blueGray100,
              center: new Text("75%",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.fSize,
                    fontFamily: 'SF Pro Display',
                  )),
              progressColor: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
