import 'package:get/get.dart';
import 'package:flutter/material.dart';/// A controller class for the ExamResultTabContainerScreen.

import '../models/exam_result_tab_container_model.dart';

///
///
/// This class manages the state of the ExamResultTabContainerScreen, including the
/// current examResultTabContainerModelObj
class ExamResultTabContainerController extends GetxController with  GetSingleTickerProviderStateMixin {Rx<ExamResultTabContainerModel> examResultTabContainerModelObj = ExamResultTabContainerModel().obs;

late TabController tabviewController = Get.put(TabController(vsync: this, length: 2));

 }
