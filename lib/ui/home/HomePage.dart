import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/helpers/helper.dart';
import 'package:cool_date_night/ui/home/Drawer.dart';
import 'package:cool_date_night/ui/home/GradientAppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cool_date_night/models/Date.dart';
import 'CategoryRow.dart';
import 'PairView.dart';

class HomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> user) {
          if (user.hasData) {
            return Scaffold(
                appBar: getAppBar("Categories"),
                body: HomePageBody(user: user.data),
                drawer: Drawer(child: DrawerScreen()));
          } else {
            return Scaffold(
                appBar: getAppBar("Categories"),
                body: Container(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                  alignment: Alignment.center,
                  color: Theme.Colors.midnightBlue
                ),
                drawer: Drawer(child: DrawerScreen()));
          }
        });
  }
}

class HomePageBody extends StatefulWidget {
  final FirebaseUser user;
  const HomePageBody({Key key, this.user}) : super(key: key);

  @override
  _HomePageBodyState createState() => _HomePageBodyState(user: user);
}

class _HomePageBodyState extends State<HomePageBody> {
  FirebaseUser user;
  _HomePageBodyState({this.user});

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Container();
    }
    return StreamBuilder(
        stream: Firestore.instance
            .collection("users")
            .document(user.uid)
            .snapshots(),
        builder: (BuildContext context, userData) {
          if (userData.hasData) {
            if (userData.data['date_mate_requests'] != null) {
              return MainBloc().showPartnerRequestDialog(
                  context: context,
                  profileuid: userData.data['date_mate_requests'],
                  uid: user.uid);
            }
            return Container(
                color: Theme.Colors.darkBlue,
                child: Container(
                  child: (userData == null)
                      ? Container()
                      : Column(children: <Widget>[
                          userData.data['date_mate'] != null
                              ? Container(
                                  child: StreamBuilder(
                                      stream: Firestore.instance
                                          .collection('users')
                                          .document(userData.data['date_mate'])
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          dateUserSnapshot) {
                                        if (dateUserSnapshot != null) {
                                          return Card(
                                              color: Theme.Colors.coral,
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: <Widget>[
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: dateUserSnapshot
                                                                .hasData
                                                            ? Avatar(
                                                                imagePath:
                                                                        dateUserSnapshot.data['photo'] ??
                                                                            "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                                                radius: 60,
                                                              )
                                                            : Center(
                                                                child:
                                                                    CircularProgressIndicator())),
                                                    Expanded(
                                                        child:
                                                            dateUserSnapshot
                                                                    .hasData
                                                                ? Column(
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                          "Your Datemate"),
                                                                      Text(
                                                                        dateUserSnapshot
                                                                            .data['name'],
                                                                        style: Theme
                                                                            .TextStyles
                                                                            .dateTitle,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Text("")),
                                                    IconButton(
                                                        color: Colors.white54,
                                                        onPressed: () async {
                                                          await Firestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .document(userData
                                                                  .data['uid'])
                                                              .updateData({
                                                            'date_mate': null
                                                          }).then((_) async {
                                                            await Firestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .document(
                                                                    dateUserSnapshot
                                                                            .data[
                                                                        'uid'])
                                                                .updateData({
                                                              'date_mate': null
                                                            });
                                                          }).then((_) {
                                                            setState(() {
                                                              userData.data[
                                                                      'date_mate'] =
                                                                  null;
                                                            });
                                                          });
                                                        },
                                                        icon:
                                                            Icon(Icons.cancel))
                                                  ]));
                                        } else {
                                          return Container();
                                        }
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
                                          style:
                                              Theme.TextStyles.subheading2Dark),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PairView(user.uid)));
                                      })),
                          buildBody(context, userData.data),
                        ]),
                ));
          }
          return Container();
        });
  }
}

Widget _categoryList(
    BuildContext context, List<DocumentSnapshot> snapshots, Map userProfile) {
      snapshots.sort((a, b) => (int.parse(a['num'])).compareTo((int.parse(b['num']))));
  return Expanded(
      child: ListView.builder(
    itemCount: snapshots.length,
    shrinkWrap: true,
    itemBuilder: (context, index) {
      return CategoryRow(context, Category.fromSnapshot(snapshots[index]), userProfile);
    },
  ));
}
@override
Widget buildBody(BuildContext context, DocumentSnapshot userProfile) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('categories').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      return _categoryList(context, snapshot.data.documents, userProfile.data);
    },
  );
}

Future<bool> getIsPaired(uid) async {
  return await MainBloc().getUser(uid).then((profile) {
    return (profile['datemate'] != null);
  });
}
