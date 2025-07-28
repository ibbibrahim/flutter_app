import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_portal/utils/size_utils.dart';

import '../../utils/app_decoration.dart';
import '../../widgets/appbar_title.dart';
import '../../widgets/custom_app_bar.dart';
import '../exam_result_page/controller/exam_result_controller.dart';
import '../exam_result_page/models/subject_result_model.dart';
import '../first_term_exam_screen/widgets/first_term_exam_item_widget.dart';

class FirstTermExamScreen extends StatefulWidget {
  const FirstTermExamScreen({Key? key}) : super(key: key);

  @override
  State<FirstTermExamScreen> createState() => _FirstTermExamScreenState();
}

class _FirstTermExamScreenState extends State<FirstTermExamScreen> {
  final controller = Get.find<ExamResultController>();

  @override
  void initState() {
    super.initState();

    final int termId = Get.arguments['termId'];
    final int studentId = Get.arguments['studentId'];

    controller.fetchSubjectResults(studentId: studentId, termId: termId);
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 22.v),
            decoration: AppDecoration.white,
            child: CustomAppBar(
              leadingWidth: 44.h,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Get.back(),
              ),
              centerTitle: true,
              title: AppbarTitle(text: "Term Results"),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 0.v),
              child: Obx(() {
                final List<SubjectResult> subjectResults =
                    controller.examResultModelObj.value.subjectResults.value;

                if (subjectResults.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemCount: subjectResults.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10.v),
                  itemBuilder: (context, index) {
                    return FirstTermExamItemWidget(
                      result: subjectResults[index],
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
