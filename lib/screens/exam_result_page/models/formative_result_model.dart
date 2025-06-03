class FormativeResult {
  final String courseName;
  final double fPercentage;

  FormativeResult({required this.courseName, required this.fPercentage});

  factory FormativeResult.fromJson(Map<String, dynamic> json) {
    return FormativeResult(
      courseName: json['CourseReportCardName'] ?? '',
      fPercentage: (json['FPercentage'] ?? 0).toDouble(),
    );
  }
}
