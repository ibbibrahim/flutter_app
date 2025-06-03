import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../utils/custom_text_style.dart';
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

  @override
  void initState() {
    super.initState();
    controller.fetchFormativeData(
        studentId: 4837, termId: 17); // <- use real IDs

    controller.fetchTermWiseResults(studentId: 4837);
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
            Obx(() {
              final chartData = controller
                  .examResultModelObj.value.formativeResults.value
                  .asMap()
                  .entries
                  .map((entry) {
                final index = entry.key;
                final item = entry.value;
                final color =
                    colors[index % colors.length]; // loop through colors safely
                return ChartData(
                  item.courseName.length > 10
                      ? '${item.courseName.substring(0, 4)}...'
                      : item.courseName,
                  item.courseName,
                  item.fPercentage,
                  color,
                );
              }).toList();

              if (chartData.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  InsulinChart(data: chartData),
                  SizedBox(height: 25.h),
                  _buildDynamicLegend(chartData),
                ],
              );
            }),

            SizedBox(
              height: 25.h,
            ),
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
            SizedBox(height: 33.v),
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
                      onTapExamprogressbar();
                    },
                  );
                },
              ).marginOnly(bottom: 24.h);
            }),
          ]),
        ),
      ],
    );
  }

  /// Navigates to the firstTermExamScreen when the action is triggered.

  /// When the action is triggered, this function uses the [Get] package to
  /// push the named route for the firstTermExamScreen.
  onTapExamprogressbar() {
    Get.toNamed(
      AppRoutes.firstTermExamScreen,
    );
  }

  Widget _buildDynamicLegend(List<ChartData> chartData) {
    // Split chartData into chunks of 2
    List<List<ChartData>> rows = [];
    for (int i = 0; i < chartData.length; i += 2) {
      rows.add(chartData.sublist(
        i,
        i + 2 > chartData.length ? chartData.length : i + 2,
      ));
    }

    return Column(
      children: [
        for (var row in rows) ...[
          _buildLegendRow(row),
          SizedBox(height: 10.v),
        ]
      ],
    );
  }

  Widget _buildLegendRow(List<ChartData> rowData) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 40.v,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: 31.h, right: 39.h),
          itemCount: rowData.length,
          separatorBuilder: (context, index) => SizedBox(width: 56.h),
          itemBuilder: (context, index) {
            return SubjectslistItemWidget(
              color: rowData[index].color,
              text: rowData[index].fullLabel,
            );
          },
        ),
      ),
    );
  }
}
