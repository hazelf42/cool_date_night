import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/models/Date.dart';
import 'package:cool_date_night/ui/date_questions/MCQuestionBody.dart';
import 'package:flutter/material.dart';

class McQuestion extends StatelessWidget {
  final List dateList;
  final Map partner;
  final int index;

  final Category category;

  McQuestion(this.dateList, this.partner, this.category, this.index);
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
              onPressed: () => Navigator.popUntil(
                  context, ModalRoute.withName(Navigator.defaultRouteName)),
            )
          ],
          backgroundColor: Theme.Colors.midnightBlue,
        ),
        backgroundColor: Theme.Colors.midnightBlue,
        body: SingleChildScrollView(
          child: buildBody(context, dateList, partner, category, index),
        ));
  }

  Widget buildBody(BuildContext context, List dateList, Map partner,
      Category category, index) {
    return MCQuestionBody(dateList, partner, category, index);
  }
}
