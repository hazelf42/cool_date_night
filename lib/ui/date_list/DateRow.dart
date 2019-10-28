import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/helpers/helper.dart';
import 'package:cool_date_night/models/Date.dart' as Date;
import 'package:cool_date_night/ui/date_questions/MCQuestion.dart';
import 'package:cool_date_night/ui/date_questions/OpenQuestion.dart';
import 'package:flutter/material.dart';

class DateRow extends StatelessWidget {
  final Date.Date date;
  final BuildContext context;
  final Date.Category category;
  DateRow(this.context, this.date, this.category);


  @override
  Widget build(BuildContext context) {
    final planetCard = Wrap(children: [InkWell(
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
              SizedBox(height: 10, width: double.infinity),
              AutoSizeText(date.description ?? '',
                  style: Theme.TextStyles.bodyLight, maxLines: 2)
            ],
          ),
        ),
      ),
      onTap: () async {
        await MainBloc().getCurrentFirebaseUserData().then((userData) async {
          if (userData.data.data['isPaid'] == null ||
              userData.data.data['isPaid'] == false && category.name != "Free Trial") {
            MainBloc().retrievePurchasesDialog(
                userData: userData.data, context: context);
          } else {
            await Firestore.instance
                .collection('users')
                .document(userData.data.data['date_mate'])
                .get()
                .then((partner) async {
              await MainBloc().randomizeDateQuestions(date).then((dateList) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => (dateList[0] is String)
                            ? OpenQuestion(
                                dateList, partner.data, category, false, 0)
                            : McQuestion(
                                dateList, partner.data, category, false, 0)));
              });
            });
          }
        });
      },
    )]);

    return Container(
      height: 120,
      margin: const EdgeInsets.only(top: 8.0, left: 10, right: 10),
      child: planetCard,
    );
  }
}
