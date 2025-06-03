import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:login_portal/utils/size_utils.dart';
import '../../../controllers/student_controller.dart';
import '../../../utils/app_decoration.dart';
import '../../../utils/custom_text_style.dart';
import '../../../utils/image_constant.dart';
import '../../../utils/theme_helper.dart';
import '../../../widgets/custom_image_view.dart';
import '../controller/exam_result_controller.dart';
import '../models/examprogressbar_item_model.dart';

// ignore: must_be_immutable
class ExamprogressbarItemWidget extends StatelessWidget {
  ExamprogressbarItemWidget(
    this.examprogressbarItemModelObj, {
    Key? key,
    this.onTapExamprogressbar,
  }) : super(key: key);

  final ExamprogressbarItemModel examprogressbarItemModelObj;
  final controller = Get.find<ExamResultController>();
  final VoidCallback? onTapExamprogressbar;

  @override
  Widget build(BuildContext context) {
    final studentData = Get.find<StudentController>().student;
    final academicSession = studentData['AcademicSession'] ?? '2024-2025';

    return GestureDetector(
      onTap: () => onTapExamprogressbar?.call(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 22.v),
        decoration: BoxDecoration(
          color: Colors.white, // makes it pop out
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: Offset(0, 4), // Shadow position
            ),
          ],
          border: Border(
            left: BorderSide(
              color: theme.colorScheme.primary, // Highlight color
              width: 4,
            ),
          ),
        ),
        child: Stack(
          children: [
            /// Left content: Title + Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(
                      "${examprogressbarItemModelObj.examName?.value ?? ''} ($academicSession)",
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    )),
                SizedBox(height: 17.v),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomImageView(
                              svgPath: ImageConstant.imgMenu,
                              height: 18.adaptSize,
                              width: 18.adaptSize,
                            ),
                            SizedBox(width: 8.h),
                            Obx(() => Text(
                                  "Overall Formative: ${examprogressbarItemModelObj.overallFormative?.value ?? '0'}/100 %",
                                  style: CustomTextStyles.bodyMediumBlack900,
                                )),
                          ],
                        ),
                        SizedBox(height: 12.v),
                        Row(
                          children: [
                            CustomImageView(
                              svgPath: ImageConstant.imgMenuTeal600,
                              height: 18.adaptSize,
                              width: 18.adaptSize,
                            ),
                            SizedBox(width: 8.h),
                            Obx(() => Text(
                                  "Overall Summative: ${examprogressbarItemModelObj.overallSummative?.value ?? '0'}/100 %",
                                  style: CustomTextStyles.bodyMediumBlack900,
                                )),
                          ],
                        ),
                        SizedBox(height: 12.v),
                        Row(
                          children: [
                            CustomImageView(
                              svgPath: ImageConstant.imgMenuGray700,
                              height: 18.adaptSize,
                              width: 18.adaptSize,
                            ),
                            SizedBox(width: 8.h),
                            Obx(() => Text(
                                  "Overall Percentage: ${examprogressbarItemModelObj.overallPercentage?.value ?? '0'}/100 %",
                                  style: CustomTextStyles.bodyMediumBlack900,
                                )),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: 80.h), // Add spacing if needed
                  ],
                ),
              ],
            ),

            /// Right-middle positioned progress bar
            Positioned(
              right: 0,
              top: 30,
              bottom: 0,
              child: Center(
                child: Obx(() => CircularPercentIndicator(
                      radius: 25.0,
                      lineWidth: 5.0,
                      percent:
                          (examprogressbarItemModelObj.percentage?.value ?? 0) /
                              100,
                      circularStrokeCap: CircularStrokeCap.round,
                      animation: true,
                      animationDuration: 1000,
                      backgroundColor: appTheme.blueGray100,
                      center: Text(
                        "${examprogressbarItemModelObj.overallPercentage?.value ?? '0%'}",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.fSize,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                      progressColor: theme.colorScheme.primary,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
