import 'package:get/get.dart';

class StudentController extends GetxController {
  late Map<String, dynamic> student;     // the whole JSON map
  late bool hasSiblings;
  late List<dynamic>? siblings;

  /// Call this once after a successful login
  void setStudent({
    required Map<String, dynamic> json,
    required bool hasSiblingsFlag,
    required List<dynamic>? sibs,
  }) {
    student      = json;
    hasSiblings  = hasSiblingsFlag;
    siblings     = sibs;
  }

  /// Call this during logout to clear all student data
  void clearStudent() {
    student = {};
    hasSiblings = false;
    siblings = null;
  }
}
