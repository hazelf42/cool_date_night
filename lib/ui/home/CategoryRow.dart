import 'package:auto_size_text/auto_size_text.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/ui/date_list/DateList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;

class CategoryRow extends StatelessWidget {
  final Map category;
  final BuildContext context;
  final Map userProfile;

  CategoryRow(this.context, this.category, this.userProfile);
  @override
  Widget build(BuildContext context) {
    final planetCard = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Theme.Colors.midnightBlue,
      elevation: 16.0,  
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                    child: Hero(
                        tag: 'date-icon-${category['name']}',
                        child: Container(
                            child: CircleAvatar(
                              backgroundImage: AssetImage(
                                //Set the name of the asset image as the first word of the category
                                "assets/img/${category['name'].split(" ")[0].toLowerCase()}.png",
                              ),
                              backgroundColor: Colors.transparent,
                              //radius: 30,
                            ),
                            // height: 50,
                            // width: 60,
//                padding: prefix0.EdgeInsets.only(left: 5, right: 5),
                            decoration: new BoxDecoration(
                              color: const Color(0xF152229), // border color
                              shape: BoxShape.circle,
                            )))),
                AutoSizeText(
                  " " + category['name'] ?? '',
                  style: Theme.TextStyles.dateTitle,
                  maxLines: 1,
                ),
              ],
            ),
            SizedBox(height: 10),
            AutoSizeText(category['description'] ?? '',
                style: Theme.TextStyles.bodyLight, maxLines: 4)
          ],
        ),
      ),
    );

    return Container(
      // height: 125.0,
      //  margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: FlatButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DateList(category['name'], userProfile)));
        },
        child: Stack(
          children: <Widget>[
            planetCard,
          ],
        ),
      ),
    );
  }
}
