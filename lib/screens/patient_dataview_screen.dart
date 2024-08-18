import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:questionmakerteacher/models/questionnaire.dart';
import 'package:questionmakerteacher/widgets/test_widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:questionmakerteacher/data/patient_test_data.dart';
import 'package:questionmakerteacher/data/answer_map.dart';
import 'package:questionmakerteacher/models/patient.dart';
import '../models/answer_data.dart';
import 'questionnaire_screen.dart';

Map<String, Answers> _answerSelection = {
  "notAtAll" : Answers.notAtAll,
  "sometimes" : Answers.sometimes,
  "aLot" : Answers.alot,
  "always" : Answers.always
};

class PatientDataView extends StatefulWidget {
  const PatientDataView({super.key, required this.patientReference});

  final String patientReference;

  @override
  State<StatefulWidget> createState() => _PatientDataViewState();

}

class _PatientDataViewState extends State<PatientDataView> {

  //variables that will determine what widget to display based on whether the app is fetching data.
  //whether it's found it, and should also probably handle what happens if and when it does find data
  bool _isFetchingData = false, _fetchedData = false;
  int _currentQuestionNumber = 0, _dayRange = 7;

  List<AnswerData> _answerDataList = [];


  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 7)), _toDate = DateTime.now();

  final _noAnswersWidget = const Center(child:
    Text("No data available.\n Maybe adjust your search parameters?",
      textAlign: TextAlign.center,)
  );

  late List<AnswerData> _patientDataView;
  late String _currentQuestion;

  void _nextPressed() {
    setState(() {
      _currentQuestionNumber++;
      print(_currentQuestionNumber);
    });
  }

  void _previousPressed() {
    if (_currentQuestionNumber == 0) {
      Navigator.pop(context);
    } else {
      setState(() {
        _currentQuestionNumber--;
      });
    }
  }

  //Async method for grabbing the Answers from the firebase database
  Future<List<AnswerData>> _getAnswerDocumentsFromDatabase() async {
    //So what we need is the Answers Documents that are within the from date and the to date.
    //From there, we would want to look at the Answers subfield within, grab the question,
    //then check if the question is already in our AV list. If it is, then increment the relevant
    //enum pattern by 1; if it's not, then add the question in there and then increment the relevant
    //enum pattern by 1

    List<AnswerData> avList = [];

    final CollectionReference _crList = FirebaseFirestore.instance.collection("Patients")
        .doc(widget.patientReference).collection("Answers");
    //query to look at docs within a given tim period (from and to will be adjustable)
    final QuerySnapshot requisiteAnswersQuery = await _crList
        .where("Timestamp", isGreaterThanOrEqualTo: _fromDate)
        .where("Timestamp", isLessThanOrEqualTo: _toDate).get();

    //This for examines each individual document from our query
    for (var docSnapshot in requisiteAnswersQuery.docs) {
      //print("Doc snnapshot: ${docSnapshot.id} => ${docSnapshot.data()}");
      //gotta load them into a map before we can do anything
      Map<String, dynamic> documentData = docSnapshot.data() as Map<String, dynamic>;
      //print('Data ${documentData['Answers']}');
      //Gotta do the same with our 'Answers' attribute within the doc, which is all we really want here
      Map<String, dynamic> answers = documentData['Answers'];
      for (String key in answers.keys) {
        //print(answers[key]);
        //Now in our forLoop, we gotta check if avList contains already contains the question
        //shown in the key section, if it doesn't, then it needs to add the question into avList
        //in addition to incrementing the corresponding value; and if it does, then it only needs
        //to increment the corresponding enum value for the question

        //So key is the "question" while value is the answer - and we need to increment the
        //"Answer Map" by 1 any time a new answer pops, basically.
        print("Key: $key; value: ${answers[key]}");

        if (avList.contains(key)) {
          final requisiteAnswerData = avList.firstWhere((element) => element == key).add1(answers[key]);
          //print("Requisite Answer Data: ${requisiteAnswerData.question}");
          //requisiteAnswerData._ad

        } else {
          //avList.add(_AnswerData.withStringSelection(avList.firstWhere((element) => element == key), 1));
          //Not sure what to put here
          print("Else condition fired");
          final temp = AnswerData(key);
          temp.add1(answers[key]);
          avList.add(temp);
        }
      }
    }
    print("AVList: $avList");
    return avList;

  }

  //Async method for grabbing data from the cloud firestore database and putting it into list format
  // for the infographic to then render
  Future<List<AnswerData>> _getAnswerDataListFromDatabase() async {
    List<AnswerData> _anwerdataList = [];
    return _anwerdataList;
  }

  @override
  void initState() {
    // TODO: implement initState
    //_patientDataView = sampleAnswers[sampleAnswers.keys.first];

    //print(widget.patientReference);
    //_currentQuestion = _sampleAnswerData[_currentQuestionNumber].question;
    super.initState();
    setState(() {
      _isFetchingData = true;
    });
    //_getAnswerDocumentsFromDatabase();
    _getAnswerDocumentsFromDatabase().then((value) {
      setState(() {

        print(value);
        _answerDataList = value;
        //print(_answerDataList);
        print("Answer Data List insdide setState: $_answerDataList");
        _currentQuestion = _answerDataList[0].question;
      });
    });
    print("Answer Data List: ${_answerDataList}");
    setState(() {
      _isFetchingData = false;
    });
  }

  @override
  Widget build(context) {

    //print(sampleAnswers[_sampleAnswerData[0]]);
    //print(sampleAnswers[_sampleAnswerData[0]]);
    print("Build executes");

    return Scaffold(
      appBar: AppBar(title: const Text("View Patient Data"),),
      body: SafeArea(
        child: (_answerDataList.isNotEmpty) ? Center(child: Column(
      children: [
        const SizedBox(height: 40,),
        Text("Question ${_currentQuestionNumber+1}: \n$_currentQuestion",
          style: TextStyle(fontSize: 22),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15,),
        SfCircularChart(
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CircularSeries>[
            PieSeries<AnswerValues, String>(
              dataSource: _answerDataList[_currentQuestionNumber].answers,
              xValueMapper: (AnswerValues answer, _) => AnswerMap[answer.answer],
              yValueMapper: (AnswerValues answer, _) => answer.value,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true
              ),
              enableTooltip: true
            )
          ],
        ),
        const SizedBox(height: 25,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: (_currentQuestionNumber > 0) ? _previousPressed : (){},
              child: const Text("Back")),
            SizedBox(width: 15,),
            ElevatedButton(
              onPressed: (_currentQuestionNumber < _sampleAnswerData.length - 1) ? _nextPressed : (){},
              child: const Text("Next")
            )
          ],
        )

      ],
      )) : (!_isFetchingData) ? Center(child: CircularProgressIndicator(),) : _noAnswersWidget
    ));
  }
}

// Scaffold(
//           body: Center(child: Column(
//             children: [
//               const SizedBox(height: 25,),
//               Text("Question ${_currentQuestionNumber+1}: $_currentQuestion",
//                 style: TextStyle(fontSize: 24),
//                 textAlign: TextAlign.center,
//

AnswerData _sample1 = AnswerData.withMap("The child did their homework",
    [
      AnswerValues(Answers.notAtAll, 4),
      AnswerValues(Answers.sometimes, 3),
      AnswerValues(Answers.alot, 6),
      AnswerValues(Answers.always, 7)
    ]
),
  _sample2 = AnswerData.withMap("The child stayed on task",
      [
        AnswerValues(Answers.notAtAll, 7),
        AnswerValues(Answers.sometimes, 4),
        AnswerValues(Answers.alot, 3),
        AnswerValues(Answers.always, 9)
      ]
  ),
  _sample3 = AnswerData.withMap("The child did things when asked the first time" ,
      [
        AnswerValues(Answers.notAtAll, 3),
        AnswerValues(Answers.sometimes, 7),
        AnswerValues(Answers.alot, 8),
        AnswerValues(Answers.always, 4)
      ]
  ),
  _sample4 = AnswerData.withMap("The child is pretty alright I guess",
      [
        AnswerValues(Answers.notAtAll, 5),
        AnswerValues(Answers.sometimes, 4),
        AnswerValues(Answers.alot, 6),
        AnswerValues(Answers.always, 5)
      ]
);

List<AnswerData> _sampleAnswerData = [_sample1, _sample2, _sample3, _sample4];