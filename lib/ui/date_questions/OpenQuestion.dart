import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/models/Date.dart';
import 'package:cool_date_night/ui/date_questions/OpenQuestionBody.dart';
import 'package:cool_date_night/ui/home/HomePage.dart';
import 'package:flutter/material.dart';

class OpenQuestion extends StatelessWidget {
  final List questionList;
  final Map partner;
  final int index;
  final Category category;
  final bool challenged;
  OpenQuestion(this.questionList, this.partner, this.category, this.challenged,
      this.index);
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
              onPressed: () => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage())))
        ],
        backgroundColor: Theme.Colors.midnightBlue,
      ),
      body: SingleChildScrollView(
          child: Stack(
        children: <Widget>[
          buildBody(
              context, questionList, partner, category, challenged, index),
        ],
      )),
    );
  }
}

@override
Widget buildBody(BuildContext context, List questionList, Map partner,
    Category category, bool challenged, index) {
  return OpenQuestionBody(partner, questionList, category, challenged, index);
}
