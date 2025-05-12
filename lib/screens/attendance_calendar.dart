import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:intl/intl.dart';

class AttendanceCalendarScreen extends StatelessWidget {
  final Map<String, dynamic> monthData;

  AttendanceCalendarScreen({required this.monthData});

  late final EventList<Event> markedDateMap = _buildMarkedDateMap();

  EventList<Event> _buildMarkedDateMap() {
    final marked = EventList<Event>(events: {});
    final records = List<Map<String, dynamic>>.from(monthData['daily_records']);

    for (var record in records) {
      final DateTime date = DateFormat('dd-MM-yyyy').parse(record['date']);
      final String status = record['status'] ?? '';

      Color color = Colors.grey.withOpacity(0.4);

      if (status.contains('Present')) {
        color = Colors.green.withOpacity(0.5);
      } else if (status.contains('Absent')) {
        color = Colors.red.withOpacity(0.5);
      } else if (status == 'Late Arrival') {
        color = Colors.orange.withOpacity(0.5);
      } else if (status == 'Early Exit') {
        color = Colors.purple.withOpacity(0.5);
      } else if (status == 'Sick Leave') {
        color = Colors.blue.withOpacity(0.5);
      } else if (status == 'Emergency Leave') {
        color = Colors.brown.withOpacity(0.5);
      } else if (status == 'Exam Preparation Leave') {
        color = Colors.teal.withOpacity(0.5);
      } else if (status == 'Approved Leave') {
        color = Colors.indigo.withOpacity(0.5);
      }

      final isFriday = DateFormat('EEEE').format(date) == 'Friday';

      marked.add(
        date,
        Event(
          date: date,
          title: status,
          dot: Container(
            alignment: Alignment.center,
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(isFriday ? '' : date.day.toString()),
          ),
        ),
      );
    }

    return marked;
  }


  @override
  Widget build(BuildContext context) {
    final String month = monthData['month'];
    final int present = monthData['present_count'];
    final int absent = monthData['absent_count'];
    final int lateArrival = monthData['late_arrival_count'];
    final int earlyExit = monthData['early_exit_count'];
    final int sickLeave = monthData['sick_leave_count'];
    final int emergencyLeave = monthData['emergency_leave_count'];
    final int examPrep = monthData['exam_prep_leave_count'];
    final int approvedLeave = monthData['approved_leave_count'];
    final DateTime firstDate = DateFormat('dd-MM-yyyy').parse(monthData['daily_records'][0]['date']);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 135,
            padding: EdgeInsets.only(top: 50, left: 16),
            alignment: Alignment.centerLeft,
            color: Colors.blueAccent,
            child: Row(
              children: [
                BackButton(color: Colors.white),
                SizedBox(width: 8),
                Text("Attendance", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              month,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CalendarCarousel<Event>(
              height: 350,
              targetDateTime: firstDate,
              markedDatesMap: markedDateMap,
              markedDateIconBuilder: (event) => event.dot,
              showHeader: false,
              todayButtonColor: Colors.transparent,
              todayTextStyle: TextStyle(color: Colors.grey),
              weekendTextStyle: TextStyle(color: Colors.grey),
              weekdayTextStyle: TextStyle(color: Colors.grey),
              daysTextStyle: TextStyle(color: Colors.grey),
              nextDaysTextStyle: TextStyle(color: Colors.grey),
              prevDaysTextStyle: TextStyle(color: Colors.grey),
              markedDateShowIcon: true,
              markedDateMoreShowTotal: true,
              weekDayPadding: EdgeInsets.zero,
              customGridViewPhysics: NeverScrollableScrollPhysics(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildStatCard('Present', '$present', Colors.green)),
                    SizedBox(width: 10),
                    Expanded(child: _buildStatCard('Absent', '$absent', Colors.redAccent)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _buildStatCard('Late Arrival', '$lateArrival', Colors.orange)),
                    SizedBox(width: 10),
                    Expanded(child: _buildStatCard('Early Exit', '$earlyExit', Colors.purple)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _buildStatCard('Sick Leave', '$sickLeave', Colors.blue)),
                    SizedBox(width: 10),
                    Expanded(child: _buildStatCard('Emergency Leave', '$emergencyLeave', Colors.brown)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _buildStatCard('Exam Prep', '$examPrep', Colors.teal)),
                    SizedBox(width: 10),
                    Expanded(child: _buildStatCard('Approved Leave', '$approvedLeave', Colors.indigo)),
                  ],
                ),
              ],
            ),
          ),


        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
