import '../controller/first_term_exam_controller.dart';
import 'package:get/get.dart';

/// A binding class for the FirstTermExamScreen.
///
/// This class ensures that the FirstTermExamController is created when the
/// FirstTermExamScreen is first loaded.
class FirstTermExamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FirstTermExamController());
  }
}
