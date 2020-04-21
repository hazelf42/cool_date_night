import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/helpers/helper.dart';
import 'package:cool_date_night/models/Date.dart';
import 'package:cool_date_night/ui/date_questions/DateComplete.dart';
import 'package:cool_date_night/ui/date_questions/OpenQuestion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;

import 'MCQuestion.dart';

class MCQuestionBody extends StatefulWidget {
  final List<dynamic> questionList;
  final String uid;
  final DocumentSnapshot partnerData;
  final int index;
  final Category category;
  int challenged;
  MCQuestionBody(this.questionList, this.uid, this.partnerData, this.category,
      this.challenged, this.index);

  @override
  _MCQuestionBody createState() => _MCQuestionBody(
      questionList, uid, partnerData, category, challenged, index);
}

class _MCQuestionBody extends State<MCQuestionBody> {
  final List<dynamic> questionList;
  final String uid;
  final DocumentSnapshot partnerData;
  final int index;
  final Category category;
  int challenged;
  int _answerSelected;
  _MCQuestionBody(this.questionList, this.uid, this.partnerData, this.category,
      this.challenged, this.index);

  @override
  Widget build(BuildContext context) {
    print(_answerSelected);
    num height = MediaQuery.of(context).size.height;
    num width = MediaQuery.of(context).size.width;
    return Stack(children: <Widget>[
      ConstrainedBox(
        constraints: BoxConstraints(minHeight: height),
        child: Container(
            child: Container(
          child: Column(
            children: <Widget>[
              partnerData.data != null
                  ? Container(
                      width: width,
                      color: category.color,
                      child: Column(children: [
                        prefix0.SizedBox(height: 30),
                        Avatar(
                            imagePath: partnerData['photo'] ??
                                "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                            radius: 60,
                            heroTag: 'datemate'),
                        prefix0.SizedBox(height: 30)
                      ]))
                  : Container(
                      width: width,
                      height: 160,
                      color: category.color,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 10),
                            Text(
                              category.name,
                              style: Theme.TextStyles.dateTitle,
                            ),
                            SizedBox(height: 15),
                            ClipOval(
                                child: Container(
                                    color: Colors.white,
                                    child: Avatar(
                                        imagePath: category.image,
                                        radius: 75,
                                        heroTag: 'category'))),
                            SizedBox(height: 10)
                          ])),
              SizedBox(height: 10),
              Container(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                  child: AutoSizeText(
                    questionList[index]['question'],
                    style: prefix0.TextStyle(
                        fontWeight: prefix0.FontWeight.w500,
                        fontSize: 18,
                        color: Colors.white),
                    textAlign: TextAlign.left,
                    maxLines: 5,
                  )),
              prefix0.SizedBox(height: 10),
              ListView.builder(
                physics: prefix0.NeverScrollableScrollPhysics(),
                itemCount: (questionList[index]['answers'].length),
                itemBuilder: (_, i) => Container(
                    margin:
                        prefix0.EdgeInsets.only(bottom: 5, left: 30, right: 30),
                    child: FlatButton(
                      color: _answerSelected == i
                          ? Theme.Colors.mustard
                          : Colors.transparent,
                      padding: EdgeInsets.only(
                          top: 5, bottom: 5, left: 10, right: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0),
                        side: prefix0.BorderSide(color: Colors.white),
                      ),
                      child: AutoSizeText(
                        questionList[index]['answers'][i].trim(),
                        style: _answerSelected == i
                            ? Theme.TextStyles.subheading2Dark
                            : Theme.TextStyles.subheading2Light,
                        maxLines: 3,
                        softWrap: true,
                        textAlign: prefix0.TextAlign.center,
                      ),
                      splashColor: Theme.Colors.mustard,
                      onPressed: () {
                        setState(() {
                          _answerSelected = i;
                        });
                      },
                    )),
                shrinkWrap: true,
              ),
              _nextButton()
            ],
          ),
        )),
      )
    ]);
  }

  Widget _nextButton() {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: ButtonTheme(
            minWidth: 200,
            child: FlatButton(
                splashColor: (_answerSelected == null)
                    ? Colors.transparent
                    : Colors.black12,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
                child: Text("Next"),
                color: _answerSelected == null
                    ? Colors.grey
                    : category.color,
                onPressed: () async {
                  if (_answerSelected != null &&
                      challenged <= 0 &&
                      Random().nextInt(4) == 2) {
                    challenged == -1
                        ? await _showChallengeInstructions().then((_) async {
                            await _showRandomChallenge().then((_) {
                              challenged = 1;
                              _nextQuestion();
                            });
                          })
                        : await _showRandomChallenge().then((_) {
                            challenged = 1;
                            _nextQuestion();
                          });
                  } else if (questionList.length == (index + 1) &&
                      challenged <= 0) {
                    challenged == -1
                        ? await _showChallengeInstructions().then((_) async {
                            await _showRandomChallenge().then((_) {
                              challenged = 1;
                              _nextQuestion();
                            });
                          })
                        : await _showRandomChallenge().then((_) {
                            challenged = 1;
                            _nextQuestion();
                          });
                  } else if (_answerSelected != null) {
                    _nextQuestion();
                  }
                })));
  }

  void _nextQuestion() {
    if (questionList.length == (index + 1)) {
      Navigator.push(
          context, SlideRightRoute(page: DateCompleteScreen(category, uid)));
    } else {
      Navigator.push(
          context,
          SlideRightRoute(
              page: (questionList[index + 1] is String)
                  ? OpenQuestion(
                      questionList,
                      uid,
                      partnerData.data == null ? null : partnerData['uid'],
                      category,
                      challenged,
                      index + 1)
                  : McQuestion(
                      questionList,
                      uid,
                      partnerData.data == null ? null : partnerData['uid'],
                      category,
                      challenged,
                      index + 1)));
    }
  }

  Future<Widget> _showRandomChallenge() async {
    Random rnd = Random();

    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.Colors.midnightBlue,
            title:
                Text("Secret Challenge", style: TextStyle(color: Colors.white)),
            content: Text(
                MainBloc().listOfChallenges[
                    rnd.nextInt(MainBloc().listOfChallenges.length)],
                style: Theme.TextStyles.subheadingLight),
            actions: <Widget>[
              Center(
                  child: FlatButton(
                color: Colors.white30,
                child: Text("OK",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )),
            ],
          );
        });
  }

  Future<Widget> _showChallengeInstructions() async {
    //This will only show if user has not completed a date.
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.Colors.midnightBlue,
            title: Text("Secret Challenge (Keep this to yourself!)",
                style: TextStyle(color: Colors.white)),
            content: Text(
                "Try to complete this challenge without your Datemate suspecting anything. Let's see how well they REALLY know you!",
                style: Theme.TextStyles.subheadingLight),
            actions: <Widget>[
              Center(
                  child: FlatButton(
                color: Colors.white30,
                child: Text("OK",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _showRandomChallenge();
                },
              )),
            ],
          );
        });
  }
}
