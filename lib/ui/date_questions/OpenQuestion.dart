import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/models/Date.dart';
import 'package:cool_date_night/ui/date_questions/OpenQuestionBody.dart';
import 'package:cool_date_night/ui/home/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;

class OpenQuestion extends StatelessWidget {
  final List questionList;
  final String uid;
  final String partnerUid;
  final int index;
  final Category category;
  final int challenged;
  OpenQuestion(this.questionList, this.uid, this.partnerUid, this.category,
      this.challenged, this.index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.cancel,
              ),
              onPressed: () {
                Future.delayed(Duration(milliseconds: 50), () {
                  Navigator.popUntil(context, ModalRoute.withName('/home'));
                });
              })
        ],
        backgroundColor: Theme.Colors.midnightBlue,
      ),
      body: Container(
          color: Theme.Colors.midnightBlue,
          child: SingleChildScrollView(
              child: Stack(
            children: <Widget>[
              buildBody(context, questionList, uid, partnerUid, category,
                  challenged, index),
            ],
          ))),
    );
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
      // Firestore.instance.collection('users').document();
      if (snapshot.data != null) {
        return OpenQuestionBody(
            uid, snapshot.data.data, questionList, category, challenged, index);
      }
      return Container(
          color: Theme.Colors.midnightBlue,
          height: prefix0.MediaQuery.of(context).size.height,
          width: prefix0.MediaQuery.of(context).size.height);
    },
  );
}
