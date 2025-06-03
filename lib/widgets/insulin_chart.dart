import 'package:flutter/material.dart';
import 'package:login_portal/utils/size_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';



class InsulinChart extends StatefulWidget {
  final List<ChartData> data; // ✅ NEW
  final String? date;

  InsulinChart({required this.data, this.date, Key? key}) : super(key: key);


  @override
  State<InsulinChart> createState() => _InsulinChartState();
}

class _InsulinChartState extends State<InsulinChart> {
  // late List<ChartData> data;
  late TooltipBehavior tooltip;

  @override
  void initState() {
    // TODO: implement initState
    // data = [
    //   ChartData('Sci', 73, Color(0xFFF94144)),
    //   ChartData('Maths', 98, Color(0xFFF3722C)),
    //   ChartData('S.S', 173, Color(0xFFF8961E)),
    //   ChartData('English', 74, Color(0xFFF9C74F)),
    //   ChartData('Gujrati', 124, Color(0xFF90BE6D)),
    //   ChartData('Hindi', 149, Color(0xFF2D9CDB)),
    // ];
    tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SfCartesianChart(
          backgroundColor: Colors.transparent,
          borderColor: Colors.transparent,
          borderWidth: 0,
          plotAreaBorderWidth: 0,
          primaryXAxis: CategoryAxis(
            labelRotation: 45,              // ✅ Make text readable
            labelStyle: TextStyle(fontSize: 9), // ✅ Slightly smaller
            majorGridLines: MajorGridLines(
              width: 1, color: Color(0xFFBDBDBD), dashArray: [3],
            ),
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
                  format: 'point.x : point.y',
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
              dataSource: widget.data,
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
  final String category;    // Truncated label
  final String fullLabel;   // Full course name
  final double value;
  final Color color;
  bool isSelected;

  ChartData(this.category, this.fullLabel, this.value, this.color, {this.isSelected = false});
}
