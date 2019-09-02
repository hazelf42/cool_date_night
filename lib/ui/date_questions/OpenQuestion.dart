import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/models/Date.dart';
import 'package:cool_date_night/ui/date_questions/OpenQuestionBody.dart';
import 'package:flutter/material.dart';

class OpenQuestion extends StatelessWidget {

  final List dateList;
  final Map partner;
  final int index; 
  final Category category;

  OpenQuestion(this.dateList, this.partner, this.category, this.index);
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
           buildBody(context, dateList, partner, category, index),
        ],
      )),
    );
  }
}

@override
Widget buildBody(BuildContext context, List dateList, Map partner, Category category, index) {
      return OpenQuestionBody(dateList, partner, category, index);
}
