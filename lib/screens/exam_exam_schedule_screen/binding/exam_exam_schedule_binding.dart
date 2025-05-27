import '../controller/exam_exam_schedule_controller.dart';
import 'package:get/get.dart';

/// A binding class for the ExamExamScheduleScreen.
///
/// This class ensures that the ExamExamScheduleController is created when the
/// ExamExamScheduleScreen is first loaded.
class ExamExamScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ExamExamScheduleController());
  }
}
