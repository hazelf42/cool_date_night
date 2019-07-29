import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class DateRow extends StatelessWidget {
  final Map date;
  final BuildContext context;

  DateRow(this.context, this.date);

  @override
  Widget build(BuildContext context) {
    final planetThumbnail = Container(
        alignment: FractionalOffset(-.01, 0.5),
       );
    final planetCard = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Theme.Colors.midnightBlue,
      elevation: 16.0,
      child: Container(
        margin: const EdgeInsets.only(top: 30.0, left: 30.0),
        padding: EdgeInsets.only(top: 0, right: 10, bottom: 10),
        constraints: BoxConstraints.expand(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AutoSizeText(
              date['name'] ?? '',
              style: Theme.TextStyles.dateTitle,
              maxLines: 1,
            ),
            SizedBox(height: 5),
            AutoSizeText(date['description'] ?? '',
                style: Theme.TextStyles.bodyLight, maxLines: 4)
          ],
        ),
      ),
    );

    return Container(
      height: 125.0,
      margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: FlatButton(
        onPressed: () {
//           Navigator.push(
//         context,
//         MaterialPageRoute(
//           //TODO: Date List
// //            builder: (context) => DateDetailPage(date, userProfile)));
        },
        child: Stack(
          children: <Widget>[
            planetCard,
            planetThumbnail,
          ],
        ),
      ),
    );
  }
}
