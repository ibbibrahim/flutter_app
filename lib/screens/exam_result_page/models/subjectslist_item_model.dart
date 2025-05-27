import 'package:flutter/material.dart';

/// This class is used in the [subjectslist_item_widget] screen.

class SubjectslistItemModel {
  SubjectslistItemModel({
    this.secondText,
    this.secondColor,
    this.color,
    this.text,
  });

  final String? text;
  final Color? color;
  final String? secondText;
  final Color? secondColor;
}

List<SubjectslistItemModel> colorList = [
  SubjectslistItemModel(
    color: Color(0xFFF94144),
    text: "Sci",
  ),
  SubjectslistItemModel(
    color: Color(0xFFF3722C),
    text: "Maths",
  ),
  SubjectslistItemModel(
    color: Color(0xFFF8961E),
    text: "Social Science",
  ),
];
List<SubjectslistItemModel> colorListSecond = [
  SubjectslistItemModel(
    color: Color(0xFFF9C74F),
    text: "English",
  ),
  SubjectslistItemModel(
    color: Color(0xFF90BE6D),
    text: "Gujrati",
  ),
  SubjectslistItemModel(
    color: Color(0xFF2D9CDB),
    text: "Hindi",
  ),
];
