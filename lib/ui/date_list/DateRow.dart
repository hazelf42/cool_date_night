import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/bloc_helper/helper.dart';
import 'package:cool_date_night/models/Date.dart' as Date;
import 'package:cool_date_night/ui/date_questions/OpenQuestion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:rxdart/rxdart.dart';

class DateRow extends StatelessWidget {
  final Date.Date date;
  final BuildContext context;
  final Date.Category category;
  DateRow(this.context, this.date, this.category);

  final _isLoading = BehaviorSubject<bool>();
  Stream<bool> get isLoading => _isLoading.stream;

  @override
  Widget build(BuildContext context) {
    _isLoading.add(false);
    final planetCard = InkWell(
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        color: Theme.Colors.midnightBlue,
        elevation: 16.0,
        child: Container(
          margin: const EdgeInsets.only(top: 10.0, left: 30.0),
          padding: EdgeInsets.only(top: 0, right: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AutoSizeText(
                date.name ?? '',
                style: Theme.TextStyles.dateTitleSmall,
                maxLines: 1,
              ),
              SizedBox(height: 10),
              AutoSizeText(date.description ?? '',
                  style: Theme.TextStyles.bodyLight, maxLines: 4)
            ],
          ),
        ),
      ),
      onTap: () async {
        await MainBloc().getCurrentFirebaseUserData().then((userData) async {
          if (userData.data.data['isPaid'] == null ||
              userData.data.data['isPaid'] == false) {
            prefix0.showDialog(
                context: context,
                builder: (context) {
                  return StreamBuilder(
                      stream: _isLoading,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                       return _notPaidPopup(userData: userData);
                      });
                });
            //     },
            //    );
          } else {
            await Firestore.instance
                .collection('users')
                .document(userData.data.data['date_mate'])
                .get()
                .then((partner) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          OpenQuestion(date, partner.data, category, 0)));
            });
          }
        });
      },
    );

    return Container(
      height: 120,
      margin: const EdgeInsets.only(top: 8.0, left: 10, right: 10),
      child: planetCard,
    );
  }

  Widget _notPaidPopup({@required UserData userData}) {
    return AlertDialog(
      actions: <Widget>[
        _isLoading.value
            ? CircularProgressIndicator()
            : FlatButton(
                child: Text("Unlock All".toUpperCase(), style: Theme.TextStyles.subheading2Mustard),
                onPressed: () {
                  _isLoading.add(true);
                  Future.delayed(const Duration(seconds: 1)).then((_) {
                    Firestore.instance
                        .collection("users")
                        .document(userData.firebaseUser.uid)
                        .updateData({'isPaid': true});
                    userData.data.data['isPaid'] = true;
                    _isLoading.add(false);
                    Navigator.of(context).pop();
                  });
                },
              ), 
              FlatButton(
                child: Text("CANCEL", style: Theme.TextStyles.subheading2Light),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
      ],
      title: Text("Unlock All Dates?", textAlign: prefix0.TextAlign.center, style: TextStyle(color: Colors.white),),
      backgroundColor: Theme.Colors.darkBlue,
    );
  }
}
