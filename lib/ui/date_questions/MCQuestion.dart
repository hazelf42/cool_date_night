import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/models/Date.dart';
import 'package:cool_date_night/ui/date_questions/MCQuestionBody.dart';
import 'package:flutter/material.dart';
class McQuestion extends StatelessWidget {
  final List questionList;
  final Map partner;
  final int index;
  final bool challenged;

  final Category category;

  McQuestion(this.questionList, this.partner, this.category, this.challenged, this.index);
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
          child: buildBody(context, questionList, partner, category, challenged, index),
      )
    );
  }
}

@override
Widget buildBody(
    BuildContext context, List questionList, Map partner, Category category, bool challenged, index) {
 
      return MCQuestionBody(
          questionList, questionList, partner, category, challenged, index);

}