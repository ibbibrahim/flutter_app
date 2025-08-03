import 'package:get/get.dart';

class StudentController extends GetxController {
  Map<String, dynamic> student = {};
  bool hasSiblings = false;
  List<dynamic>? siblings;

  void setStudent({
    required Map<String, dynamic> json,
    required bool hasSiblingsFlag,
    required List<dynamic>? sibs,
  }) {
    student = json;
    hasSiblings = hasSiblingsFlag;
    siblings = sibs;
    update(); // ✅ important!
  }

  void clearStudent() {
    student = {};
    hasSiblings = false;
    siblings = null;
    update(); // ✅ important!
  }
}
