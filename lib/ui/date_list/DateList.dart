import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cool_date_night/ui/home/GradientAppBar.dart';
import 'package:cool_date_night/ui/home/Drawer.dart';
import 'package:cool_date_night/bloc_helper/helper.dart';

import 'DateRow.dart';

class DateList extends StatelessWidget {
  final String categorySelected;
  final Map userData; 
  DateList(this.categorySelected, this.userData);
//    DetailScreen({Key key, @required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar("Categories"),
        body: 
        (userData['date_mate_requests'] != null) ?
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
        ),
        drawer: Drawer(child: DrawerScreen()));
    ;
  }
}

Widget _dateList(BuildContext context, List<DocumentSnapshot> snapshots) {
  return Container(
      child: ListView(
    shrinkWrap: true,
    children: snapshots.map((data) => DateRow(context, data.data)).toList(),
  ));
}
