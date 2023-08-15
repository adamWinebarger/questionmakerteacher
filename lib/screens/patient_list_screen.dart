import 'package:flutter/material.dart';
import 'package:questionmakerteacher/data/patient_list_data.dart';
import 'package:questionmakerteacher/screens/patient_view.dart';

import '../models/patient.dart';
import '../widgets/test_widgets.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PatientListScreenState();
  }

}

class _PatientListScreenState extends State<PatientListScreen> {

  bool _isLoading = false;
  List<Patient> _patientList = PATIENTLISTDATA1;

  void _logoutButtonPressed() {
    Navigator.pop(context);
  }

  void _go2PatientView(Patient patient) {

    //This is where we will go to the patient menu.
    //Going to the menu, we will need our Patient class, and possibly the user info
    print(patient.lastName);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PatientView(currentPatient: patient))
    );

  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text("You have no patients to view"),);

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator(),);
    }

    if (_patientList.isNotEmpty) {
      content = ListView.builder(
        itemCount: _patientList.length,
        itemBuilder: (context, index) => Dismissible(
          key: ValueKey("${_patientList[index].lastName}, ${_patientList[index].firstName} (${_patientList[index].patientCode})"),
          child: ListTile(
            title: Text("${_patientList[index].lastName}, ${_patientList[index].firstName} (${_patientList[index].patientCode})"),
            onTap: () {
              _go2PatientView(_patientList[index]);
            },
          )
      )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient View"),
        leading: IconButton( //this can be our logout button, I guess
          onPressed: _logoutButtonPressed,
          icon: const Icon(Icons.logout),
        ),
      ),
      body: content
    );
  }

}