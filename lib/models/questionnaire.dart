import 'package:flutter/material.dart';

enum TimeOfInteraction {
  morning,
  afternoon,
  evening
}

enum Answers {
  notAtAll,
  sometimes,
  alot,
  always
}

class Questionnaire {
  Questionnaire({
    required this.lastName, required this.firstName,
    required this.timeOfDay
  });

  final String lastName, firstName;
  TimeOfDay timeOfDay;
  Map<String, Answers> answers = {};

}