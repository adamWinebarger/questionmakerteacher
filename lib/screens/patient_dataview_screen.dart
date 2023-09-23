import 'package:flutter/material.dart';
import 'package:questionmakerteacher/models/questionnaire.dart';
import 'package:questionmakerteacher/widgets/test_widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:questionmakerteacher/data/patient_test_data.dart';
import 'package:questionmakerteacher/data/answer_map.dart';

class PatientDataView extends StatefulWidget {
  const PatientDataView({super.key});

  @override
  State<StatefulWidget> createState() => _PatientDataViewState();

}

class _PatientDataViewState extends State<PatientDataView> {

  int _currentQuestionNumber = 0;

  late List<_AnswerData> _patientDataView;
  late String _currentQuestion;

  @override
  void initState() {
    // TODO: implement initState
    //_patientDataView = sampleAnswers[sampleAnswers.keys.first];
    _currentQuestion = _sampleAnswerData[_currentQuestionNumber].question;
    super.initState();
  }

  @override
  Widget build(context) {
    // TODO: implement build

    print(sampleAnswers[_sampleAnswerData[0]]);

    return Scaffold(
      appBar: AppBar(title: const Text("View Patient Data"),),
      body: SafeArea(
        child: Scaffold(
          body: Center(child: Column(
            children: [
              SizedBox(height: 15,),
              Text(_currentQuestion),
              SizedBox(height: 15,),
              SfCircularChart(
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CircularSeries>[
                  PieSeries<_AnswerValues, String>(
                    dataSource: _sampleAnswerData[_currentQuestionNumber].answers,
                    xValueMapper: (_AnswerValues answer, _) => AnswerMap[answer.answer],
                    yValueMapper: (_AnswerValues answer, _) => answer.value,
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true
                    ),
                    enableTooltip: true
                  )
                ],
              )
            ],
          )),
        ),
      )
    );
  }
}

class _AnswerValues {
  _AnswerValues(this.answer, this.value);

  final Answers answer;
  final int value;
}

class _AnswerData {
  _AnswerData(this.question);
  _AnswerData.withMap(this.question, this.answers);

  final String question;
  List<_AnswerValues> answers = [];

  //We'll likely need a function

}

_AnswerData _sample1 = _AnswerData.withMap("The child did their homework",
    [
      _AnswerValues(Answers.notAtAll, 4),
      _AnswerValues(Answers.sometimes, 3),
      _AnswerValues(Answers.alot, 6),
      _AnswerValues(Answers.always, 7)
    ]
),
  _sample2 = _AnswerData.withMap("The child stayed on task",
      [
        _AnswerValues(Answers.notAtAll, 7),
        _AnswerValues(Answers.sometimes, 4),
        _AnswerValues(Answers.alot, 3),
        _AnswerValues(Answers.always, 9)
      ]
  ),
  _sample3 = _AnswerData.withMap("The child did things when asked the first time" ,
      [
        _AnswerValues(Answers.notAtAll, 3),
        _AnswerValues(Answers.sometimes, 7),
        _AnswerValues(Answers.alot, 8),
        _AnswerValues(Answers.always, 4)
      ]
  ),
  _sample4 = _AnswerData.withMap("The child is pretty alright I guess",
      [
        _AnswerValues(Answers.notAtAll, 5),
        _AnswerValues(Answers.sometimes, 4),
        _AnswerValues(Answers.alot, 6),
        _AnswerValues(Answers.always, 5)
      ]
);

List<_AnswerData> _sampleAnswerData = [_sample1, _sample2, _sample3, _sample4];