import 'package:flutter/material.dart';
import 'package:login_portal/utils/size_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';



class InsulinChart extends StatefulWidget {
  final String? date;

  InsulinChart({Key? key, this.date})
      : super(
    key: key,
  );

  @override
  State<InsulinChart> createState() => _InsulinChartState();
}

class _InsulinChartState extends State<InsulinChart> {
  late List<ChartData> data;
  late TooltipBehavior tooltip;

  @override
  void initState() {
    // TODO: implement initState
    data = [
      ChartData('Sci', 73, Color(0xFFF94144)),
      ChartData('Maths', 98, Color(0xFFF3722C)),
      ChartData('S.S', 173, Color(0xFFF8961E)),
      ChartData('English', 74, Color(0xFFF9C74F)),
      ChartData('Gujrati', 124, Color(0xFF90BE6D)),
      ChartData('Hindi', 149, Color(0xFF2D9CDB)),
      // ChartData('Su', 58),
    ];
    tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: EdgeInsets.only(left: 20),
        //   child: Text(
        //     widget.date ?? '11-8',
        //     style: TextStyle(
        //       color: Color(0xFF7C7C7C),
        //       fontSize: 18.fSize,
        //       fontWeight: FontWeight.w400,
        //     ),
        //   ),
        // ),
        // Padding(
        //   padding: EdgeInsets.only(left: 20),
        //   child: Text(
        //     'Insulin',
        //     style: TextStyle(
        //       color: appTheme.blueGray900,
        //       fontSize: 22.fSize,
        //       fontWeight: FontWeight.w700,
        //     ),
        //   ),
        // ),
        // Padding(
        //   padding: EdgeInsets.only(left: 26.34, right: 25.26, top: 10, bottom: 20),
        //   child: Divider(
        //     thickness: 1.5,
        //     color: Color(0xFFE7E7E7),
        //   ),
        // ),

        //       Container(
        //           child: SfCartesianChart(
        //               primaryXAxis: CategoryAxis(),
        //               series: <ChartSeries>[
        // //                 StackedColumnSeries<ChartData, String>(
        // //                     groupName: 'Group A',
        // //                     dataLabelSettings: DataLabelSettings(
        // //                         isVisible:true,
        // //                         showCumulativeValues: true
        // //                     ),
        // //                     dataSource: data,
        // //                     xValueMapper: (ChartData data, _) => data.category,
        // //                     yValueMapper: (ChartData data, _) => data.value
        // // ,
        // //                 ),
        // //                 valueStackedColumnSeries<ChartData, String>(
        // //                     groupName: 'Group B',
        // //                     dataLabelSettings: DataLabelSettings(
        // //                         isVisible:true,
        // //                         showCumulativeValues: true
        // //                     ),
        // //                     dataSource: data,
        // //                     xValueMapper: (ChartData data, _) =>data.category,
        // //                     yValueMapper: (ChartData data, _) =>data.value
        // // ,
        // //                 ),
        // //                 StackedColumnSeries<ChartData, String>(
        // //                     groupName: 'Group A',
        // //                     dataLabelSettings: DataLabelSettings(
        // //                         isVisible:true,
        // //                         showCumulativeValues: true
        // //                     ),
        // //                     dataSource: data,
        // //                     xValueMapper: (ChartData data, _) => data.category,
        // //                     yValueMapper: (ChartData data, _) => data.value
        // //
        // //                 ),
        //                 StackedColumnSeries<ChartData, String>(
        //                     groupName: 'Group B',
        //                     dataLabelSettings: DataLabelSettings(
        //                         isVisible:true,
        //                         showCumulativeValues: true
        //                     ),
        //                     dataSource: data,
        //                     xValueMapper: (ChartData data, _) => data.category,
        //                     yValueMapper: (ChartData data, _) => data.value
        //                 )
        //               ]
        //           )
        //       )

        SfCartesianChart(
          backgroundColor: Colors.transparent,
          borderColor: Colors.transparent,
          borderWidth: 0,
          plotAreaBorderWidth: 0,
          primaryXAxis: CategoryAxis(
            majorGridLines: MajorGridLines(
                width: 1, color: Color(0xFFBDBDBD), dashArray: [3]),
            // interval: 20, // minimummum: 50,
          ),
          // isTransposed: true,
          // enableAxisAnimation: true,

          legend: Legend(
            isVisible: false,
            position: LegendPosition.bottom,
          ),
          primaryYAxis: NumericAxis(
            desiredIntervals: 2,
            majorGridLines: MajorGridLines(
              dashArray: [3],
              color: Color(0xFFBDBDBD),
            ),
            axisLine: AxisLine(width: 0, dashArray: [3]),
            labelFormat: '{value}',
            interval: 20,
          ),
          // isTransposed: true,
          // enableAxisAnimation: true,
          trackballBehavior: TrackballBehavior(
              shouldAlwaysShow: true,
              lineColor: Color(0xFF7C7C7C),
              enable: true,
              lineWidth: 20.h,
              hideDelay: 39,
              // Enable trackball
              activationMode: ActivationMode.singleTap,
              lineType: TrackballLineType.none,
              tooltipSettings: InteractiveTooltip(
                // connectorLineColor: data.last.,
                  enable: true,
                  canShowMarker: false,
                  // borderColor: Colors.red,
                  borderRadius: 8.h,
                  format: 'point.y',
                  color: Colors.black87,
                  arrowWidth: 23,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16.fSize,
                    fontWeight: FontWeight.w400,
                  )),
              markerSettings: TrackballMarkerSettings(
                height: 15,
              )),
          selectionType: SelectionType.cluster,
          series: <CartesianSeries>[

            ColumnSeries<ChartData, String>(
              width: 0.40,
              dataSource: data,
              animationDuration: 1000,
              // dashArray: [7],
              // dataLabelSettings: DataLabelSettings(
              //
              //   useSeriesColor: true,
              //   isVisible: false
              // ),
              pointColorMapper: (ChartData data, _) => data.color,
              xValueMapper: (ChartData data, _) => data.category,
              yValueMapper: (ChartData data, _) => data.value,

              // isVisibleInLegend: true,
              // dataLabelMapper: (datum, index) => data[index].category,

              // legendItemText: data[2].category,
              // legendIconType: LegendIconType.circle,
              // spacing: 10.h,
              // borderRadius: BorderRadius.circular(4.h),
              dataLabelSettings: DataLabelSettings(),
              // name: "sadfj"
              // name:  "sydghrydesg"

              // sortFieldValueMapper: (datum, index) => data[index].category.toString(),
              // dataLabelMapper: (datum, index) => data[index].category.toString(),

              // serieselectionBehavior: SelectionBehavior(
              //   selectedColor: Color(0xFF694ACD),
              //   nable: truee,
              //   unselectedColor: Color(0x1A694ACD),
              // ),
              // 0x1A694ACDborderRadius: BorderRadius.only(
              //     topRight: Radius.circular((7)),
              //     topLeft: Radius.circular((7))),
              // color: Color(0x26694ACD),
            ),
          ],
        ),
      ],
    );
  }
}

class ChartData {
  final String category;
  final double value;
  final Color color;
  bool isSelected;

  ChartData(this.category, this.value, this.color, {this.isSelected = false});
}
