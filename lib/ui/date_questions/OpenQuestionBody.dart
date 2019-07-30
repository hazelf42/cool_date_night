import 'package:cool_date_night/ui/date_questions/MCQuestion.dart';
import 'package:flutter/material.dart';
import 'package:cool_date_night/models/Date.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/Routes.dart';
import 'package:fluro/fluro.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'OpenQuestion.dart';

class OpenQuestionBody extends StatelessWidget {
  final int index;
  final List<dynamic> openQuestions;
  final Date date;
  final Map partner;
  OpenQuestionBody(this.openQuestions, this.partner, this.date, this.index);

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      ConstrainedBox(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/img/bluegradient.png"),
                    fit: BoxFit.cover)),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  partner != null
                      ? Column(children: <Widget>[
                          SizedBox(height: 75),
                          Text(
                            "Your date with",
                            style: Theme.TextStyles.subheadingLight,
                          ),
                          SizedBox(height: 7),
                          Hero(
                              tag: 'datemate',
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(partner['photo'] ?? ""),
                                radius: 25,
                              )),
                          SizedBox(height: 7),
                          Text(
                            partner['name'],
                            style: Theme.TextStyles.subheadingLight,
                          )
                        ])
                      : Container(height: 0),
                  SizedBox(height: 10),
                  Container(
                      padding: EdgeInsets.all(30),
                      child: AutoSizeText(
                        questionString(),
                        style: Theme.TextStyles.subheadingLight,
                        textAlign: TextAlign.left,
                        maxLines: 6,
                      )),
                  FlatButton(
                      child: Text("Next"),
                      color: Theme.Colors.mustard,
                      onPressed: () {
                        if (openQuestions.length == (index + 1)) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      mcQuestion(date, partner, 0)));
                        } else {
                          (Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      OpenQuestion(date, partner, index + 1))));
                        }
                      }),
                ],
              ),
            )),
      )
    ]);
  }

  _navigateTo(context, String id) {
    Routes.navigateTo(context, '/questions/${date.id}',
        transition: TransitionType.fadeIn);
  }

  String questionString() {
    final a = openQuestions[index];
    List<String> b = a.split("}")[0].split("");
    var c = List<String>.from(b);
    c.removeAt(0);
    return b.join("");
  }
}
// Text(
//               "Question",
//               style: Theme.TextStyles.subheadingLight,
//               ),
