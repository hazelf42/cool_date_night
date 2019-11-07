import 'package:auto_size_text/auto_size_text.dart';

import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/helpers/helper.dart';
import 'package:cool_date_night/models/Date.dart' as Date;
import 'package:cool_date_night/ui/date_questions/MCQuestion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;

import 'DateComplete.dart';
import 'OpenQuestion.dart';

class OpenQuestionBody extends StatelessWidget {
  final int index;
  final List questionList;
  final String uid;
  final Map partnerData;
  final Date.Category category;
  final int challenged;
  OpenQuestionBody(this.uid, this.partnerData, this.questionList, this.category,
      this.challenged, this.index);

  @override
  Widget build(BuildContext context) {
    num height = MediaQuery.of(context).size.height;
    num width = MediaQuery.of(context).size.width;
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: height - 72),
      child: Container(
          width: width,
          color: Theme.Colors.midnightBlue,
          child: Container(
            child: Column(
              children: [
                partnerData == null
                    ? Container(
                        width: double.infinity,
                        height: height / 2 - 60,
                        color: Theme.dateColors[category.name],
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 25),
                              AutoSizeText(category.name,
                                  maxLines: 1,
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
                        color: Theme.dateColors[category.name],
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
                                partnerData['name'],
                                style: Theme.TextStyles.dateTitle,
                              ),
                              SizedBox(height: 15),
                              Avatar(
                                  imagePath: partnerData['photo'] ??
                                      "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                  radius: 75,
                                  heroTag: 'datemate'),
                              SizedBox(
                                height: 25,
                              )
                            ])),
                SizedBox(height: 10),
                prefix0.ConstrainedBox(
                    constraints: prefix0.BoxConstraints(
                        maxHeight: height / 2 - 50,
                        minHeight: height / 2 - 110),
                    child: Container(
                        padding: EdgeInsets.only(
                            left: 30, right: 20, top: 20, bottom: 10),
                        child: AutoSizeText(
                          questionString(),
                          style: Theme.TextStyles.subheadingLight,
                          textAlign: TextAlign.left,
                          maxLines: 10,
                        ))),
                Container(
                    margin: EdgeInsets.all(20),
                    child: ButtonTheme(
                        minWidth: 200,
                        child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0)),
                            child: Text("Next"),
                            color: Theme.dateColors[category.name],
                            onPressed: () {
                              if (questionList.length == (index + 1)) {
                                Navigator.push(context, SlideRightRoute(
                                    page: DateCompleteScreen(category, uid)));
                              } else {
                                Navigator.push(context, SlideRightRoute(
                                    page: (questionList[index + 1] is String)
                                        ? OpenQuestion(
                                            questionList,
                                            uid,
                                            partnerData == null
                                                ? null
                                                : partnerData['uid'],
                                            category,
                                            challenged,
                                            index + 1)
                                        : McQuestion(
                                            questionList,
                                            uid,
                                            partnerData == null
                                                ? null
                                                : partnerData['uid'],
                                            category,
                                            challenged,
                                            index + 1)));
                              }
                            }))),
              ],
            ),
          )),
    );
  }

  String questionString() {
    final a = questionList[index];
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
