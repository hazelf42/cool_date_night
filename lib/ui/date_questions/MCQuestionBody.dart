import 'package:auto_size_text/auto_size_text.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/models/Date.dart';
import 'package:flutter/material.dart';
import 'package:cool_date_night/bloc_helper/helper.dart';
import 'package:flutter/material.dart' as prefix0;
import 'MCQuestion.dart';

class MCQuestionBody extends StatefulWidget {
  final List<dynamic> mcQuestionsList;
  final Date date;
  final Map partner;
  final int index;
  final Category category;
  MCQuestionBody(
      this.mcQuestionsList, this.date, this.partner, this.category, this.index);

  @override
  _MCQuestionBody createState() =>
      _MCQuestionBody(mcQuestionsList, date, partner, category, index);
}

class _MCQuestionBody extends State<MCQuestionBody> {
  final List<dynamic> mcQuestions;
  final Date date;
  final Map partner;
  final int index;
  final Category category;
  int _answerSelected;
  _MCQuestionBody(
      this.mcQuestions, this.date, this.partner, this.category, this.index);

  @override
  Widget build(BuildContext context) {
    num height = MediaQuery.of(context).size.height;
    num width = MediaQuery.of(context).size.width;
    return Stack(children: <Widget>[
      ConstrainedBox(
        constraints:
            BoxConstraints(minHeight: height),
        child: Container(
            color: Theme.dateColors[date.name],
            child: Container(
              child: Column(
                children: <Widget>[
                  partner != null
                      ? Avatar(
                          imagePath: partner['photo'] ?? "",
                          radius: 50,
                          heroTag: 'datemate')
                      : Container(
                          width: width,
                          height: 160,
                          color: Theme.dateColors[date.category],
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
                        mcQuestions[index]['question'],
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
                    itemCount: (mcQuestions[index]['answers'].length),
                    itemBuilder: (_, i) => Container(
                        margin: prefix0.EdgeInsets.only(
                            bottom: 5, left: 30, right: 30),
                        child: OutlineButton(
                          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0)),
                          borderSide: prefix0.BorderSide(
                              color: Colors.white),
                          child: AutoSizeText(
                            mcQuestions[index]['answers'][i].trim(),
                            style: Theme.TextStyles.subheading2Light,
                            maxLines: 3,
                            softWrap: true,
                            textAlign: prefix0.TextAlign.center,
                          ),
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
                                    title: Text("Challenge",
                                        style: TextStyle(color: Colors.white)),
                                    content: Text(
                                        (index == 1)
                                            ? "Brutally criticize your date's answer as best you can. Don't hold back!"
                                            : "Be as enthusiastic as possible about your date's answer -- even if you don't agree.",
                                        style:
                                            Theme.TextStyles.subheadingLight),
                                    actions: <Widget>[
                                      Center(
                                          child: FlatButton(
                                        color: Colors.white30,
                                        child: Text("OK",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18)),
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
                  Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: ButtonTheme(
                          minWidth: 200,
                          child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(20.0)),
                              child: Text("Next"),
                              color: Theme.dateColors[date.category],
                              onPressed: () {
                                if (mcQuestions.length == (index + 1)) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => McQuestion(
                                              date, partner, category, 0)));
                                } else {Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => McQuestion(
                                              date, partner, category, index+1)));
                                }
                              })))
                ],
              ),
            )),
      )
    ]);
  }
}
