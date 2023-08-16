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

  final _formKey = GlobalKey<FormState>();
  final List<Answers> _answers = [];

  int _count = 0;
  Answers? _selectedAnswer;
  TimeOfInteraction? _selectedTimeOfInteraction;

  List<Widget> _setupAnswerRadioButtons() {
    List<Widget> widgetList = [];

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
    return widgetList;
  }

  void _nextPressed() {
    if (_selectedAnswer != null) {
      _answers.add(_selectedAnswer!);
    }

    if (_count < widget.patientInQuestion.teacherQuestions.length - 1 && _selectedAnswer != null) {
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
          key: _formKey,
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
              //const SizedBox(height: 25,),
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
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  label: Text(
                      "Select the time of day that this questionnaire is for:",
                    style: TextStyle(
                      fontSize: 12
                    ),
                  )
                ),
                items: [
                  for (final selection in TimeOfInteraction.values)
                    DropdownMenuItem(
                        value: selection,
                        child: Text(selection.name.capitalize())
                    )
                ] ,
                onChanged: (value) {
                  setState(() {
                    _selectedTimeOfInteraction = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return "You must select a time of day for this interaction";
                  }
                  return null;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}