import 'package:flutter/material.dart';
import 'package:questionmakerteacher/widgets/test_widgets.dart';

class PatientDataView extends StatefulWidget {
  const PatientDataView({super.key});

  @override
  State<StatefulWidget> createState() => _PatientDataViewState();

}

class _PatientDataViewState extends State<PatientDataView> {
  @override
  Widget build(context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text("View Patient Data"),),
      body: BasicScreenTestWidget()
    );
  }

}