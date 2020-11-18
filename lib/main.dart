import 'package:flutter/material.dart';
import 'package:quizzler/quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

QuizBrain quizBrain = QuizBrain();

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizzlerState createState() => _QuizzlerState();
}

class _QuizzlerState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];
  int numberOfRightAnswer = 0;

  void handleEndOfQuiz() {
    quizBrain.reset();
    int totalQuestions = quizBrain.totalQuestions();

    Alert(
      context: context,
      type: AlertType.warning,
      title: "Quiz Ended",
      desc: "You have scored $numberOfRightAnswer/$totalQuestions \n Quiz shall start from begining again!.",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "CANCEL",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
    scoreKeeper.clear();
    numberOfRightAnswer = 0;
  }

  void matchAnswer(bool answer) {
    setState(() {
      if(quizBrain.matchAnswer(answer)){
        numberOfRightAnswer++;
        scoreKeeper.add(Icon(
          Icons.check,
          color: Colors.green,
        ));
      } else {
        scoreKeeper.add(Icon(
          Icons.close,
          color: Colors.red,
        ));
      }
      if(!quizBrain.moveToNextQuestion()) {
        handleEndOfQuiz();
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment:MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 5,
          child:Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(quizBrain.getQuestion(),
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              color: Colors.green,
                onPressed: (){
                  matchAnswer(true);
                }, child: Text('TRUE',
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),)),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              color: Colors.red,
                onPressed: (){
                  matchAnswer(false);
                }, child: Text('FALSE',
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),)),
          ),
        ),
        Row(
          children: scoreKeeper,
        )
      ],
    );
  }
}
