
/// This class is used in the [examdetails_item_widget] screen.

class ExamdetailsItemModel {
  ExamdetailsItemModel({
    required this.time,
    required this.passMarks,
    required this.totalMarks,
    required this.subject,
    required this.date,
  });

  final String subject;
  final String totalMarks;
  final String passMarks;
  final String time;
  final String date;
}

List<ExamdetailsItemModel> examlListData = [
  ExamdetailsItemModel(
      time: "09 am-12 am",
      passMarks: "Pass Marks : 25",
      totalMarks: "Total Marks : 75",
      subject: "Science Chapter 1 & 2 ",
      date: '8 Sep, 2023',
  ),
  ExamdetailsItemModel(
    time: "10 am-01 pm",
    passMarks: "Pass Marks : 40",
    totalMarks: "Total Marks : 100",
    subject: "Maths Chapter 4 ",
    date: '12 Sep, 2023',
  ),
  ExamdetailsItemModel(
    time: "01 pm-03 pm",
    passMarks: "Pass Marks : 25",
    totalMarks: "Total Marks : 75",
    subject: "Social Science Chapter 6 , 7 , 8",
    date: '28 Sep, 2023',
  ),
  ExamdetailsItemModel(
    time: "09 am-12 am",
    passMarks: "Pass Marks : 25",
    totalMarks: "Total Marks : 75",
    subject: "English Chapter 1 & 2",
    date: '01 Oct, 2023',
  ),
  ExamdetailsItemModel(
    time: "09 am-12 am",
    passMarks: "Pass Marks : 25",
    totalMarks: "Total Marks : 75",
    subject: "Science Chapter 1 & 2 ",
    date: '8 Sep, 2023',
  ),
];
