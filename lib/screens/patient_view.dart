import 'package:flutter/material.dart';
import 'package:questionmakerteacher/models/patient.dart';
import 'package:questionmakerteacher/widgets/test_widgets.dart';

class PatientView extends StatefulWidget {
  const PatientView({super.key, required this.currentPatient});

  final Patient currentPatient;

  @override
  State<StatefulWidget> createState() {
    return _PatientViewState();
  }

}

class _PatientViewState extends State<PatientView> {


  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: Text("Current Patient"),),
      body: const BasicScreenTestWidget(),
    );
  }

}