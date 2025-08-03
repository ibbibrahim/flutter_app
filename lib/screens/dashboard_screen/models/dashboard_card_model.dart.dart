import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_portal/controllers/student_controller.dart';
import 'package:login_portal/screens/attendance_screen_copy.dart';
import 'package:login_portal/screens/basic_information_screen.dart';
import 'package:login_portal/screens/exam_result_tab_container_screen/exam_result_tab_container_screen.dart';
import 'package:login_portal/screens/health_profile_screen.dart';
import 'package:login_portal/utils/image_constant.dart';

import '../../../utils/funtions.dart';
import '../../alert_screen.dart';
import '../../bus_detail_screen.dart';
import '../../course_screen.dart';
import '../../exam_result_tab_container_screen/controller/exam_result_tab_container_controller.dart';
import '../../policies_screen.dart';
import '../../student_achievements_screen.dart';
import '../../student_invoice_screen_copy.dart';
import '../../parent_details_screen.dart';

class DashboardCardModel {
  final String text;
  final String image;
  final Color color;
  final VoidCallback onTap;

  DashboardCardModel({
    required this.text,
    required this.image,
    required this.color,
    required this.onTap,
  });
}

// ❌ Remove global cached studentData
// final sc = Get.find<StudentController>();
// final studentData = sc.student;

List<DashboardCardModel> getDashboardCards() {
  final sc = Get.find<StudentController>();

  return [
    DashboardCardModel(
      text: "Basic Info",
      image: ImageConstant.user,
      color: Colors.lightBlue.shade100,
      onTap: () {
        Get.to(() => BasicInformationScreen());
      },
    ),
    DashboardCardModel(
      text: "Parent Info",
      image: ImageConstant.community,
      color: Colors.pink.shade100,
      onTap: () {
        Get.to(() => ParentDetailsScreen());
      },
    ),
    DashboardCardModel(
      text: "Attendance",
      image: ImageConstant.attendance,
      color: Colors.green.shade100,
      onTap: () {
        Get.to(() => AttendanceScreen());
      },
    ),
    DashboardCardModel(
      text: "Health",
      image: ImageConstant.check,
      color: Colors.amber.shade100,
      onTap: () {
        Get.to(() => HealthProfileScreen(
          studentId: sc.student['StudentID'].toString(),
          fatherQatarId: sc.student['FatherQatarID'].toString(),
        ));
      },
    ),
    DashboardCardModel(
      text: "Achievements",
      image: ImageConstant.fees,
      color: Colors.orange.shade100,
      onTap: () {
        Get.to(() => StudentAchievementsScreen(
          studentId: sc.student['StudentID'].toString(),
        ));
      },
    ),
    DashboardCardModel(
      text: "Courses",
      image: ImageConstant.home_work,
      color: Colors.deepPurple.shade100,
      onTap: () {
        Get.to(() => CoursesScreen(
          gradeGroupId: sc.student['GradeGroupID'].toString(),
          sectionId: sc.student['SectionID'].toString(),
        ));
      },
    ),
    DashboardCardModel(
      text: "Fee",
      image: ImageConstant.fees,
      color: Colors.teal.shade100,
      onTap: () {
        Get.to(() => FeeInvoiceScreen(
          studentId: generateMd5Hash(sc.student['StudentID'].toString()),
          sessionId: generateMd5Hash(sc.student['AcademicSessionID'].toString()),
          feeTypeId: generateMd5Hash("1"),
        ));
      },
    ),
    DashboardCardModel(
      text: "Policies",
      image: ImageConstant.imgFolder,
      color: Colors.blue.shade100,
      onTap: () {
        Get.to(() => WebPoliciesScreen());
      },
    ),
    DashboardCardModel(
      text: "Alerts",
      image: ImageConstant.imgNotification,
      color: Colors.red.shade100,
      onTap: () {
        Get.to(() => AlertScreen());
      },
    ),
    DashboardCardModel(
      text: "Exam",
      image: ImageConstant.exam,
      color: Colors.red.shade100,
      onTap: () {
        Get.put(ExamResultTabContainerController());
        Get.to(() => ExamResultTabContainerScreen());
      },
    ),
    if (sc.student['Bus'] != null)
      DashboardCardModel(
        text: "Bus",
        image: ImageConstant.imgAirplane,
        color: Colors.cyan.shade100,
        onTap: () {
          Get.to(() => BusDetailsScreen(
            studentId: sc.student['StudentID'].toString(),
          ));
        },
      ),
    if (sc.hasSiblings)
      DashboardCardModel(
        text: "Siblings",
        image: ImageConstant.community,
        color: Colors.indigo.shade100,
        onTap: () {
          Get.offNamed('/siblings', arguments: sc.siblings);
        },
      ),
  ];
}
