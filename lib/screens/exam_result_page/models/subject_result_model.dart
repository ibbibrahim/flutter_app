class SubjectResult {
  final String courseName;

  final double fMarks;
  final double fPercentage;
  final String fGrade;
  final String fAttainmentLevel;

  final double? sMarks;
  final double? sPercentage;
  final String? sGrade;
  final String? sAttainmentLevel;

  final double? overallMarks;
  final double? overallPercentage;
  final String? overallGrade;
  final String? oAttainmentLevel;

  SubjectResult({
    required this.courseName,
    required this.fMarks,
    required this.fPercentage,
    required this.fGrade,
    required this.fAttainmentLevel,
    this.sMarks,
    this.sPercentage,
    this.sGrade,
    this.sAttainmentLevel,
    this.overallMarks,
    this.overallPercentage,
    this.overallGrade,
    this.oAttainmentLevel,
  });

  factory SubjectResult.fromJson(Map<String, dynamic> json) {
    return SubjectResult(
      courseName: json['CourseReportCardName'] ?? '',

      fMarks: (json['FMarks'] ?? 0).toDouble(),
      fPercentage: (json['FPercentage'] ?? 0).toDouble(),
      fGrade: json['FGrade'] ?? '',
      fAttainmentLevel: json['FAttainmentLevel'] ?? '',

      sMarks: json['SMarks'] != null ? (json['SMarks'] as num?)?.toDouble() : null,
      sPercentage: json['SPercentage'] != null ? (json['SPercentage'] as num?)?.toDouble() : null,
      sGrade: json['SGrade'],
      sAttainmentLevel: json['SAttainmentLevel'],

      overallMarks: json['OverallMarks'] != null ? (json['OverallMarks'] as num?)?.toDouble() : null,
      overallPercentage: json['OverallPercentage'] != null ? (json['OverallPercentage'] as num?)?.toDouble() : null,
      overallGrade: json['OverallGrade'],
      oAttainmentLevel: json['OAttainmentLevel'],
    );
  }
}
