import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:questionmakerteacher/data/patient_list_data.dart';
import 'package:questionmakerteacher/models/answerer.dart';
import 'package:questionmakerteacher/screens/add_patient_screen.dart';
import 'package:questionmakerteacher/screens/patient_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../models/patient.dart';

final _authenticatedUser = FirebaseAuth.instance.currentUser!;

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return _PatientListScreenState();
  }

}

class _PatientListScreenState extends State<PatientListScreen> {

  bool _isFetchingData = true;
  List<String> _patientList = [], _viewableChildren = [], _viewableStudents = [];
  final _formKey = GlobalKey<FormState>();
  final CollectionReference _crList = FirebaseFirestore.instance.collection("Patients");
  final DocumentReference _currentUserDoc = FirebaseFirestore.instance.collection("users").
      doc(_authenticatedUser.uid);
  //QueryDocumentSnapshot<Object?>? _foundChild;

  final _noPatientsWidget = const Center(child: Text("You have no patients to view"));

  void _logoutButtonPressed() {
    FirebaseAuth.instance.signOut();
  }

  Future<List<String>> _getApprovedPatients() async {
    final currentUserDoc = await _currentUserDoc.get();
    final currentUserData = currentUserDoc.data() as Map<String, dynamic>;
    var viewableStudents = (currentUserData.containsKey('viewableStudents')) ?
      (currentUserData['viewableStudents'] as List?)?.map((item) => item as String).toList()
          ?? [] : [];
    //print(viewableStudents);
    var viewableChildren = currentUserData.containsKey('viewableChildren') ?
      (currentUserData['viewableChildren'] as List?)?.map((item) => item as String).toList()
        ?? [] : [];
    //List<String> patientList = (map2List != null && map2List.isNotEmpty) ? map2List : [];
    _viewableStudents = (viewableStudents.isNotEmpty) ? viewableStudents as List<String> : [];
    _viewableChildren = (viewableChildren.isNotEmpty) ? viewableChildren as List<String> : [];
    return [...viewableChildren, ...viewableStudents];
  }

  void _go2PatientView2(QueryDocumentSnapshot selectedPatient) {
    Patient patient = Patient.fromJson(selectedPatient.data() as Map<String, dynamic>);
    print(selectedPatient.id);
    patient.path = selectedPatient.id;
    ParentOrTeacher parentOrTeacher = (_viewableStudents.contains(selectedPatient.id))
        ? ParentOrTeacher.teacher : ParentOrTeacher.parent;
    //print(patient.path);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PatientView(currentPatient: patient, parentOrTeacher: parentOrTeacher))
    );
  }

  void _go2AddPatientScreen() async {
    await Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => AddPatientScreen(currentUser: _currentUserDoc))
    );

    setState(() {
      _getApprovedPatients().then((value) {
        setState(() {
          _patientList = value;
          _isFetchingData = false;
        });
      });
    });
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
    _getApprovedPatients().then((value) {
      setState(() {
        _patientList = value;
        _isFetchingData = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    //print("build $_patientList");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Select"),
        leading: IconButton( //this can be our logout button, I guess
          onPressed: _logoutButtonPressed,
          icon: const Icon(Icons.logout),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            //Add button
            child: GestureDetector(
              onTap: _go2AddPatientScreen,
              child: const Icon(
                Icons.add,
                size: 25.0,
              ),
            ),
          )
        ],
      ),
      body: (_patientList.isNotEmpty && !_isFetchingData) ? Column(
        children: [
          const SizedBox(height: 5,),
          Expanded(child:
            StreamBuilder(
              stream: _crList.where(FieldPath.documentId, whereIn: _patientList).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  // if (snapshot.data!.docs.length == 1) {
                  //   _go2PatientView2(snapshot.data!.docs[0]);
                  // }
                  if (snapshot.data!.docs.isEmpty) {
                    return _noPatientsWidget;
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            snapshot.data!.docs[index].id,
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis),
                          ),
                          onTap: () {
                            //print(snapshot.data!.docs[index].data());
                            _go2PatientView2(snapshot.data!.docs[index]);
                          },
                        );
                      },
                    );
                  }
                } else if (snapshot.hasError) {
                  return Column(
                    children: [
                      Center(child: Text(snapshot.error!.toString()),),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {

                          });
                        },
                        child: const Text("press")
                      )
                    ],
                  );
                } else {
                  return _noPatientsWidget;
                }
              },
            )
          )
        ],
      ) : _noPatientsWidget
    );
  }
}