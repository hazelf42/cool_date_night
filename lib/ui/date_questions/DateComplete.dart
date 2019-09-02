import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/bloc_helper/helper.dart';
import 'package:cool_date_night/models/Date.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;

class DateCompleteScreen extends StatelessWidget {
  final Category category;
  DateCompleteScreen(this.category);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: prefix0.MediaQuery.of(context).size.width,
      color: Theme.dateColors[category],
      padding: EdgeInsets.symmetric(vertical: 75, horizontal: 50),
      child: Container(
        child: Card(
          elevation: 5,
          color: Theme.Colors.midnightBlue,
          child: Column(
            children: <Widget>[
              prefix0.SizedBox(height: 120),
              Avatar(
                  imagePath: category.image, radius: 75, heroTag: 'category'),
              prefix0.SizedBox(height: 50),
              Text("Date Complete!", style: Theme.TextStyles.dateTitle),
              prefix0.SizedBox(height: 75),
              prefix0.FlatButton(
                  color: Theme.dateColors[category.name],
                child: Text("BACK TO " + category.name.toUpperCase(),
                    style: Theme.TextStyles.subheading2Light),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              )
            ],
          ),
        ),
      ),
    ));
  }
}
