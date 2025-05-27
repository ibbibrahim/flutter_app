import 'package:get/get.dart';

/// This class is used in the [examprogressbar_item_widget] screen.

class ExamprogressbarItemModel {
  ExamprogressbarItemModel({
    this.examName,
    this.examScore,
    this.id,
  }) {
    examName = examName ?? Rx("First Term  Exam");
    examScore = examScore ?? Rx("400/500");
    id = id ?? Rx("");
  }

  Rx<String>? examName;

  Rx<String>? examScore;

  Rx<String>? id;
}
