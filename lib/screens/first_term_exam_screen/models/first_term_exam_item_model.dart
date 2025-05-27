import 'package:get/get.dart';

import '../../../utils/image_constant.dart';

/// This class is used in the [first_term_exam_item_widget] screen.

class FirstTermExamItemModel {
  FirstTermExamItemModel({
    this.progress,
    this.image,
    this.text,
    this.progressText,
  });
  String? image;
  String? text;
  double? progress;
  String? progressText;
}
List<FirstTermExamItemModel>firstExamData=[
  FirstTermExamItemModel(
    text: "Science".tr,
    image: ImageConstant.science,
    progressText: "80/100".tr,
    progress: 0.80,
  ),
  FirstTermExamItemModel(
    text: "Maths".tr,
    image: ImageConstant.maths,
    progressText: "88/100".tr,
    progress: 0.88,
  ),
  FirstTermExamItemModel(
    text: "Social Science ".tr,
    image: ImageConstant.ss,
    progressText: "90/100".tr,
    progress: 0.90,
  ),
  FirstTermExamItemModel(
    text: "English".tr,
    image: ImageConstant.english,
    progressText: "84/100".tr,
    progress: 0.84,
  ),
  FirstTermExamItemModel(
    text: "Gujrati".tr,
    image: ImageConstant.gujrati,
    progressText: "89/100".tr,
    progress: 0.89,
  ),
  FirstTermExamItemModel(
    text: "Hindi".tr,
    image: ImageConstant.hindi,
    progressText: "95/100".tr,
    progress: 0.95,
  ),
];