import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/bloc_helper/helper.dart';
import 'package:cool_date_night/models/Date.dart';
import 'package:cool_date_night/ui/date_list/DateList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class CategoryDetailBody extends StatefulWidget {
  final Map userProfile;
  final Category category;
  CategoryDetailBody(this.userProfile, this.category);

  _CategoryDetailBody createState() =>
      _CategoryDetailBody(this.userProfile, this.category);
}

class _CategoryDetailBody extends State<CategoryDetailBody> {
  Map userProfile;
  final Category category;
  StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  void initState() {
    print("Initstate");
    final Stream purchaseUpdates =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdates.listen((purchases) {
      print(purchases[0].productID);
      if (purchases.length > 0) {
        print(purchases.length);
        Firestore.instance
            .collection('users')
            .document(userProfile['uid'])
            .updateData({'isPaid': true});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  _CategoryDetailBody(this.userProfile, this.category);
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore()
            .collection('users')
            .document(userProfile['uid'])
            .snapshots(),
        builder: (context, userMap) {
          if (userMap.hasData) {
            return Stack(children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                color: Theme.Colors.midnightBlue,
                child: Column(
                  children: <Widget>[
                    ConstrainedBox(
                        constraints: prefix0.BoxConstraints(
                            minHeight:
                                prefix0.MediaQuery.of(context).size.height / 2),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: <Widget>[
                                prefix0.SizedBox(height: 30),
                                ClipOval(
                                    child: Container(
                                        child: Avatar(
                                  heroTag: category.name,
                                  imagePath: category.image,
                                  radius: 70,
                                ))),
                                SizedBox(height: 20),
                                AutoSizeText(
                                  category.name,
                                  textScaleFactor: 1,
                                  style: Theme.TextStyles.dateTitle,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: Text(
                                      category.longDescription,
                                      textAlign: TextAlign.justify,
                                      style: Theme.TextStyles.bodyLight,
                                    )),
                                SizedBox(height: 10),
                              ],
                            ))),
                    // userProfile.data['date_mate'] == null
                    //     ? Column(
                    //         children: <Widget>[
                    //           Text("Dates are better together.",
                    //               style: Theme.TextStyles.subheading2Light),
                    //           FlatButton(
                    //               child: Text("Pair with your Date Mate"),
                    //               color: Theme.Colors.mustard,
                    //               onPressed: () {
                    //                 Navigator.push(
                    //                     context,
                    //                     MaterialPageRoute(
                    //                         builder: (context) => PairView()));
                    //               }),
                    //         ],
                    //       )
                    //     : FlatButton(
                    //         child: Text("GO"),
                    //         color: Theme.Colors.mustard,
                    //         onPressed: () {
                    //           Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => OpenQuestion(date,
                    //                       userProfile.data.data, category, 0)));
                    //         },
                    //       ),
                    DateList(category, userMap.data.data)
                  ],
                ),
              )
            ]);
          }
        });
  }
}
