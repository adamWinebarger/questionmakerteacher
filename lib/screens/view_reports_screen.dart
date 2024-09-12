import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:questionmakerteacher/main.dart';
import 'package:questionmakerteacher/models/answerer.dart';
import 'package:questionmakerteacher/models/report.dart';

import 'package:questionmakerteacher/models/patient.dart';
import 'package:questionmakerteacher/models/questionnaire.dart';

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
  DateTime _toDate = DateTime.now(), _fromDate = DateTime.now().subtract(const Duration(days: 7));
  //DateTime _toDate = DateTime.now(), _fromDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  String _selectedParentTeacherFilter = "All";


  Future<List<String>> _getReportListFromDatabase() async {
    List<String> reportsList = [];

    final CollectionReference crList = FirebaseFirestore.instance.collection("Patients")
      .doc(widget.currentPatientString).collection("Answers");

    /*
    * Alright. So what do we need in this case?
    * So for the title card of what's going to be in the list, we would probably want
    * The $name ($relation), $date?
    * Or something like that.
    *
    * Can any of our existing classes from the model directory be used here?
    *
    * Additionally, we need to set our from and to dates like we did in patient_dataview
    * Should we have a filter for parent and teacher as well? If so, then we'll need
    * to figure out how to "stylize" the list so that we can differentiate it from
    * the regular background.
    */

    Query reportQuery = crList.where("TimeStamp", isGreaterThanOrEqualTo: _fromDate)
      .where("TimeStamp", isLessThanOrEqualTo: _toDate);

    if (widget.parentOrTeacher == ParentOrTeacher.teacher && widget.teacherCanViewParentReports == false) {
      reportQuery = reportQuery.where("parentOrTeacher", isEqualTo: "teacher");
    } else if (_selectedParentTeacherFilter != "All") {
      reportQuery = reportQuery.where("parentOrTeacher", isEqualTo: (_selectedParentTeacherFilter == "Parent") ? "parent" : "teacher");
    }

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