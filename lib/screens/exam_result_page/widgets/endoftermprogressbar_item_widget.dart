import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../controllers/student_controller.dart';
import '../../../utils/theme_helper.dart';
import '../../../utils/custom_text_style.dart';
import '../../../utils/size_utils.dart';
import '../../../utils/app_decoration.dart';

class EndOfTermCombinedProgressbarWidget extends StatelessWidget {
  final int overallT1;
  final int overallT2;
  final int endOfTerm;

  const EndOfTermCombinedProgressbarWidget({
    Key? key,
    required this.overallT1,
    required this.overallT2,
    required this.endOfTerm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final studentData = Get.find<StudentController>().student;
    final academicSession = studentData['AcademicSession'] ?? '2024-2025';
    final section = studentData['Section'] ?? '';

    return Container(
      padding: EdgeInsets.all(20.h),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$section - End of Term ($academicSession)",
            style: theme.textTheme.titleMedium,
          ),
          SizedBox(height: 16.v),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCircularIndicator("Term 1", overallT1),
              _buildCircularIndicator("Term 2", overallT2),
              _buildCircularIndicator("End Term", endOfTerm),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCircularIndicator(String title, int percentage) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 30.0,
          lineWidth: 5.0,
          percent: percentage / 100,
          circularStrokeCap: CircularStrokeCap.round,
          animation: true,
          animationDuration: 1000,
          backgroundColor: appTheme.blueGray100,
          center: Text(
            "$percentage%",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 12.fSize,
              fontFamily: 'SF Pro Display',
            ),
          ),
          progressColor: theme.colorScheme.primary,
        ),
        SizedBox(height: 8.v),
        Text(
          title,
          style: CustomTextStyles.bodyMediumBlack900,
        ),
      ],
    );
  }
}
