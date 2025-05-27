import 'package:login_portal/utils/size_utils.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../utils/app_decoration.dart';
import '../../../utils/theme_helper.dart';
import '../../../widgets/custom_image_view.dart';
import '../controller/first_term_exam_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class FirstTermExamItemWidget extends StatelessWidget {
final String? image;
final String? text;
final double? progress;
final String? progressText;
 FirstTermExamItemWidget(
    {
    Key? key, this.image, this.text, this.progress, this.progressText,
  }) : super(
          key: key,
        );

  // FirstTermExamItemModel firstTermExamItemModelObj;

  var controller = Get.find<FirstTermExamController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.h),
      decoration: AppDecoration.fillGray.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder8,
      ),
      child: Row(
        children: [
          CustomImageView(
            imagePath: image,
            // imagePath: ImageConstant.imgRectangle4432,
            height: 72.h,
            width: 72.h,
            radius: BorderRadius.circular(
              8.h,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.h,
                top: 16.v,
                bottom: 14.v,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 1.v),
                          child: Text(
                            text!,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      ),
                      Text(
                        progressText!,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.v),
                  // LinearProgressIndicator(
                  //   value: progress,
                  //   backgroundColor: appTheme.gray30001,
                  //   valueColor: AlwaysStoppedAnimation<Color>(
                  //     theme.colorScheme.primary,
                  //   ),
                  // ),
                  LinearPercentIndicator(
                    barRadius: Radius.circular(12.h),
                    width: 276.h,
                    animation: true,
                    animationDuration: 1000,
                    lineHeight:8.0,
                    padding: EdgeInsets.all(0),
                    backgroundColor:  appTheme.blueGray100,
                    // leading: new Text("left content"),
                    // trailing: new Text("right content"),
                    percent: progress!,
                    // center: Text("20.0%"),
                    // linearStrokeCap: LinearStrokeCap.butt,
                    progressColor:  theme
                        .colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
