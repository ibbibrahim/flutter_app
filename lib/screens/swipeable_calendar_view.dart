import 'package:flutter/material.dart';
import 'attendance_calendar.dart';

class SwipeableCalendarView extends StatefulWidget {
  final List<Map<String, dynamic>> attendanceData;
  final int initialIndex;

  SwipeableCalendarView({required this.attendanceData, required this.initialIndex});

  @override
  _SwipeableCalendarViewState createState() => _SwipeableCalendarViewState();
}

class _SwipeableCalendarViewState extends State<SwipeableCalendarView> {
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.attendanceData.length,
        itemBuilder: (context, index) {
          return AttendanceCalendarScreen(monthData: widget.attendanceData[index]);
        },
      ),
    );
  }
}
