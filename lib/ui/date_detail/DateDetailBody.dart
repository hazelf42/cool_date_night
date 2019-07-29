import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/models/Date.dart';
import 'package:cool_date_night/ui/date_questions/OpenQuestion.dart';
import 'package:cool_date_night/ui/home/PairView.dart';
import 'package:flutter/material.dart';

class DateDetailBody extends StatefulWidget {
  final Date date;
  final Map userProfile;
  DateDetailBody(this.date, this.userProfile);

  _DateDetailBody createState() => _DateDetailBody(this.date, this.userProfile);
}

class _DateDetailBody extends State<DateDetailBody> {
  final Date date;
  Map userProfile;

  _DateDetailBody(this.date, this.userProfile);
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: userProfile["date_mate"] != null ? Firestore()
            .collection('users')
            .document(userProfile["date_mate"])
            .snapshots() : null,
        builder: (context, snapshot) {
          return Stack(children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/img/bluegradient.png"),
                      fit: BoxFit.cover)),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 50),
                  Container(
                      width: MediaQuery.of(context).size.width - 30,
                      child: Column(
                        children: <Widget>[
                          Hero(
                            child: Image(
                                image: NetworkImage(date.image),
                                height: 150,
                                width: 150),
                            tag: 'date-icon-${date.id}',
                          ),
                          SizedBox(height: 30),
                          Text(
                            date.name,
                            style: Theme.TextStyles.subheadingLight,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            date.description,
                            textAlign: TextAlign.center,
                            style: Theme.TextStyles.subheadingLight,
                          ),
                          SizedBox(height: 30),
                        ],
                      )),
                  userProfile['date_mate'] == null
                      ? Column(
                          children: <Widget>[
                            Text("Dates are better together."),
                            FlatButton(
                                child: Text("Pair with your Date Mate"),
                                color: Theme.Colors.mustard,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PairView()));
                                }),
                          ],
                        )
                      : FlatButton(
                          child: Text("GO"),
                          color: Theme.Colors.mustard,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OpenQuestion(date, snapshot.data.data, 0)));
                          },
                        )
                ],
              ),
            )
          ]);
        });
  }
}

// Text(
//               "Question",
//               style: Theme.TextStyles.subheadingLight,
//               ),

// Card(
//   margin: EdgeInsets.only(left: 10, right: 10),
//   child: Padding(
//     padding: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
//     child: Row(
//       children: <Widget>[
//         CircleAvatar(
//           radius: 60,
//           backgroundImage:
//               AssetImage("assets/img/lauren.png"),
//         ),
//         SizedBox(width: 40),
//         Text("Lauren Ipsum", style: TextStyle(color: Colors.black, fontSize: 24), )

//       ],
//     ),
//   ))
