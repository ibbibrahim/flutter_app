import '../../utils/size_utils.dart';
import '../exam_exam_schedule_screen/widgets/examdetails_item_widget.dart';
import 'controller/exam_exam_schedule_controller.dart';
import 'models/examdetails_item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExamExamScheduleScreen extends GetWidget<ExamExamScheduleController> {
  const ExamExamScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return ListView.separated(
        padding: EdgeInsets.only(left: 20.h, right: 20.h, top: 30.h),
        physics: BouncingScrollPhysics(),
        // shrinkWrap: true,
        separatorBuilder: (context, index) {
          return SizedBox(height: 20.v);
        },
        itemCount: examlListData.length,
        itemBuilder: (context, index) {
          return ExamdetailsItemWidget(
              subject: examlListData[index].subject,
              totalMarks: examlListData[index].totalMarks,
              passMarks: examlListData[index].passMarks,
              time: examlListData[index].time,
              date: examlListData[index].date);
        });
    // return Scaffold(
    //     appBar: CustomAppBar(
    //         height: 81.v,
    //         leadingWidth: 44.h,
    //         leading: AppbarImage2(
    //             svgPath: ImageConstant.imgArrowleft,
    //             margin: EdgeInsets.only(left: 20.h, top: 0.v, bottom: 0.v),
    //             onTap: () {
    //               onTapArrowleftone();
    //             }),
    //         centerTitle: true,
    //         title: AppbarTitle(text: "lbl_exam".tr),
    //         styleType: Style.bgFill),
    //     body: Container(
    //         width: double.maxFinite,
    //         padding: EdgeInsets.symmetric(horizontal: 20.h),
    //         child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
    //           SizedBox(height: 83.v),
    //           Expanded(
    //               child:  ),
    //           // Container(
    //           //     width: 388.h,
    //           //     padding:
    //           //         EdgeInsets.symmetric(horizontal: 20.h, vertical: 23.v),
    //           //     decoration: AppDecoration.fillGray
    //           //         .copyWith(borderRadius: BorderRadiusStyle.roundedBorder8),
    //           //     child: Column(
    //           //         mainAxisSize: MainAxisSize.min,
    //           //         crossAxisAlignment: CrossAxisAlignment.start,
    //           //         children: [
    //           //           SizedBox(height: 64.v),
    //           //           Text("msg_science_chapter".tr,
    //           //               style: theme.textTheme.titleMedium)
    //           //         ]))
    //         ])));
  }

  /// Navigates to the previous screen.
  ///
  /// When the action is triggered, this function uses the [Get] package to
  /// navigate to the previous screen in the navigation stack.
  onTapArrowleftone() {
    Get.back();
  }
}
