import 'examdetails_item_model.dart';
import 'package:get/get.dart';

/// This class defines the variables used in the [exam_exam_schedule_screen],
/// and is typically used to hold data that is passed between different parts of the application.
class ExamExamScheduleModel {
  Rx<List<ExamdetailsItemModel>> examdetailsItemList = Rx(List.generate(
      5,
      (index) => ExamdetailsItemModel(
          time: "", passMarks: "", totalMarks: "", subject: "", date: "")));
}
