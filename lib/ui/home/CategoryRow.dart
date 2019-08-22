import 'package:auto_size_text/auto_size_text.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/bloc_helper/helper.dart';
import 'package:cool_date_night/models/Date.dart';
import 'package:cool_date_night/ui/date_detail/CategoryDetailPage.dart';
import 'package:flutter/material.dart';

class CategoryRow extends StatelessWidget {
  final Category category;
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
                    Avatar(
                      radius: 50,
                      imagePath: category.image,
                      heroTag: category.description,
                    ),
                AutoSizeText(
                  " " + category.name ?? '',
                  style: Theme.TextStyles.dateTitle,
                  maxLines: 1,
                ),
              ],
            ),
            SizedBox(height: 10),
            AutoSizeText(category.description ?? '',
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
                  builder: (context) => CategoryDetailPage(userProfile, category))); 
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
