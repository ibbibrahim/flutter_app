import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:login_portal/screens/exam_result_page/widgets/endoftermprogressbar_item_widget.dart';

import '../../controllers/student_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/custom_text_style.dart';
import '../../utils/funtions.dart';
import '../../widgets/insulin_chart.dart';
import '../exam_result_page/widgets/examprogressbar_item_widget.dart';
import '../exam_result_page/widgets/subjectslist_item_widget.dart';
import 'controller/exam_result_controller.dart';
import 'models/exam_result_model.dart';
import 'models/examprogressbar_item_model.dart';
import 'models/subjectslist_item_model.dart';
import 'package:flutter/material.dart';
import 'package:login_portal/utils/size_utils.dart';

// User opens screen
// ↓
// initState() triggers 2 API calls
// ↓
// API responses go to controller
// ↓
// Controller updates reactive model (Rx)
// ↓
// Model changes auto-refresh UI widgets via Obx()
// ↓
// User sees updated chart and term progress bars

final colors = [
  Color(0xFFF94144),
  Color(0xFFF3722C),
  Color(0xFFF8961E),
  Color(0xFFF9C74F),
  Color(0xFF90BE6D),
  Color(0xFF2D9CDB),
  Color(0xFF277DA1),
  Color(0xFF577590),
  Color(0xFF4D908E),
  Color(0xFF43AA8B),
];

class ExamResultPage extends StatefulWidget {
  ExamResultPage({Key? key}) : super(key: key);

  @override
  State<ExamResultPage> createState() => _ExamResultPageState();
}

// ignore_for_file: must_be_immutable
class _ExamResultPageState extends State<ExamResultPage> {
  final ExamResultController controller =
      Get.put(ExamResultController(ExamResultModel().obs));
  List<Map<String, dynamic>> sessions = [];
  int selectedSessionId = 0;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    final studentData = Get.find<StudentController>().student;
    final studentId = studentData['StudentID'];

    await fetchSessions(); // wait for sessions and selectedSessionId

    // ✅ Now that selectedSessionId is set, call your controller methods
    controller.fetchTermWiseResults(
        studentId: studentId, sessionId: selectedSessionId);
    controller.fetchEndOfTermResult(
        studentId: studentId, sessionId: selectedSessionId);
  }

  Future<void> fetchSessions() async {
    try {
      final response = await http.get(Uri.parse(
        'https://pers.tngqatar.online/Controler/Public/PerspectiveApi.php?Action=${generateMd5Hash('getAcademicSessions')}',
      ));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        if (data.isNotEmpty) {
          setState(() {
            sessions = List<Map<String, dynamic>>.from(data);
            selectedSessionId = int.parse(data.last['id'].toString());
          });
        }
      }
    } catch (e) {
      print("Error loading sessions: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.h, top: 24.v, right: 20.h),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (sessions.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 16.v, right: 20.h),
                child: Row(
                  children: [
                    Text("Session:", style: CustomTextStyles.titleLarge22),
                    SizedBox(width: 12.h),
                    Expanded(
                      child: DropdownButton<int>(
                        value: selectedSessionId,
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down),
                        underline: Container(
                          height: 1,
                          color: Colors.grey.shade400,
                        ),
                        items: sessions.map((session) {
                          final isSelected =
                              int.parse(session['id'].toString()) == selectedSessionId;
                          return DropdownMenuItem<int>(
                            value: int.parse(session['id'].toString()),
                            child: Text(
                              session['name'],
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected ? Colors.blue : Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null && value != selectedSessionId) {
                            setState(() {
                              selectedSessionId = value;
                            });

                            final studentId = Get.find<StudentController>()
                                .student['StudentID'];

                            // Reload results for selected session
                            controller.fetchTermWiseResults(
                                studentId: studentId, sessionId: value);
                            controller.fetchEndOfTermResult(
                                studentId: studentId, sessionId: value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            Text("lbl_overall_results".tr,
                style: CustomTextStyles.titleLarge22),

            SizedBox(height: 19.v),
            Obx(() {
              if (controller.isLoadingProgress.value) {
                return Center(child: CircularProgressIndicator());
              }

              final progressBars = controller
                  .examResultModelObj.value.examprogressbarItemList.value;

              if (progressBars.isEmpty) {
                return Center(child: Text("No results available."));
              }

              return ListView.separated(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 16.v);
                },
                itemCount: progressBars.length,
                itemBuilder: (context, index) {
                  final model = progressBars[index];
                  return ExamprogressbarItemWidget(
                    model,
                    onTapExamprogressbar: () {
                      final termId = int.tryParse(model.id!.value) ?? 0;
                      onTapExamprogressbar(termId);
                    },
                  );
                },
              ).marginOnly(bottom: 24.h);
            }),

            // SizedBox(
            //   height: 25.h,
            // ),
            // Align(
            //     alignment: Alignment.center,
            //     child: Container(
            //         height: 40.v,
            //         // color: Colors.grey,
            //         child: ListView.separated(
            //             padding:
            //                 EdgeInsets.only(left: 31.h, top: 0.v, right: 39.h),
            //             scrollDirection: Axis.horizontal,
            //             separatorBuilder: (context, index) {
            //               return SizedBox(width: 56.h);
            //             },
            //             itemCount: colorList.length,
            //             itemBuilder: (context, index) {
            //               return SubjectslistItemWidget(
            //                 color: colorList[index].color,
            //                 text: colorList[index].text,
            //                 secondColor: colorList[index].secondColor,
            //                 secondText: colorList[index].secondText,
            //               );
            //             }))),
            // // SizedBox(height: 10.h ,),
            // Align(
            //     alignment: Alignment.center,
            //     child: Container(
            //         // color: Colors.red,
            //         height: 40.v,
            //         child: ListView.separated(
            //             padding:
            //                 EdgeInsets.only(left: 31.h, top: 0.v, right: 39.h),
            //             scrollDirection: Axis.horizontal,
            //             separatorBuilder: (context, index) {
            //               return SizedBox(width: 56.h);
            //             },
            //             itemCount: colorListSecond.length,
            //             itemBuilder: (context, index) {
            //               return SubjectslistItemWidget(
            //                 color: colorListSecond[index].color,
            //                 text: colorListSecond[index].text,
            //                 secondColor: colorListSecond[index].secondColor,
            //                 secondText: colorListSecond[index].secondText,
            //               );
            //             }))),
            SizedBox(height: 12.v),

            // Obx(() {
            //   final subjectResults =
            //       controller.examResultModelObj.value.subjectResults.value;
            //
            //   if (subjectResults.isEmpty) {
            //     return Center(child: CircularProgressIndicator());
            //   }
            //
            //   final chartData = subjectResults.asMap().entries.map((entry) {
            //     final index = entry.key;
            //     final item = entry.value;
            //     final color = colors[index % colors.length];
            //
            //     return ChartData(
            //       item.courseName.length > 10
            //           ? '${item.courseName.substring(0, 4)}...'
            //           : item.courseName,
            //       item.courseName,
            //       item.overallPercentage ?? 0,
            //       color,
            //     );
            //   }).toList();
            //
            //   return Column(
            //     children: [
            //       InsulinChart(data: chartData),
            //       SizedBox(height: 25.h),
            //       _buildDynamicLegend(chartData),
            //     ],
            //   );
            // }),
            // Obx(() {
            //   final endResult =
            //       controller.examResultModelObj.value.endOfTermResult.value;
            //
            //   if (endResult == null) {
            //     return Center(child: Text("No end-of-term results available."));
            //   }
            //
            //   return Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text("End of Term", style: CustomTextStyles.titleLarge22),
            //       SizedBox(height: 12.v),
            //       EndOfTermCombinedProgressbarWidget(
            //         overallT1: endResult.overallT1,
            //         overallT2: endResult.overallT2,
            //         endOfTerm: endResult.endOfTerm,
            //       ),
            //       SizedBox(height: 24.v),
            //     ],
            //   );
            // })

            // Obx(() {
            //   final endResult =
            //       controller.examResultModelObj.value.endOfTermResult.value;
            //
            //   if (endResult == null) {
            //     return Center(child: CircularProgressIndicator()); // No chart if no data
            //   }
            //
            //   final chartData = [
            //     ChartData("Term 1", "Term 1", endResult.overallT1.toDouble(),
            //         colors[0]),
            //     ChartData("Term 2", "Term 2", endResult.overallT2.toDouble(),
            //         colors[1]),
            //     ChartData("Final", "End of Term",
            //         endResult.endOfTerm.toDouble(), colors[2]),
            //   ];
            //
            //   return Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text("End of Term",
            //           style: CustomTextStyles.titleLarge22),
            //       SizedBox(height: 12.v),
            //       InsulinChart(data: chartData),
            //       SizedBox(height: 25.h),
            //       _buildDynamicLegend(chartData),
            //     ],
            //   );
            // })
          ]),
        ),
      ],
    );
  }

  /// Navigates to the firstTermExamScreen when the action is triggered.

  /// When the action is triggered, this function uses the [Get] package to
  /// push the named route for the firstTermExamScreen.
  void onTapExamprogressbar(int termId) {
    final studentId = Get.find<StudentController>().student['StudentID'];

    Get.toNamed(AppRoutes.firstTermExamScreen, arguments: {
      'termId': termId,
      'studentId': studentId,
      'sessionId': selectedSessionId
    });
  }
}
