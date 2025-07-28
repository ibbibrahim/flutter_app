import 'package:login_portal/utils/size_utils.dart';
import 'package:get/get.dart';
import '../../../utils/custom_text_style.dart';
import '../../../utils/theme_helper.dart';
import '../controller/exam_result_controller.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class SubjectslistItemWidget extends StatelessWidget {
  final String ?text;
  final Color? color;
  final String? secondText;
  final Color? secondColor;
  SubjectslistItemWidget(
     {
    Key? key, this.text, this.color, this.secondText, this.secondColor,
  }) : super(
          key: key,
        );

  // SubjectslistItemWidgetjectslistItemModel subjectslistItemModelObj;

  var controller = Get.find<ExamResultController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.h, // increase width to show full text
      child: Align(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    height: 10.adaptSize,
                    width: 10.adaptSize,
                    margin: EdgeInsets.only(bottom: 4.v),
                    decoration: BoxDecoration(
                      color: color ?? theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(5.h),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.h),
                      child: Text(
                        text ?? "",
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: CustomTextStyles.labelLargeBlack900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.v),
          ],
        ),
      ),
    );

  }
}
