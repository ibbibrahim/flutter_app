class EndOfTermResult {
  final int academicSession;
  final int sectionID;
  final int studentID;
  final int overallT1;
  final int overallT2;
  final int endOfTerm;

  EndOfTermResult({
    required this.academicSession,
    required this.sectionID,
    required this.studentID,
    required this.overallT1,
    required this.overallT2,
    required this.endOfTerm,
  });

  factory EndOfTermResult.fromJson(Map<String, dynamic> json) {
    return EndOfTermResult(
      academicSession: json['AcademicSession'] ?? 0,
      sectionID: json['SectionID'] ?? 0,
      studentID: json['StudentID'] ?? 0,
      overallT1: json['OverallPercentageT1'] ?? 0,
      overallT2: json['OverallPercentageT2'] ?? 0,
      endOfTerm: json['EndOfTerm'] ?? 0,
    );
  }
}
