import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/models/Date.dart';
import 'package:cool_date_night/ui/date_questions/MCQuestionBody.dart';
import 'package:cool_date_night/ui/home/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;

class McQuestion extends StatelessWidget {
  final List questionList;
  final String uid;
  final String partnerUid;
  final int index;
  final int challenged;

  final Category category;

  McQuestion(this.questionList, this.uid, this.partnerUid, this.category,
      this.challenged, this.index);
//    DetailScreen({Key key, @required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.cancel,
                ),
                onPressed: () => {
                      Future.delayed(Duration.zero, () {
                        Navigator.popUntil(context, (Route<dynamic> route) {
                          bool shouldPop = false;
                          if (route.settings.name == HomePage.routeName) {
                            shouldPop = true;
                          }
                          return shouldPop;
                        });
                      })
                    })
          ],
          backgroundColor: Theme.Colors.midnightBlue,
        ),
        backgroundColor: Theme.Colors.midnightBlue,
        body: SingleChildScrollView(
          child: buildBody(context, questionList, uid, partnerUid, category,
              challenged, index),
        ));
  }
}

@override
Widget buildBody(BuildContext context, List questionList, String uid,
    String partnerUid, Category category, int challenged, index) {
  return StreamBuilder(
    stream:
        Firestore.instance.collection('users').document(partnerUid).snapshots(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      //Update which question the user is on
      //Firestore.instance.collection('users').document();
      if (snapshot.data != null) {
        return MCQuestionBody(
            questionList, uid, snapshot.data, category, challenged, index);
      }
      return Container(color: Theme.Colors.midnightBlue);
    },
  );
}
