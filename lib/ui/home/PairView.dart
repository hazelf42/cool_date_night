import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/helpers/helper.dart';
import 'package:cool_date_night/models/Profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;

import 'GradientAppBar.dart';

class ProfileRow extends StatelessWidget {
  final Profile profile;
  ProfileRow(this.profile);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      color: Theme.Colors.darkBlue,
      elevation: 10,
      child: Container(
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 20),
            Avatar(
              imagePath: profile.photo,
              radius: 25,
            ),
            SizedBox(width: 20),
            Text(profile.name, style: Theme.TextStyles.subheadingLight)
          ],
        ),
      ),
    );
  }
}

class PairView extends StatefulWidget {
  final uid;
  @override
  PairView(this.uid);
  _PairViewState createState() => _PairViewState(this.uid);
}

class _PairViewState extends State<PairView> {
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List filteredNames = new List();
  final uid;

  _PairViewState(this.uid) {
    _filter.addListener(() {
      if (_filter.text.isNotEmpty && _filter.text.length > 3) {
        _searchText = _filter.text;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            Firestore.instance.collection("users").document(uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['date_mate_requests'] != null) {
              return MainBloc().showPartnerRequestDialog(
                  context: context,
                  profileuid: snapshot.data['date_mate_requests'],
                  uid: uid);
            }
          }
          return Scaffold(
              backgroundColor: Colors.grey,
              appBar: getAppBar("Pairing"),
              body: Column(children: [
                Container(
                    color: Theme.Colors.darkBlue,
                    child: TextField(
                      controller: _filter,
                      style: Theme.TextStyles.subheading2Light,
                      decoration: InputDecoration(
                          hintStyle: Theme.TextStyles.subheading2Light,
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                          hintText: "Search by name"),
                    )),
                (_searchText.length <= 3)
                    ? Container(
                        padding: EdgeInsets.all(20),
                        alignment: Alignment.center,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10),
                            Container(
                              child: Image(
                                  image: AssetImage(
                                      'assets/img/magnifier-with-a-heart.png')),
                              width: 50,
                              height: 50,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Find your Date Mate",
                              style: Theme.TextStyles.subheading2Dark,
                            )
                          ],
                        ),
                      )
                    : _buildList()
              ]));
        });
  }

  Widget _buildList() {
    if (_searchText != "") {
      List tempList = new List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]
            .name
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;

      //TODO: - WARNING: This is NOT SCALABLE. Pay for Algolia and do string querying.
      final alpha = 'abcdefghijklmnopqrstuvwxyz'.split('');

      return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .orderBy('lower_name')
            .startAt([_searchText.toLowerCase()])
            .endAt(( //The next letter of the alphabet
                [alpha[(alpha.indexOf(_searchText.toLowerCase()[0])) + 1]]))
            .snapshots(),
        builder: (
          BuildContext context,
          snapshot,
        ) {
          if (snapshot.hasData) {
            print(snapshot.data.documents.length);
          }
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          if (snapshot.data.documents.length == 0 && _searchText.length >= 3) {
            return Column(
              children: <Widget>[
                Container(
                  child:
                      Image(image: AssetImage('assets/img/broken-heart.png')),
                  width: 50,
                  height: 50,
                ),
                SizedBox(height: 10),
                Text("No results found.")
              ],
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              if (snapshot.hasData) {
                print("Email " + snapshot.data.documents[index].data['email']);
                return Card(
                    color: Theme.Colors.midnightBlue,
                    child: FlatButton(
                        child: Container(
                            height: 70,
                            child: Row(
                              children: <Widget>[
                                Avatar(
                                    heroTag: snapshot
                                        .data.documents[index].data['uid'],
                                    radius: 60,
                                    imagePath: snapshot.hasData
                                        ? snapshot.data.documents[index]
                                                .data['photo'] ??
                                            "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png"
                                        : "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png"),
                                SizedBox(width: 30),
                                Text(
                                    snapshot.data.documents[index].data['name'],
                                    style: Theme.TextStyles.dateTitle)
                              ],
                            )),
                        onPressed: (() async {
                          await showPartnerDialog(
                                  partnerProfile:
                                      snapshot.data.documents[index].data,
                                  currentProfileUid: uid,
                                  context: context)
                              .then((_) {
                            Firestore.instance
                                .collection('users')
                                .document(uid)
                                .updateData({'requesting': false});
                          });
                        })));
              } else {
                return Text(
                    "No profiles found, try double checking your spelling and internet connection.");
              }
            },
          );
        },
      );
    }
    return prefix0.Container();
  }

  Future<Widget> showPartnerDialog({
    @required BuildContext context,
    @required Map partnerProfile,
    @required String currentProfileUid,
    bool isLoading = false,
  }) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return StreamBuilder(
                stream: Firestore.instance
                    .collection('users')
                    .document(currentProfileUid)
                    .snapshots(),
                builder: (context, snapshot) {
                  return AlertDialog(
                    backgroundColor: Theme.Colors.darkBlue,
                    title: (snapshot.data['date_mate'] != null &&
                            snapshot.data['date_mate'] == partnerProfile['uid'])
                        ? Text("Request Accepted!",
                            style: TextStyle(color: Colors.white))
                        : Text("Request Date Mate",
                            style: TextStyle(color: Colors.white)),
                    content: Container(
                      height: 141,
                      child: Column(
                        children: <Widget>[
                          Container(
                              color: Theme.Colors.darkBlue,
                              padding: EdgeInsets.all(15),
                              child: Avatar(
                                imagePath: partnerProfile['photo'] ??
                                    "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                radius: 66,
                                heroTag: partnerProfile['uid'],
                              )),
                          Container(
                              width: MediaQuery.of(context).size.width - 50,
                              padding: EdgeInsets.only(bottom: 10),
                              child: Center(
                                  child: Text(partnerProfile['name'],
                                      style: TextStyle(
                                          fontSize: 21, color: Colors.white)))),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      (snapshot.hasData &&
                              snapshot.data['date_mate_requests'] == null &&
                              snapshot.data['requesting'] != true)
                          ? FlatButton(
                              color: Colors.white.withOpacity(.30),
                              child: Text("REQUEST",
                                  style: Theme.TextStyles.subheading2Light),
                              onPressed: () {
                                Firestore.instance
                                    .collection('users')
                                    .document(partnerProfile['uid'])
                                    .updateData({
                                  'date_mate_requests': currentProfileUid
                                });
                                Firestore.instance
                                    .collection('users')
                                    .document(currentProfileUid)
                                    .updateData({'requesting': true});

                                setState(() {});
                              },
                            )
                          : (snapshot.data['date_mate'] != null &&
                                  snapshot.data['date_mate'] ==
                                      partnerProfile['uid'])
                              ? FlatButton(
                                  color: Colors.white.withOpacity(.30),
                                  child: Text("GO",
                                      style: Theme.TextStyles.subheading2Light),
                                  onPressed: () {
                                    Firestore.instance
                                        .collection('users')
                                        .document(currentProfileUid)
                                        .updateData({'requesting': false});
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  })
                              : CircularProgressIndicator(),
                      FlatButton(
                        color: Colors.white.withOpacity(.30),
                        child: Text("Cancel",
                            style: Theme.TextStyles.subheading2Light),
                        onPressed: () {
                          Firestore.instance
                              .collection('users')
                              .document(partnerProfile['uid'])
                              .updateData({'date_mate_requests': null});

                          Firestore.instance
                              .collection('users')
                              .document(currentProfileUid)
                              .updateData({'requesting': false});
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                });
          });
        });
  }
}
