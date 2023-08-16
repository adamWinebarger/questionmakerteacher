import 'package:flutter/material.dart';

import 'package:questionmakerteacher/models/patient.dart';
import 'package:questionmakerteacher/models/questionnaire.dart';
import 'package:questionmakerteacher/stringextension.dart';

Map<String, Answers> _answerSelection = {
  "Not at All" : Answers.notAtAll,
  "Sometimes" : Answers.sometimes,
  "A Lot" : Answers.alot,
  "Always" : Answers.always
};

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key, required this.patientInQuestion});

  final Patient patientInQuestion;

  @override
  State<StatefulWidget> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {

  //final _formKey = GlobalKey<FormState>();
  final List<Answers> _answers = [];

  int _count = -1;
  Answers? _selectedAnswer;
  TimeOfInteraction? _selectedTimeOfInteraction;

  List<Widget> _setupAnswerRadioButtons() {
    List<Widget> widgetList = [];

    if (_count >= 0) {
      for (final category in _answerSelection.entries) {
        widgetList.add(
            ListTile(
              title: Text(category.key),
              leading: Radio<Answers> (
                value: category.value,
                groupValue: _selectedAnswer,
                onChanged: (Answers? value) {
                  setState(() {
                    _selectedAnswer = value;
                  });
                },
              ),
            )
        );
        widgetList.add(const SizedBox(height: 20,));
      }
    } else {
      for (final selection in TimeOfInteraction.values) {
        widgetList.add(
          ListTile(
            title: Text(selection.name.capitalize()),
            leading: Radio<TimeOfInteraction>(
              value: selection,
              groupValue: _selectedTimeOfInteraction,
              onChanged: (TimeOfInteraction? value) {
                setState(() {
                  _selectedTimeOfInteraction = value;
                });
              },
            ),
          )
        );
      }
    }
    return widgetList;
  }

  void _nextPressed() {
    if (_count >= 0 && _selectedAnswer != null) {
      _answers.add(_selectedAnswer!);
    }

    if (_count < widget.patientInQuestion.teacherQuestions.length - 1) {
      setState(() {
        _count++;
        _selectedAnswer = null;
      });
    } else {
      //This is where we will submit our answers
    }
  }

  void _backPressed() {
    if (_count > 0) {
      setState(() {
        --_count;
        _selectedAnswer = _answers.isNotEmpty ? _answers.last : null;
        _answers.removeLast();
      });
    } else if (_count == 0) {
      setState(() {
        _count = -1;
        _answers.removeLast();
        //build(context);
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Answer Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
        child: Form(
          //key: _formKey,
          child: Column(
            children: [
              if (_count > -1)
                Center(
                  child: Text(
                    "Question ${_count+1}",
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              if (_count > -1)
                const SizedBox(height: 15,),
              Center(
                child: SizedBox(
                  height: 75,
                  child: Text(
                    (_count > -1) ?
                      widget.patientInQuestion.teacherQuestions[_count] :
                        "Select the time of day that this questionnaire reflects:",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              for (final item in _setupAnswerRadioButtons())
                item,
              const SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _backPressed,
                    child: const Text("Back")
                  ),
                  const SizedBox(width: 15,),
                  ElevatedButton(
                    onPressed: _nextPressed,
                    child: Text(
                      _count == widget.patientInQuestion.teacherQuestions.length - 1 ?
                        "Submit" : "Next"
                    )
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}