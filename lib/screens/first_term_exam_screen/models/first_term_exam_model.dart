import 'package:get/get.dart';
import 'first_term_exam_item_model.dart';

/// This class defines the variables used in the [first_term_exam_screen],
/// and is typically used to hold data that is passed between different parts of the application.
class FirstTermExamModel {
  Rx<List<FirstTermExamItemModel>> firstTermExamItemList =
      Rx(List.generate(6, (index) => FirstTermExamItemModel()));
}
