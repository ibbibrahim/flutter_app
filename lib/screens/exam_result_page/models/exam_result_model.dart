import 'package:get/get.dart';
import 'end_of_term_result_model.dart';
import 'examprogressbar_item_model.dart';
import 'subject_result_model.dart'; // <-- renamed from subject_result_model.dart

/// This class defines the variables used in the [exam_result_page],
/// and is typically used to hold data that is passed between different parts of the application.
class ExamResultModel {
  Rx<List<ExamprogressbarItemModel>> examprogressbarItemList =
  Rx(List.generate(2, (index) => ExamprogressbarItemModel()));
  RxList<SubjectResult> subjectResults = <SubjectResult>[].obs;
  Rx<EndOfTermResult?> endOfTermResult = Rx<EndOfTermResult?>(null);
}
