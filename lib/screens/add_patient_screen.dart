import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key, required this.authenticatedUser});

  final User authenticatedUser;

  @override
  State<StatefulWidget> createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatientScreen> {

  final _formKey = GlobalKey<FormState>();
  String _enteredLastName = "", _enteredPatientCode = "";

  void _addPatientPressed() {

  }

  @override
  Widget build(context) {
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
                ),
                const SizedBox(height: 50,),
                ElevatedButton(
                  onPressed: _addPatientPressed,
                  child: const Text("Add Patient")
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}