import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:questionmakerteacher/data/patient_list_data.dart';
import 'package:questionmakerteacher/screens/patient_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../models/patient.dart';

final _authenticatedUser = FirebaseAuth.instance.currentUser!;

class PatientListScreen extends StatefulWidget {
  PatientListScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PatientListScreenState();
  }

}

class _PatientListScreenState extends State<PatientListScreen> {

  bool _isLoading = false;
  List<String> _patientList = [];
  final CollectionReference _crList = FirebaseFirestore.instance.collection("Patients");
  final DocumentReference _currentUserDoc = FirebaseFirestore.instance.collection("users").
      doc(_authenticatedUser.uid);
  //QueryDocumentSnapshot<Object?>? _foundChild;


  void _logoutButtonPressed() {
    FirebaseAuth.instance.signOut();
  }

  Future<List<String>> _getApprovedPatients() async {
    final currentUserData = await _currentUserDoc.get();
    var map2List = (currentUserData['viewablePatients'] as List)?.map((item) => item as String)?.toList();
    _patientList = (map2List == null || map2List.isEmpty) ? [] : map2List;
    print(_patientList);
    return _patientList;
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

  void _go2PatientView2(QueryDocumentSnapshot selectedPatient) {
    Patient patient = Patient.fromJson(selectedPatient.data() as Map<String, dynamic>);
    patient.path = selectedPatient.id;
    //print(patient.path);
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

  @override
  void initState() {
    super.initState();
    _setupPushNotifs();
  }

  @override
  Widget build(BuildContext context) {

    var x = _getApprovedPatients();
    print(_patientList.toString() + " 2");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient View"),
        leading: IconButton( //this can be our logout button, I guess
          onPressed: _logoutButtonPressed,
          icon: const Icon(Icons.logout),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.add,
                size: 25.0,
              ),
            ),
          )
        ],
      ),
      body: (_patientList.isNotEmpty) ? Column(
        children: [
          const SizedBox(height: 5,),
          Expanded(child:
            StreamBuilder(
              stream: _crList.where('patientCode', whereIn: _patientList).orderBy("lastName").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  if (snapshot.data!.docs.length == 1) {
                    _go2PatientView2(snapshot.data!.docs[0]);
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          snapshot.data!.docs[index].id,
                          style: const TextStyle(overflow: TextOverflow.ellipsis),
                        ),
                        onTap: () {
                          print(snapshot.data!.docs[index].data());
                          _go2PatientView2(snapshot.data!.docs[index]);
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return const Text("Error");
                } else {
                  return const CircularProgressIndicator();
                }
              },
            )
          )
        ],
      ) : const Center(child: Text("You have no patients to view"))
    );
  }
}