import 'package:login_portal/utils/size_utils.dart';

import '../../utils/app_decoration.dart';
import '../../utils/image_constant.dart';
import '../../widgets/appbar_image_2.dart';
import '../../widgets/appbar_title.dart';
import '../../widgets/custom_app_bar.dart';
import '../first_term_exam_screen/widgets/first_term_exam_item_widget.dart';
import 'controller/first_term_exam_controller.dart';
import 'models/first_term_exam_item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirstTermExamScreen extends GetWidget<FirstTermExamController> {
  const FirstTermExamScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
        body: Column(children: [
          Container(
              padding: EdgeInsets.symmetric(vertical: 22.v),
              decoration: AppDecoration.white,
              child: CustomAppBar(
                  leadingWidth: 44.h,
                  leading: AppbarImage2(
                      svgPath: ImageConstant.imgArrowleft,
                      margin: EdgeInsets.only(
                          left: 20.h, top: 6.v, bottom: 3.v),
                      onTap: () {
                        onTapArrowleftone();
                      }),
                  centerTitle: true,
                  title: AppbarTitle(text: "lbl_first_term_exam".tr))),
          Padding(
            padding:  EdgeInsets.only(left: 20.h,right: 20.h,top: 30.h),
            child: ListView.separated(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                primary: true,
                padding: EdgeInsets.zero,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 20.v);
                },
                itemCount: firstExamData.length,
                itemBuilder: (context, index) {
                  return FirstTermExamItemWidget(
                      image: firstExamData[index].image,
                      text: firstExamData[index].text,
                      progress: firstExamData[index].progress,
                      progressText: firstExamData[index].progressText
                  );
                }),
          ),
          // Expanded(
          //     child: Padding(
          //         padding: EdgeInsets.only(
          //             left: 20.h, top: 16.v, right: 20.h),
          //         child: Obx(() => ListView.separated(
          //             physics: BouncingScrollPhysics(),
          //             shrinkWrap: true,
          //             separatorBuilder: (context, index) {
          //               return SizedBox(height: 20.v);
          //             },
          //             itemCount: controller.firstTermExamModelObj.value
          //                 .firstTermExamItemList.value.length,
          //             itemBuilder: (context, index) {
          //               FirstTermExamItemModel model = controller
          //                   .firstTermExamModelObj
          //                   .value
          //                   .firstTermExamItemList
          //                   .value[index];
          //               return FirstTermExamItemWidget(model);
          //             }))))
        ]));
  }

  /// Navigates to the previous screen.
  ///
  /// When the action is triggered, this function uses the [Get] package to
  /// navigate to the previous screen in the navigation stack.
  onTapArrowleftone() {
    Get.back();
  }
}
