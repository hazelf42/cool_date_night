import 'package:auto_size_text/auto_size_text.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/main.dart';
import 'package:cool_date_night/models/Date.dart';
import 'package:cool_date_night/ui/date_questions/DateComplete.dart';
import 'package:flutter/material.dart';
import 'package:cool_date_night/bloc_helper/helper.dart';
import 'package:flutter/material.dart' as prefix0;
import 'MCQuestion.dart';
import 'dart:math';

import 'OpenQuestion.dart';

class MCQuestionBody extends StatefulWidget {
  final List dateList;
  final Map partner;
  final int index;
  final Category category;
  MCQuestionBody(this.dateList, this.partner, this.category, this.index);

  @override
  _MCQuestionBody createState() =>
      _MCQuestionBody(dateList, partner, category, index);
}

class _MCQuestionBody extends State<MCQuestionBody> {
  final List<dynamic> dateList;
  final Map partner;
  final int index;
  final Category category;
  int _answerSelected;
  _MCQuestionBody(this.dateList, this.partner, this.category, this.index);

  @override
  Widget build(BuildContext context) {
    print(_answerSelected);
    num height = MediaQuery.of(context).size.height;
    num width = MediaQuery.of(context).size.width;
    return Stack(children: <Widget>[
      ConstrainedBox(
        constraints: BoxConstraints(minHeight: height),
        child: Container(
            color: Theme.dateColors[category.name],
            child: Container(
              child: Column(
                children: <Widget>[
                  partner != null
                      ? Avatar(
                          imagePath: partner['photo'] ??
                              "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                          radius: 50,
                          heroTag: 'datemate')
                      : Container(
                          width: width,
                          height: 160,
                          color: Theme.dateColors[category],
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
                        dateList[index]['question'],
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
                    itemCount: (dateList[index]['answers'].length),
                    itemBuilder: (_, i) => Container(
                        margin: prefix0.EdgeInsets.only(
                            bottom: 5, left: 30, right: 30),
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
                            dateList[index]['answers'][i].trim(),
                            style: Theme.TextStyles.subheading2Light,
                            maxLines: 3,
                            softWrap: true,
                            textAlign: prefix0.TextAlign.center,
                          ),
                          splashColor: Theme.Colors.mustard,
                          onPressed: () {
                            setState(() {
                              _answerSelected = i;
                            });
                            _showRandomChallenge();
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
                    : Theme.dateColors[category],
                onPressed: () {
                  next(context);
                })));
  }

  void next(BuildContext context) {
    if (_answerSelected != null) {
      if (dateList.length == (index + 1)) {
        //This couldn't happen, but whatever
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DateCompleteScreen(category)));
      } else if (dateList[index+1].answers != null){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    McQuestion(dateList, partner, category, index + 1)));
      } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  OpenQuestion(dateList, partner, category, index + 1)));
      }
    }
  }

  void _showRandomChallenge() {
    Random rnd = Random();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.Colors.midnightBlue,
            title: Text("Challenge", style: TextStyle(color: Colors.white)),
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
}
