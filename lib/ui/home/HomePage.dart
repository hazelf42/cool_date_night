import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/bloc_helper/helper.dart';
import 'package:cool_date_night/ui/home/Drawer.dart';
import 'package:cool_date_night/ui/home/GradientAppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'CategoryRow.dart';
import 'PairView.dart';

class HomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: MainBloc().getCurrentFirebaseUserData(),
        builder: (BuildContext context, user) {
          if (user.hasData) {
            return Scaffold(
                appBar: getAppBar("Categories"),
                body: HomePageBody(userData: user),
                drawer: Drawer(child: DrawerScreen(user.data)));
          } else {
            return Scaffold(
                appBar: getAppBar("Categories"),
                body: Container(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                  alignment: Alignment.center,
                ),
                drawer: Drawer(child: DrawerScreen(null)));
          }
        });
  }
}

class HomePageBody extends StatefulWidget {
  final userData;

  const HomePageBody({Key key, this.userData}) : super(key: key);

  @override
  _HomePageBodyState createState() =>
      _HomePageBodyState(userData: userData.data.data);
}

class _HomePageBodyState extends State<HomePageBody> {
  Map userData;
  _HomePageBodyState({this.userData});

  @override
  Widget build(BuildContext context) {
    if (userData != null) {
      if (userData['date_mate_requests'] != null) {
        return MainBloc().showPartnerRequestDialog(
            context: context,
            profileuid: userData['date_mate_requests'],
            uid: userData['uid']);
      }
      return Container(
          // decoration: BoxDecoration(
          //     //image: DecorationImage(
          //   //image: AssetImage("assets/img/bluebackground.png"),
          //   fit: BoxFit.cover,
          // ),
          color: Theme.Colors.darkBlue,
          child: Container(
            child: (userData == null)
                ? Container()
                : Column(children: <Widget>[
                    userData['date_mate'] != null
                        ? Container(
                            child: StreamBuilder(
                                stream: Firestore.instance
                                    .collection('users')
                                    .document(userData['date_mate'])
                                    .snapshots(),
                                builder:
                                    (BuildContext context, dateUserSnapshot) {
                                  if (dateUserSnapshot != null) {
                                    return Card(
                                        color: Theme.Colors.coral,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: dateUserSnapshot
                                                          .hasData
                                                      ? CircleAvatar(
                                                          backgroundImage: NetworkImage(
                                                              dateUserSnapshot
                                                                          .data[
                                                                      'photo'] ??
                                                                  ""),
                                                          radius: 30)
                                                      : Center(
                                                          child:
                                                              CircularProgressIndicator())),
                                              Expanded(
                                                  child: dateUserSnapshot
                                                          .hasData
                                                      ? Column(
                                                          children: <Widget>[
                                                            Text(
                                                                "Your Datemate"),
                                                            Text(
                                                              "Lauren Ipsum",
                                                              style: Theme
                                                                  .TextStyles
                                                                  .dateTitle,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ],
                                                        )
                                                      : Text("")),
                                              IconButton(
                                                  color: Colors.white54,
                                                  onPressed: () async {
                                                    await Firestore.instance
                                                        .collection('users')
                                                        .document(
                                                            userData['uid'])
                                                        .updateData({
                                                      'date_mate': null
                                                    }).then((_) async {
                                                      await Firestore.instance
                                                          .collection('users')
                                                          .document(
                                                              dateUserSnapshot
                                                                  .data['uid'])
                                                          .updateData({
                                                        'date_mate': null
                                                      });
                                                    }).then((_) {
                                                      setState(() {
                                                        userData['date_mate'] =
                                                            null;
                                                      });
                                                    });
                                                  },
                                                  icon: Icon(Icons.cancel))
                                            ]));
                                  } else {
                                    return Container();
                                  }
                                  ;
                                }),
                          )
                        : Container(
                            padding: EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width - 20,
                            height: 50,
                            child: RaisedButton(
                                elevation: 10,
                                color: Theme.Colors.coral,
                                child: Text("FIND YOUR DATEMATE",
                                    style: Theme.TextStyles.subheading2Dark),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PairView()));
                                })),
                    buildBody(context, userData),
                  ]),
          ));
    }
    return Container();
  }
}

Widget _categoryList(
    BuildContext context, List<DocumentSnapshot> snapshots, Map userProfile) {
  return Expanded(child:ListView.builder(
    itemCount: snapshots.length,
    shrinkWrap: true,
    itemBuilder: (context, index) {
      return CategoryRow(context, snapshots[index].data, userProfile);
    },
 ));
}

@override
Widget buildBody(BuildContext context, Map userProfile) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('categories').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      return _categoryList(context, snapshot.data.documents, userProfile);
    },
  );
}

Future<bool> getIsPaired(uid) async {
  await MainBloc().getUser(uid).then((profile) {
    return (profile['datemate'] != null);
  });
}

Future<DocumentSnapshot> getCurrentFirebaseUserData() async {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  return await _firebaseAuth.currentUser().then((user) async {
    return await (Firestore.instance
            .collection("users")
            .document(user.uid)
            .get())
        .then((userData) {
      return userData;
    });
  });
}
