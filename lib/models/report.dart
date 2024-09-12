import 'package:questionmakerteacher/models/questionnaire.dart';
import 'answerer.dart';

class Report {
  Report({
    required this.answers,
    required this.timestamp,
    required this.lastName,
    required this.firstName,
    required this.timeOfDay,
    required this.parentOrTeacher
  });

  final Map<String, Answers> answers;
  final DateTime timestamp;
  final String lastName, firstName, timeOfDay;
  final ParentOrTeacher parentOrTeacher;

  factory Report.fromJSON(Map<String, dynamic> json) =>
      Report(
          firstName: json['answererFirstName'],
          lastName: json['answererLastName'],
          timestamp: json['Timestamp'] as DateTime,
          timeOfDay: json['timeOfDay'],
          parentOrTeacher: json['parentOrTeacher'].values.firstWhere((element) =>
          element.name == json['parentOrTeacher']),
          answers: (json['answers'] as Map<String, Answers>).map((key, value) =>
              MapEntry(key, value))
      );
}