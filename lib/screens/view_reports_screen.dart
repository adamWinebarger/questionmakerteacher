import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:questionmakerteacher/main.dart';

import 'package:questionmakerteacher/models/patient.dart';

final _authenticatedUser = FirebaseAuth.instance.currentUser!;

class PatientReportsListScreen extends StatelessWidget {
  const PatientReportsListScreen({super.key, required this.currentPatient});

  final Patient currentPatient;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text("View Patient Reports"),),
    );
  }

}
class ReportListView extends StatelessWidget {
  //final

  const ReportListView({super.key});

  @override
  Widget build(BuildContext context) {
    // return ListView.builder(
    //     //itemCount: items.length,
    //     //temBuilder: itemBuilder
    // );
    throw UnimplementedError();
  }

}