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
    final section = studentData['Section'] ?? '';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTapExamprogressbar?.call(),
        borderRadius: BorderRadius.circular(12),
        splashColor: theme.colorScheme.primary.withOpacity(0.1),
        child: Container(
          margin: EdgeInsets.only(bottom: 12.v),
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 22.v),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
            border: Border(
              left: BorderSide(
                color: theme.colorScheme.primary,
                width: 4,
              ),
            ),
          ),
          child: Stack(
            children: [
              // Left content: title + details (subtitle removed)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                    "$section-${examprogressbarItemModelObj.examName?.value ?? ''} ($academicSession)",
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
                          _buildInfoRow(
                            icon: ImageConstant.imgMenu,
                            label:
                            "Formative: ${examprogressbarItemModelObj.overallFormative?.value ?? '0'}/100",
                          ),
                          SizedBox(height: 12.v),
                          _buildInfoRow(
                            icon: ImageConstant.imgMenuTeal600,
                            label:
                            "Summative: ${examprogressbarItemModelObj.overallSummative?.value ?? '0'}/100",
                          ),
                          SizedBox(height: 12.v),
                          _buildInfoRow(
                            icon: ImageConstant.imgMenuGray700,
                            label:
                            "Total %: ${examprogressbarItemModelObj.overallPercentage?.value ?? '0'}/100",
                          ),
                        ],
                      ),
                      SizedBox(width: 80.h),
                    ],
                  ),
                ],
              ),

              // Right-middle: progress + chevron + "Tap to view details"
              Positioned(
                right: 0,
                top: 30,
                bottom: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => CircularPercentIndicator(
                      radius: 25.0,
                      lineWidth: 5.0,
                      percent: (examprogressbarItemModelObj.percentage?.value ?? 0) / 100,
                      circularStrokeCap: CircularStrokeCap.round,
                      animation: true,
                      animationDuration: 1000,
                      backgroundColor: appTheme.blueGray100,
                      center: Text(
                        "${examprogressbarItemModelObj.overallPercentage?.value ?? '0'}",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.fSize,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                      progressColor: theme.colorScheme.primary,
                    )),
                    SizedBox(height: 8.v),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chevron_right,
                          size: 24.fSize,
                          color: theme.colorScheme.primary,
                        ),
                        SizedBox(width: 4.h),
                        Text(
                          "View Result",
                          style: CustomTextStyles.bodyLargeBluegray90001,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({required String icon, required String label}) {
    return Row(
      children: [
        CustomImageView(
          svgPath: icon,
          height: 18.adaptSize,
          width: 18.adaptSize,
        ),
        SizedBox(width: 8.h),
        Text(label, style: CustomTextStyles.bodyMediumBlack900),
      ],
    );
  }
}
