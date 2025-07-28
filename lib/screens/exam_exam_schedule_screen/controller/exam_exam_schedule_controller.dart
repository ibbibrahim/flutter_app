import 'package:get/get.dart';
import '../models/exam_exam_schedule_model.dart';

/// A controller class for the ExamExamScheduleScreen.
///
/// This class manages the state of the ExamExamScheduleScreen, including the
/// current examExamScheduleModelObj
class ExamExamScheduleController extends GetxController {
  Rx<ExamExamScheduleModel> examExamScheduleModelObj =
      ExamExamScheduleModel().obs;
}
