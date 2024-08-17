import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:questionmakerteacher/models/questionnaire.dart';
import 'package:questionmakerteacher/widgets/test_widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:questionmakerteacher/data/patient_test_data.dart';
import 'package:questionmakerteacher/data/answer_map.dart';
import 'package:questionmakerteacher/models/patient.dart';
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

  List<_AnswerData> _answerDataList = [];


  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 7)), _toDate = DateTime.now();

  final _noAnswersWidget = const Center(child:
    Text("No data available.\n Maybe adjust your search parameters?",
      textAlign: TextAlign.center,)
  );

  late List<_AnswerData> _patientDataView;
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
  Future<List<_AnswerData>> _getAnswerDocumentsFromDatabase() async {
    //So what we need is the Answers Documents that are within the from date and the to date.
    //From there, we would want to look at the Answers subfield within, grab the question,
    //then check if the question is already in our AV list. If it is, then increment the relevant
    //enum pattern by 1; if it's not, then add the question in there and then increment the relevant
    //enum pattern by 1

    List<_AnswerData> avList = [];

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

        if (avList.contains(key)) {
          final requisiteAnswerData = avList.firstWhere((element) => element == key);
          print("Requisite Answer Data: ${requisiteAnswerData.question}");
          //requisiteAnswerData._ad

        } else {
          //avList.add(_AnswerData.withStringSelection(avList.firstWhere((element) => element == key), 1));
          //Not sure what to put here
        }
      }
    }
    print("AVList: $avList");
    return avList;

  }

  //Async method for grabbing data from the cloud firestore database and putting it into list format
  // for the infographic to then render
  Future<List<_AnswerData>> _getAnswerDataListFromDatabase() async {
    List<_AnswerData> _anwerdataList = [];
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
            PieSeries<_AnswerValues, String>(
              dataSource: _answerDataList[_currentQuestionNumber].answers,
              xValueMapper: (_AnswerValues answer, _) => AnswerMap[answer.answer],
              yValueMapper: (_AnswerValues answer, _) => answer.value,
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

class _AnswerValues {
  _AnswerValues(this.answer, this.value);

  final Answers answer;
  int value;

  @override
  bool operator ==(Object other) {

    if (identical(this,other)) {
      return true;
    }

    if (other is Answers) {
      return other == answer;
    }

    if (other is String) {
      return other == answer.name;
    }

    return other is _AnswerValues && other.answer == answer;
  }

  void increment() {
    value++;
  }

  void incrementBy(int inc) {
    value += inc;
  }

  void setValue(int set) {
    value = set;
  }
}

/*
* So essentially, a few things need to happen in the process here when bringing in data
* from the Answers subcollection within a given Patient's document.
*
* First, it needs to do a query for Answers and only pull back the Documents within Answers that
* fall within the Date range determined by the query (Default will be last 7 Days but we will have options
* within there for others.
*
* Secondly, once we've grabbed the requsite Answers docs from the Collection, we'll
* turn each Document that we've grabbed from Answers into a Questionnaire (gets us
* using that class again anyways).
*
* Then for each question within our Questionnaire object, we'll need to check if it
* already has a corresponding _AnswerData object (would be good to have a list for these),
* and if not create one.
*
* In any case, we will need to increment the corresponding answer based on how it was answered in the questionnaire
*
* With that info, we should be able to make a simple List of our _AnswerData class and have that be usable for these
* infographics.
*/

//So _AnswerData should essentially model the Answers sub-document for a given Patient
//in our firestore database. But given the fact that... actually, no, shit, this needs a rewrite
class _AnswerData {
  _AnswerData.withMap(this.question, this.answers);

  final String question;
  List<_AnswerValues> answers = [];

  _AnswerData(this.question) {
    for (var key in AnswerMap.keys) {
      answers.add(_AnswerValues(key, 0));
    }
  }

  _AnswerData.withStringSelection(this.question, String selection) {
    Answers? a = _answerSelection[selection];

    if (a != null) {
      if (answers.contains(a)) {
        //print("In with String Selection. Question: ${this.question}, Selection: $selection");
        print(answers.where((element) => false));
      } else {
        //print("In with String Selection. Question: ${this.question}, Selection: $selection");
        answers.add(_AnswerValues(_answerSelection[selection]!, 1)); //Adds our specified enum value and increments it by 1
      }
    }
  }

  void _addAnswerToData(String response) {
    if (answers.contains(response)) {
      //print(answers.where((element) => false));
      print("Answer didn't contain $response");

    } else {
      //print("Adding answer $response to the thing");
      answers.add(_AnswerValues(_answerSelection[response]!, 1)); //Adds our specified enum value and increments it by 1

    }
  }

  //Since we're lazy, we essentially want == to compare question values in order to
  //check if a question is already in our list. Or something.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is String) {
      return other == question;
    }
    return other is _AnswerData && other.question == question;
  }

  //We'll likely need a function to convert the answer data...
  //fuck, so we need some sort of constructor here that will essnetially

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