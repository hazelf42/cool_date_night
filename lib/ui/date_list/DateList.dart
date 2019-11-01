import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/models/Date.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;

import 'DateRow.dart';

class DateList extends StatelessWidget {
  final Map userData;
  final Category category;
  DateList(this.category, this.userData);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('dates')
          .where('category', isEqualTo: category.name)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _dateList(
            context, userData['uid'], snapshot.data.documents, category);
      },
    );
  }
}

Widget _dateList(BuildContext context, uid, List<DocumentSnapshot> snapshots,
    Category category) {
  snapshots.sort((a, b) => (a.data['num']).compareTo(b.data['num']));
  return Container(
      color: Theme.dateColors[category.name],
      child: ConstrainedBox(
          constraints: prefix0.BoxConstraints(
              minHeight: prefix0.MediaQuery.of(context).size.height / 2),
          child: ListView.builder(
              physics: prefix0.NeverScrollableScrollPhysics(),
              itemCount: snapshots.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return DateRow(context, uid,
                    Date.fromSnapshot(snapshots[index]), category);
              })));
}
