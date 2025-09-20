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
    this.sectionName,
    this.sessionName,
  }) {
    examName = examName ?? Rx("First Term Exam");
    examScore = examScore ?? Rx("0%");
    id = id ?? Rx("");
    percentage = percentage ?? Rx(0.0);
    overallFormative = overallFormative ?? Rx("0%");
    overallSummative = overallSummative ?? Rx("0%");
    overallPercentage = overallPercentage ?? Rx("0%");
    sectionName = sectionName ?? Rx("");
    sessionName = sessionName ?? Rx("");
  }

  Rx<String>? examName;
  Rx<String>? examScore;
  Rx<String>? id;
  Rx<double>? percentage;
  Rx<String>? overallFormative;
  Rx<String>? overallSummative;
  Rx<String>? overallPercentage;

  // ✅ NEW FIELDS
  Rx<String>? sectionName;
  Rx<String>? sessionName;
}


