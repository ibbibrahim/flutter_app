import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:login_portal/utils/size_utils.dart';
import '../../../utils/theme_helper.dart';
import '../../exam_result_page/models/subject_result_model.dart';

class FirstTermExamItemWidget extends StatelessWidget {
  final SubjectResult result;

  const FirstTermExamItemWidget({Key? key, required this.result})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.v),
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            result.courseName,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium,
          ),
          SizedBox(height: 12.v),

          _buildProgressRow(
            label: "Formative",
            percentage: result.fPercentage,
            grade: result.fGrade,
            color: Colors.orange,
          ),
          SizedBox(height: 12.v),

          _buildProgressRow(
            label: "Summative",
            percentage: result.sPercentage ?? 0,
            grade: result.sGrade ?? "-",
            color: Colors.blue,
          ),
          SizedBox(height: 12.v),

          _buildProgressRow(
            label: "Total Percentage",
            percentage: result.overallPercentage ?? 0,
            grade: result.overallGrade ?? "-",
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRow({
    required String label,
    required double percentage,
    required String grade,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$label: $grade",
              style: theme.textTheme.bodyLarge,
            ),
            Text(
              "${percentage.toStringAsFixed(1)}%",
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
        SizedBox(height: 6.v),
        LinearPercentIndicator(
          barRadius: Radius.circular(12.h),
          width: 276.h,
          animation: true,
          animationDuration: 1000,
          lineHeight: 8.0,
          padding: EdgeInsets.zero,
          backgroundColor: appTheme.blueGray100,
          percent: (percentage / 100).clamp(0.0, 1.0),
          progressColor: color,
        ),
      ],
    );
  }
}
