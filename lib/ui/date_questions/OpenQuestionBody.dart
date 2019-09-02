import 'package:auto_size_text/auto_size_text.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/bloc_helper/helper.dart';
import 'package:cool_date_night/models/Date.dart' as Date;
import 'package:cool_date_night/ui/date_questions/MCQuestion.dart';
import 'package:flutter/material.dart';

import 'DateComplete.dart';
import 'OpenQuestion.dart';

class OpenQuestionBody extends StatelessWidget {
  final int index;
  final List<dynamic> dateList;
  final Map partner;
  final Date.Category category;

  OpenQuestionBody(this.dateList, this.partner, this.category, this.index);

  @override
  Widget build(BuildContext context) {
    num height = MediaQuery.of(context).size.height;
    num width = MediaQuery.of(context).size.width;
    return Stack(children: <Widget>[
      ConstrainedBox(
        constraints:
            BoxConstraints(minHeight: height - 80, maxHeight: height - 80),
        child: Container(
            width: width,
            color: Theme.Colors.midnightBlue,
            child: Container(
              child: Column(
                children: [
                  partner == null
                      ? Container(
                          width: double.infinity,
                          height: height / 2 - 60,
                          color: Theme.dateColors[category],
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: 25),
                                Text(category.name,
                                    style: Theme.TextStyles.bigTitle),
                                SizedBox(height: 15),
                                ClipOval(
                                    child: Container(
                                        color: Colors.white,
                                        child: Avatar(
                                            imagePath: category.image,
                                            radius: 75,
                                            heroTag: 'category'))),
                                SizedBox(
                                  height: 25,
                                )
                              ]))
                      : Container(
                          width: double.infinity,
                          height: height / 2 - 60,
                          color: Theme.dateColors[category],
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: 25),
                                Text(
                                  "Your date with",
                                  style: Theme.TextStyles.subheading2Light,
                                ),
                                Text(
                                  partner['name'],
                                  style: Theme.TextStyles.dateTitle,
                                ),
                                SizedBox(height: 15),
                                Avatar(
                                    imagePath: category.image,
                                    radius: 75,
                                    heroTag: 'datemate'),
                                SizedBox(
                                  height: 25,
                                )
                              ])),
                  SizedBox(height: 10),
                  Container(
                      padding: EdgeInsets.all(20),
                      height: height / 2 - 110,
                      child: Center(
                          child: AutoSizeText(
                        questionString(),
                        style: Theme.TextStyles.subheadingLight,
                        textAlign: TextAlign.left,
                        maxLines: 6,
                      ))),
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.all(20),
                          child: ButtonTheme(
                              minWidth: 200,
                              child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(20.0)),
                                  child: Text("Next"),
                                  color: Theme.dateColors[category],
                                  onPressed: () {})))),
                ],
              ),
            )),
      )
    ]);
  }

  void next(BuildContext context) {
    if (dateList.length == index + 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DateCompleteScreen(category)));
    }
    if (dateList[index + 1]['answers'] != null) {
      //It's a MC question
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  McQuestion(dateList, partner, category, index + 1)));
    } else {
      //It's an open question
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  OpenQuestion(dateList, partner, category, index + 1)));
    }
  }

  String questionString() {
    final a = dateList[index];
    List<String> b = a.split("}")[0].split("");
    var c = List<String>.from(b);
    c.removeAt(0);
    return b.join("");
  }
}
