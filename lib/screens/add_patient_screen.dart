import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key, required this.currentUser});

  final DocumentReference currentUser;

  @override
  State<StatefulWidget> createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatientScreen> {

  final _formKey = GlobalKey<FormState>();
  String _enteredLastName = "", _enteredPatientCode = "";
  bool _isChecking4PatientData = false;
  final CollectionReference _crList = FirebaseFirestore.instance.collection("Patients");
  List<String> _patientList = [];

  Future<String?> _patientAdded2List() async {
    String? errorMessage;
    QueryDocumentSnapshot<Object?>? foundPatient;

    await _crList.where('lastName', isEqualTo: _enteredLastName)
        .where('patientCode', isEqualTo: _enteredPatientCode).get().then(
            (value) {
              //this basically checks to see if there's any data that matches the query, then, if so,
              // follows different paths based on how much data is returned.
              if (value.docs.isEmpty) {
                errorMessage = "No patient found with these credentials";
              } else if (value.docs.length > 1) {
                errorMessage =
                "Somehow, multiple patients were returned meeting this criteria. This means something is very wrong here. Please try again later";
              } else {
                foundPatient = value.docs[0];
              }
            });
    //there should be no instance where the error message and the found patient are both null
    //so we'll add a new patient to the array when the error message is null
    if (errorMessage == null) {
      await widget.currentUser.update({
        'viewableStudents' : FieldValue.arrayUnion([foundPatient!.id])
      });
    }
    return errorMessage;
  }

  //remember that we ripped this from patient_list_screen. If we use it much more, then
  // we may want to consider making this a public method somewhere easily accessible with any class that may need
  //it. Would probably need an input parameter if we did that... also not sure if we would need another folder
  // for that... something to think about
  Future<List<String>> _getPatientList() async {
    final currentUserData = await widget.currentUser.get();
    var map2List = (currentUserData['viewableStudents'] as List)?.map((e) => e as String)?.toList();
    List<String> patientList = (map2List != null && map2List.isNotEmpty) ? map2List : [];
    return patientList;
  }


  void _addPatientPressed() async {
    setState(() {
      _isChecking4PatientData = true;
    });

    final allInputsValid = _formKey.currentState!.validate();

    if (allInputsValid) {
      _formKey.currentState!.save();
      String? errorMessage = await _patientAdded2List();
      if (errorMessage == null) {
        //This might not be the best practice but it works for now, I guess
        setState(() {
          Navigator.pop(context);
        });
      }
    }

    setState(() {
      _isChecking4PatientData = false;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPatientList().then((value) {
      setState(() {
        _patientList = value;
      });
    });
  }

  @override
  Widget build(context) {
    //print(_patientList);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Patient"),
      ),
      body: Padding(
        padding: EdgeInsets.all(25),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "Last Name:"),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.trim().length < 2
                        || value.trim().length > 50) {
                      return 'Input value must be between 2 and 50 characters long';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredLastName = value!;
                  },
                ),
                const SizedBox(height: 50,),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Patient Code:"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty || value.trim().length != 40) {
                      return "Invalid Patient Code Detected";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredPatientCode = value!;
                  },
                ),
                const SizedBox(height: 50,),
                ElevatedButton(
                  onPressed: _addPatientPressed,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120, 40)
                  ),
                  child: (_isChecking4PatientData) ? const SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(),
                  ) : const Text("Add Patient")
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}