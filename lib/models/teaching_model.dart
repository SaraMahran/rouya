class TeachingProgram {
  final String id;
  String name; // e.g. "Planning Engineer Bootcamp"
  String? organization;
  DateTime startDate;
  DateTime? endDate;
  int studentCount;
  List<String> topics;
  String? notes;
  String status; // 'Active', 'Completed', 'Upcoming'

  TeachingProgram({
    required this.id,
    required this.name,
    this.organization,
    required this.startDate,
    this.endDate,
    this.studentCount = 0,
    List<String>? topics,
    this.notes,
    this.status = 'Active',
  }) : topics = topics ?? [];
}

class IndividualStudent {
  final String id;
  String name;
  String? subject;
  DateTime startDate;
  List<StudentSession> sessions;
  String? notes;
  int progressRating; // 1-5

  IndividualStudent({
    required this.id,
    required this.name,
    this.subject,
    required this.startDate,
    List<StudentSession>? sessions,
    this.notes,
    this.progressRating = 3,
  }) : sessions = sessions ?? [];
}

class StudentSession {
  final String id;
  final DateTime date;
  final int durationMinutes;
  final String? topic;
  final String? notes;

  StudentSession({
    required this.id,
    required this.date,
    required this.durationMinutes,
    this.topic,
    this.notes,
  });
}