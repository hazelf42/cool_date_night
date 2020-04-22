import 'package:flutter/material.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
class DetailAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Container(
      padding:  EdgeInsets.only(
        top: MediaQuery
          .of(context)
          .padding
          .top
      ),
      child:  Row(
        children: <Widget>[
           BackButton(
            color: Theme.Colors.lightBlue
          ),
        ],
      ),
    );
  }
}
