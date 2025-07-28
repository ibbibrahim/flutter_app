import '../controller/exam_result_tab_container_controller.dart';
import 'package:get/get.dart';

/// A binding class for the ExamResultTabContainerScreen.
///
/// This class ensures that the ExamResultTabContainerController is created when the
/// ExamResultTabContainerScreen is first loaded.
class ExamResultTabContainerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ExamResultTabContainerController());
  }
}
