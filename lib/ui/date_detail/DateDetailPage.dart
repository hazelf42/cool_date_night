import 'package:cool_date_night/models/Date.dart';
import 'package:cool_date_night/ui/date_detail/DateDetailBody.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:flutter/material.dart';

class DateDetailPage extends StatelessWidget {


  final Map userProfile;
  final Category category;
  DateDetailPage(this.userProfile, this.category);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(backgroundColor: Theme.Colors.midnightBlue),
      body: SingleChildScrollView( child:DateDetailBody( userProfile, category))
    );
  }
}
