class InterviewModel {
  int technical;
  int hr;
  int streak;
  List<InterviewRecord> history;
  List<int> chart;

  InterviewModel({
    this.technical = 0,
    this.hr = 0,
    this.streak = 0,
    List<InterviewRecord>? history,
    List<int>? chart,
  })  : history = history ?? [],
        chart = chart ?? List.filled(14, 0);
}

// Rich interview record — replaces the old InterviewEntry
class InterviewRecord {
  final String id;
  final String company;
  final String role;
  final String type; // 'Technical', 'HR', 'Culture'
  final DateTime date;
  final String? meetingTime; // e.g. "10:30 AM"
  final String? purpose; // why this interview was conducted
  final String? notes;
  final String? candidateFeedback;
  final String outcome; // 'Pending', 'Advanced', 'Passed', 'Failed', 'Rejected'
  final DateTime? followUpDate;
  final int? rating; // 1-5 self assessment
  final List<String> imagePaths; // local image paths
  final double? surveyRating; // from Supabase — average candidate rating
  final int? surveyRespondents; // how many candidates responded

  InterviewRecord({
    required this.id,
    required this.company,
    required this.role,
    required this.type,
    required this.date,
    this.meetingTime,
    this.purpose,
    this.notes,
    this.candidateFeedback,
    this.outcome = 'Pending',
    this.followUpDate,
    this.rating,
    this.imagePaths = const [],
    this.surveyRating,
    this.surveyRespondents,
  });

  // Display label for type
  String get typeLabel => type;

  // Display label for outcome with color hint
  String get outcomeLabel => outcome;
}