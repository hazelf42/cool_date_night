import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cool_date_night/models/Date.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:flutter/material.dart';
import 'MCQuestion.dart';

class MCQuestionBody extends StatefulWidget {
  final List<dynamic> mcQuestionsList;
  final Date date;
  final Map partner;
  final int index;
  MCQuestionBody(this.mcQuestionsList, this.date, this.partner, this.index);

  @override
  _MCQuestionBody createState() =>  _MCQuestionBody(mcQuestionsList, date, partner, index);
}

class _MCQuestionBody extends State<MCQuestionBody> {
  final List<dynamic> mcQuestions;
  final Date date;
  final Map partner;
  final int index;
  int _answerSelected = null;
  _MCQuestionBody(this.mcQuestions, this.date, this.partner, this.index);

  @override
  Widget build(BuildContext context) {
    return  Stack(children: <Widget>[
       ConstrainedBox(
         constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
         child: Container(
        
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/img/bluegradient.png"),
                fit: BoxFit.cover)),
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: <Widget>[
               SizedBox(height: 20),
                partner != null ? Hero(
                    tag: 'datemate',
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(partner['photo'] ?? ""),
                      radius:  25,
                    )) : Container(height: 0),
                
                SizedBox(height: 10),
                Container(
                    padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                    child: AutoSizeText(
                      mcQuestions[index]['question'],
                      style: Theme.TextStyles.subheadingLight,
                      textAlign: TextAlign.left,
                      maxLines: 5,
                    )),
                ListView.builder(
                  itemCount: (mcQuestions[index]['answers'].length),
                  itemBuilder: (_, i) => 
                  
                  ConstrainedBox( constraints: BoxConstraints(), child : FlatButton(
                        child: AutoSizeText(mcQuestions[index]['answers'][i].trim(), maxLines: 3, softWrap: true,),
                        splashColor: Theme.Colors.mustard,
                        color: (_answerSelected == i)
                            ? Theme.Colors.mustard
                            : Colors.white,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Theme.Colors.midnightBlue,
                                  title: Text("Challenge", style: TextStyle(color: Colors.white)),
                                  content: Text((index == 1)
                                      ? "Brutally criticize your date's answer as best you can. Don't hold back!"
                                      : "Be as enthusiastic as possible about your date's answer -- even if you don't agree.", style: Theme.TextStyles.subheadingLight),
                                  actions: <Widget>[
                                    Center(child:
                                    FlatButton(
                                      color: Colors.white30,
                                      child: Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
                                      onPressed: () {
                                        setState(() {
                                          _answerSelected = i;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    )),
                                  ],
                                );
                              });
                        },
                      )),
                  shrinkWrap: true,
                ),
                SizedBox(height: 20),
                  FlatButton(
                    child: Text("Next"),
                    color: (_answerSelected != null)
                        ? Theme.Colors.mustard
                        : Colors.grey,
                    onPressed: () {
                      (_answerSelected != null)
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      mcQuestion(date, partner, index + 1)))
                          : null;
                    })
              ],
            ),
          )),
    )]); 
  }
}

