import 'package:flutter/material.dart';
import 'package:questionmakerteacher/models/answerer.dart';
import 'package:questionmakerteacher/models/patient.dart';
import 'package:questionmakerteacher/screens/patient_dataview_screen.dart';
import 'package:questionmakerteacher/screens/questionnaire_screen.dart';
import 'package:questionmakerteacher/widgets/test_widgets.dart';

class PatientView extends StatefulWidget {
  const PatientView({super.key, required this.currentPatient, required this.parentOrTeacher});

  final Patient currentPatient;
  final ParentOrTeacher parentOrTeacher;

  @override
  State<StatefulWidget> createState() {
    return _PatientViewState();
  }

}

class _PatientViewState extends State<PatientView> {


  @override
  Widget build(context) {
    final currentPatientReferenceString = "${widget.currentPatient.lastName}, ${widget.currentPatient.firstName} (${widget.currentPatient.patientCode})";

    return Scaffold(
      appBar: AppBar(title: Text("${widget.currentPatient.lastName}, ${widget.currentPatient.firstName}"),),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 100, left: 24, right: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "What would you like to do?",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                ),
              )
            ),
            const SizedBox(height: 100,),
            // ElevatedButton(
            //   onPressed: () {},
            //   style: ElevatedButton.styleFrom(
            //     side: BorderSide(width: 1, color: Theme.of(context).colorScheme.primary),
            //     minimumSize: const Size(250, 40)
            //   ),
            //   child: const Text("View previous questionnaires"),
            // ),
            // const SizedBox(height: 15,),
            //This is the button for new questionnaires
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => QuestionnaireScreen(patientInQuestion: widget.currentPatient, parentOrTeacher:  widget.parentOrTeacher)
                    )
                );
              },
              style: ElevatedButton.styleFrom(
                side: BorderSide(width: 1, color: Theme.of(context).colorScheme.primary),
                minimumSize: const Size(250, 40)
              ),
              child: const Text("Answer new questionnaire")
            ),
            const SizedBox(height: 15,),
            //This will be our data viz for answered questionnaires
            //... might merge this with the view questionnaires one
            //This is the button for viewing questionnaire data
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PatientDataView(patientReference: currentPatientReferenceString))
                );
              },
              style: ElevatedButton.styleFrom(
                  side: BorderSide(width: 1, color: Theme.of(context).colorScheme.primary),
                  minimumSize: const Size(250, 40)
              ),
              child: const Text("View questionnaire data")
            ),
            const SizedBox(height: 15,),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  side: BorderSide(width: 1, color: Theme.of(context).colorScheme.primary),
                  minimumSize: const Size(250, 40)
              ),
              child: const Text("Go Back")
            ),
          ],
        ),
      )
    );
  }

}