import 'package:get/get.dart';

/// This class is used in the [examprogressbar_item_widget] screen.

import 'package:get/get.dart';

/// This class is used in the [examprogressbar_item_widget] screen.

class ExamprogressbarItemModel {
  ExamprogressbarItemModel({
    this.examName,
    this.examScore,
    this.id,
    this.percentage,
    this.overallFormative,
    this.overallSummative,
    this.overallPercentage,
  }) {
    examName = examName ?? Rx("First Term Exam");
    examScore = examScore ?? Rx("0%");
    id = id ?? Rx("");
    percentage = percentage ?? Rx(0.0);

    // New fields
    overallFormative = overallFormative ?? Rx("0%");
    overallSummative = overallSummative ?? Rx("0%");
    overallPercentage = overallPercentage ?? Rx("0%");
  }

  Rx<String>? examName;
  Rx<String>? examScore;
  Rx<String>? id;
  Rx<double>? percentage;

  // New fields
  Rx<String>? overallFormative;
  Rx<String>? overallSummative;
  Rx<String>? overallPercentage;
}


