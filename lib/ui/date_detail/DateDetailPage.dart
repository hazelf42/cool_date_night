import 'package:cool_date_night/models/Date.dart';
import 'package:cool_date_night/ui/date_detail/DateDetailBody.dart';
import 'package:cool_date_night/ui/date_detail/DetailAppBar.dart';
import 'package:flutter/material.dart';

class DateDetailPage extends StatelessWidget {

  final Date date;
  final Map userProfile;
  DateDetailPage(this.date, this.userProfile);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:  Stack(
        children: <Widget>[
           DateDetailBody(date, userProfile),
           DetailAppBar(),
        ],
      ),
    );
  }
}
