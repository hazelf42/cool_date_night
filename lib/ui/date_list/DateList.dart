import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/bloc_helper/helper.dart';
import 'package:cool_date_night/models/Date.dart';
import 'package:cool_date_night/ui/home/GradientAppBar.dart';
import 'package:flutter/material.dart';

import 'DateRow.dart';

class DateList extends StatelessWidget {
  final String categorySelected;
  final Map userData; 
  DateList(this.categorySelected, this.userData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Theme.Colors.darkBlue,
        appBar: getAppBar(categorySelected),
        body: 
        (userData['date_mate_requests']  != null) ?
         MainBloc().showPartnerRequestDialog(
            context: context,
            profileuid: userData['date_mate_requests'],
            uid: userData['uid']) : 
      
        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('dates')
              .where('category', isEqualTo: categorySelected)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            return _dateList(context, snapshot.data.documents);
          },
        ),);
  }
}

Widget _dateList(BuildContext context, List<DocumentSnapshot> snapshots) {
  return Container(
      child: ListView(
    shrinkWrap: true,
    children: snapshots.map((data) => DateRow(context, Date.fromSnapshot(data))).toList(),
  ));
}
