import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/models/Date.dart';
import 'package:cool_date_night/ui/date_questions/OpenQuestionBody.dart';
import 'package:flutter/material.dart';

class OpenQuestion extends StatelessWidget {

  final Date date;
  final Map partner;
  final int index; 
  final Category category;

  OpenQuestion(this.date, this.partner, this.category, this.index);
//    DetailScreen({Key key, @required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
        icon: Icon(Icons.cancel, ),
        onPressed: () => 
        Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName)),
      )
        ],
        backgroundColor: Theme.Colors.midnightBlue,
      ),
      
      body:  SingleChildScrollView( child: Stack(
        children: <Widget>[
           buildBody(context, date, partner, category, index),
        ],
      )),
    );
  }
}

@override
Widget buildBody(BuildContext context, Date date, Map partner, Category category, index) {
  return StreamBuilder<DocumentSnapshot> (
    stream: Firestore.instance.collection('dates_with_questions').document(date.name).snapshots(),
    builder: (context, snapshots) {
      if (!snapshots.hasData) return LinearProgressIndicator();
      return OpenQuestionBody(snapshots.data.data['open_questions'].reversed.toList(), partner, date, category, index);
   },
  );
}
