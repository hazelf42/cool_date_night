import 'package:flutter/material.dart';
import 'package:cool_date_night/models/Date.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_date_night/ui/date_detail/DetailAppBar.dart';
import 'package:cool_date_night/ui/date_questions/OpenQuestionBody.dart';

class OpenQuestion extends StatelessWidget {

  final Date date;
  final Map partner;
  final int index; 

  OpenQuestion(this.date, this.partner, this.index);
//    DetailScreen({Key key, @required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:  SingleChildScrollView( child: Stack(
        children: <Widget>[
           buildBody(context, date, partner, index),
           //OpenQuestionBody(date, index),
           DetailAppBar(),
        ],
      )),
    );
  }
}

@override
Widget buildBody(BuildContext context, Date date, Map partner, index) {
  return StreamBuilder<DocumentSnapshot> (
    stream: Firestore.instance.collection('dates_with_questions').document(date.name).snapshots(),
    builder: (context, snapshots) {
      if (!snapshots.hasData) return LinearProgressIndicator();
      return OpenQuestionBody(snapshots.data.data['open_questions'], partner, date, index);
   },
  );
}
