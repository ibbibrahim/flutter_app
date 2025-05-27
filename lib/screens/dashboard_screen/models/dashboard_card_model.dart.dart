import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_portal/controllers/student_controller.dart';
import 'package:login_portal/screens/attendance_screen_copy.dart';
import 'package:login_portal/screens/basic_information_screen.dart';
import 'package:login_portal/screens/exam_result_tab_container_screen/exam_result_tab_container_screen.dart';
import 'package:login_portal/screens/health_profile_screen.dart';
import 'package:login_portal/utils/image_constant.dart';

import '../../alert_screen.dart';
import '../../bus_detail_screen.dart';
import '../../course_screen.dart';
import '../../exam_result_tab_container_screen/controller/exam_result_tab_container_controller.dart';
import '../../policies_screen.dart';
import '../../student_achievements_screen.dart';
import '../../student_invoice_screen.dart';
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

// 🔽 Get the student controller and student data
final sc = Get.find<StudentController>();
final studentData = sc.student;

// 🔽 Define your cards in the same file
final List<DashboardCardModel> dashboardCards = [
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
    image: ImageConstant.userRemove,
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
    // Replace if you want to use a specific health image
    color: Colors.amber.shade100,
    onTap: () {
      Get.to(() => HealthProfileScreen(
            studentId: studentData['StudentID'].toString(),
            fatherQatarId: studentData['FatherQatarID'].toString(),
          ));
    },
  ),
  DashboardCardModel(
    text: "Achievements",
    image: ImageConstant.fees,
    // Assuming `star` is in your constants or use another icon
    color: Colors.orange.shade100,
    onTap: () {
      Get.to(() => StudentAchievementsScreen(
            studentId: studentData['StudentID'].toString(),
          ));
    },
  ),
  DashboardCardModel(
    text: "Courses",
    image: ImageConstant.home_work, // Replace with course-related icon
    color: Colors.deepPurple.shade100,
    onTap: () {
      Get.to(() => CoursesScreen(
            gradeGroupId: studentData['GradeGroupID'].toString(),
            sectionId: studentData['SectionID'].toString(),
          ));
    },
  ),
  DashboardCardModel(
    text: "Fee",
    image: ImageConstant.fees,
    color: Colors.teal.shade100,
    onTap: () {
      Get.to(() => FeeInvoiceScreen(
            studentId: studentData['StudentID'].toString(),
            sessionId: studentData['AcademicSessionID'].toString(),
            feeTypeId: 1.toString(),
          ));
    },
  ),
  DashboardCardModel(
    text: "Policies",
    image: ImageConstant.imgFolder, // Policy-related icon
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
      Get.put(ExamResultTabContainerController()); // 👈 initializes the controller
      Get.to(() => ExamResultTabContainerScreen());
    },
  ),
  if (studentData['Bus'] != null)
    DashboardCardModel(
      text: "Bus",
      image: ImageConstant.imgAirplane, // Replace with bus icon if available
      color: Colors.cyan.shade100,
      onTap: () {
        Get.to(() => BusDetailsScreen(
              studentId: studentData['StudentID'].toString(),
            ));
      },
    ),
  if (sc.hasSiblings)
    DashboardCardModel(
      text: "Siblings",
      image: ImageConstant.community,
      // Replace with a sibling/group icon if available
      color: Colors.indigo.shade100,
      onTap: () {
        Get.offNamed('/siblings', arguments: sc.siblings);
      },
    ),
];
