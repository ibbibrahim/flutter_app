import 'package:login_portal/utils/size_utils.dart';
import '../../../utils/app_decoration.dart';
import '../../../utils/custom_text_style.dart';
import '../../../utils/image_constant.dart';
import '../../../utils/theme_helper.dart';
import '../../../widgets/custom_image_view.dart';
import '../controller/exam_exam_schedule_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ExamdetailsItemWidget extends StatelessWidget {
  final String subject;
  final String totalMarks;
  final String passMarks;
  final String time;
  final String date;

  ExamdetailsItemWidget({
    Key? key,
    required this.subject,
    required this.totalMarks,
    required this.passMarks,
    required this.time,
    required this.date,
  }) : super(key: key);

  var controller =
  Get.put<ExamExamScheduleController>(ExamExamScheduleController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.h,
        vertical: 22.v,
      ),
      decoration: AppDecoration.fillGray.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            subject,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium,
          ),
          Padding(
            padding: EdgeInsets.only(top: 17.v),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// First column (left)
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
                        Text(
                          totalMarks,
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyles.bodyMediumBlack900,
                        ),
                      ],
                    ),
                    SizedBox(height: 12.v),
                    Row(
                      children: [
                        CustomImageView(
                          svgPath: ImageConstant.imgCalendarPurple600,
                          height: 18.adaptSize,
                          width: 18.adaptSize,
                        ),
                        SizedBox(width: 8.h),
                        Text(
                          date,
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyles.bodyMediumBlack900,
                        ),
                      ],
                    ),
                  ],
                ),

                /// Spacer between columns
                SizedBox(width: 32.h),

                /// Second column (right) with Expanded
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomImageView(
                            svgPath: ImageConstant.imgMenuTeal600,
                            height: 18.adaptSize,
                            width: 18.adaptSize,
                          ),
                          SizedBox(width: 8.h),
                          Text(
                            passMarks,
                            overflow: TextOverflow.ellipsis,
                            style: CustomTextStyles.bodyMediumBlack900,
                          ),
                        ],
                      ),
                      SizedBox(height: 12.v),
                      Row(
                        children: [
                          CustomImageView(
                            svgPath: ImageConstant.imgSearchBlueGray800,
                            height: 18.adaptSize,
                            width: 18.adaptSize,
                          ),
                          SizedBox(width: 8.h),
                          Text(
                            time,
                            overflow: TextOverflow.ellipsis,
                            style: CustomTextStyles.bodyMediumBlack900,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
