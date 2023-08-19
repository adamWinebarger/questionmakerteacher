import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:questionmakerteacher/data/patient_list_data.dart';
import 'package:questionmakerteacher/screens/patient_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../models/patient.dart';


class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PatientListScreenState();
  }

}

class _PatientListScreenState extends State<PatientListScreen> {

  bool _isLoading = false;
  List<String> _patientList = [];
  final CollectionReference _crList = FirebaseFirestore.instance.collection("Patients");
  //QueryDocumentSnapshot<Object?>? _foundChild;

  void _logoutButtonPressed() {
    FirebaseAuth.instance.signOut();
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

  void _setupPushNotifs() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    final token = await fcm.getToken();
  }

  // Stream<List<Patient>> _listStream() {
  //   try {
  //     return _crList.snapshots().map(
  //             // (notes) {
  //             //   final List<Patient> patientList = [];
  //             //   for (final DocumentSnapshot<Map<String, dynamic> doc in notes.)
  //             // }
  //     );
  //   } catch(e) {
  //     rethrow;
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _setupPushNotifs();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text("You have no patients to view"),);

    //_getListData();


    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator(),);
    }

   print(_crList.count());

    if (false) {
      content = StreamBuilder(
        stream: _crList.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!.docs;
          }
        }
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