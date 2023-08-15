import 'package:flutter/material.dart';
import 'package:questionmakerteacher/models/patient.dart';

final PATIENTLISTDATA1 = [
  Patient(lastName: "Smith", firstName: "Joe", patientCode: "ABCDE",
      parentQuestions: [], teacherQuestions: [], teacherCanViewParentAnswers: false),
  Patient(lastName: "Johnson", firstName: "Sally", patientCode: "12345",
      parentQuestions: [], teacherQuestions: [], teacherCanViewParentAnswers: true),
  Patient(lastName: "Jackson", firstName: "Jack", patientCode: "qwerty",
      parentQuestions: [], teacherQuestions: [], teacherCanViewParentAnswers: false),
  Patient(lastName: "Erikson", firstName: "Erik", patientCode: "dagdg",
      parentQuestions: [], teacherQuestions: [], teacherCanViewParentAnswers: true),
  Patient(lastName: "Smith", firstName: "James", patientCode: "dfgdafgdg",
      parentQuestions: [], teacherQuestions: [], teacherCanViewParentAnswers: false)
];