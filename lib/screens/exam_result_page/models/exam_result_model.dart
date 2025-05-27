import 'package:get/get.dart';

import 'subjectslist_item_model.dart';
import 'examprogressbar_item_model.dart';

/// This class defines the variables used in the [exam_result_page],
/// and is typically used to hold data that is passed between different parts of the application.
class ExamResultModel {
  Rx<List<SubjectslistItemModel>> subjectslistItemList =
      Rx(List.generate(3, (index) => SubjectslistItemModel()));

  Rx<List<ExamprogressbarItemModel>> examprogressbarItemList =
      Rx(List.generate(2, (index) => ExamprogressbarItemModel()));
}
