import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:questionmakerteacher/main.dart';
import 'package:questionmakerteacher/models/answerer.dart';

import 'package:questionmakerteacher/models/patient.dart';

final _authenticatedUser = FirebaseAuth.instance.currentUser!;

class PatientReportsListScreen extends StatefulWidget {
  const PatientReportsListScreen({super.key, required this.currentPatientString,
    required this.parentOrTeacher, required this.teacherCanViewParentReports});

  final String currentPatientString;
  final ParentOrTeacher parentOrTeacher;
  final bool teacherCanViewParentReports;

  @override
  State<StatefulWidget> createState() => _PatientReportsListScreenState();
}

class _PatientReportsListScreenState extends State<PatientReportsListScreen> {

  final _noAnswersWidget = const Center(child:
  Text("No data available.\n Maybe adjust your search parameters?",
    textAlign: TextAlign.center,)
  );

  bool _isFetchingData = false;
  List<String> _reportsList = [];


  Future<List<String>> _getReportListFromDatabase() async {
    List<String> reportsList = [];

    final CollectionReference crList = FirebaseFirestore.instance.collection("Patients")
        .doc(widget.currentPatientString).collection("Answers");



    return reportsList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text("View Reports"),),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 25,),
              Text("Text",
                style: TextStyle(
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        )
      ),
    );
  }
}