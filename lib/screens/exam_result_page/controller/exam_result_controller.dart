import 'package:get/get.dart';

import '../models/exam_result_model.dart';

/// A controller class for the ExamResultPage.
///
/// This class manages the state of the ExamResultPage, including the
/// current examResultModelObj
class ExamResultController extends GetxController {
  ExamResultController(this.examResultModelObj);

  Rx<ExamResultModel> examResultModelObj;
}
