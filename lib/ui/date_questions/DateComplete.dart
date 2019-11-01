import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/helpers/helper.dart';
import 'package:cool_date_night/models/Date.dart';
import 'package:cool_date_night/ui/home/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;

class DateCompleteScreen extends StatelessWidget {
  final Category category;
  final String uid;
  DateCompleteScreen(this.category, this.uid);
  @override
  Widget build(BuildContext context) {
    var height = prefix0.MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: Firestore.instance.collection('users').document(uid).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data['completed_dates'] == null) {
            //TODO: - this shows completed categories NOT dates. Fix this in next udpate.
            Firestore.instance.collection('users').document(uid).updateData({
              "completed_dates": [category.name]
            });
          } else if (snapshot.hasData) {
            var completedDates =
                new List<String>.from(snapshot.data['completed_dates']);
            completedDates.add(category.name);
            Firestore.instance
                .collection('users')
                .document(uid)
                .updateData({"completed_dates": completedDates});
          }
          return Scaffold(
              body: Container(
            width: prefix0.MediaQuery.of(context).size.width,
            color: Theme.dateColors[category.name],
            padding: EdgeInsets.symmetric(vertical: 75, horizontal: 50),
            child: Card(
              elevation: 5,
              child: Container(
                padding: prefix0.EdgeInsets.all(10),
                color: Theme.Colors.midnightBlue,
                child: Column(
                  children: <Widget>[
                    prefix0.SizedBox(height: height / 20),
                    Avatar(
                        imagePath: category.image,
                        radius: 75,
                        heroTag: 'category'),
                    prefix0.SizedBox(height: height / 20),
                    Text("Date Complete!", style: Theme.TextStyles.dateTitle),
                    prefix0.SizedBox(height: height / 30),
                    Text("Snap a selfie to celebrate!",
                        textAlign: prefix0.TextAlign.center,
                        style: Theme.TextStyles.subheading2Light),
                    Text("Then tag us with #cooldatenight!",
                        textAlign: prefix0.TextAlign.center,
                        style: Theme.TextStyles.bodyLight),
                    prefix0.SizedBox(height: height / 30),
                    prefix0.FlatButton(
                      color: Theme.dateColors[category.name],
                      child:
                          Text("Done", style: TextStyle(color: Colors.black87)),
                      onPressed: () {
                        Navigator.popUntil(context, (Route<dynamic> route) {
                          bool shouldPop = false;
                          if (route.settings.name == HomePage.routeName) {
                            shouldPop = true;
                          }
                          return shouldPop;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          ));
        });
  }

  //Image?

  showPicDialog() {}
}
