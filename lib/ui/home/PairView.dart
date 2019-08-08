import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/bloc_helper/helper.dart';
import 'package:cool_date_night/models/Profile.dart';
import 'package:flutter/material.dart';

import 'GradientAppBar.dart';

class ProfileRow extends StatelessWidget {
  final Profile profile;
  ProfileRow(this.profile);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      color: Theme.Colors.midnightBlue,
      elevation: 10,
      child: Container(
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 20),
            CircleAvatar(
              backgroundImage: NetworkImage(profile.photo),
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
  @override
  _PairViewState createState() => _PairViewState();
}

class _PairViewState extends State<PairView> {
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List filteredNames = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.Colors.lightBlue,
        appBar: getAppBar("Pairing"),
        body: Column(children: [
          Container(
              child: TextField(
            controller: _filter,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: "Search by name"),
          )),
          (_searchText.length <= 3)
              ? Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Image(
                            image: AssetImage(
                                'assets/img/magnifier-with-a-heart.png')),
                        width: 50,
                        height: 50,
                      ),
                      SizedBox(height: 10),
                      Text("Find your Date Mate")
                    ],
                  ),
                )
              : _buildList()
        ]));
  }

  _PairViewState() {
    _filter.addListener(() {
      if (_filter.text.isNotEmpty && _filter.text.length > 3) {
        _searchText = _filter.text;
        print(_searchText);
        setState(() {});
      }
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
      return FutureBuilder(
          future: MainBloc().getCurrentFirebaseUser(),
          builder: (BuildContext context, userSnapshot) {
            return userSnapshot.hasData
                ? StreamBuilder(
                    stream: Firestore.instance
                        .collection("users")
                        .document(userSnapshot.data.uid)
                        .snapshots(),
                    builder: (BuildContext context, userSnapshot) {
                      final alpha = 'abcdefghijklmnopqrstuvwxyz'.split('');
                      if (userSnapshot.hasData &&
                          userSnapshot.data['date_mate_requests'] != null) {
                        return MainBloc().showPartnerRequestDialog(
                            context: context,
                            profileuid: userSnapshot.data['date_mate_requests'],
                            uid: userSnapshot.data['uid']);
                      }
                      return StreamBuilder(
                        stream: Firestore.instance
                            .collection('users')
                            .orderBy('lower_name')
                            .startAt([_searchText.toLowerCase()])
                            .endAt(( //The next letter of the alphabet
                                [
                              alpha[(alpha
                                      .indexOf(_searchText.toLowerCase()[0])) +
                                  1]
                            ]))
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
                          if (snapshot.data.documents.length == 0 &&
                              _searchText.length >= 3) {
                            return Column(
                              children: <Widget>[
                                Container(
                                  child: Image(
                                      image: AssetImage(
                                          'assets/img/broken-heart.png')),
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
                                print(snapshot
                                    .data.documents[index].data['name']);
                                return Card(
                                    child: FlatButton(
                                        child: Container(
                                          color: Theme.Colors.midnightBlue,
                                            height: 70,
                                            child: Row(
                                              children: <Widget>[
                                                Hero(
                                                    tag: snapshot
                                                        .data
                                                        .documents[index]
                                                        .data['uid'],
                                                    child: ClipOval(
                                                      child: Image(
                                                        image: NetworkImage(snapshot
                                                                    .data
                                                                    .documents[
                                                                        index]
                                                                    .data[
                                                                'photo'] ??
                                                            ""),
                                                        fit: BoxFit.cover,
                                                        height: 60,
                                                        width: 60,
                                                      ),
                                                    )),
                                                SizedBox(width: 30),
                                                Text(
                                                    snapshot
                                                        .data
                                                        .documents[index]
                                                        .data['name'],
                                                    style: Theme.TextStyles
                                                        .subheadingDark)
                                              ],
                                            )),
                                        onPressed: (() {
                                          showPartnerDialog(
                                              partnerProfile: snapshot
                                                  .data.documents[index].data,
                                              currentProfileUid:
                                                  userSnapshot.data.data['uid'],
                                              context: context);
                                        })));
                              } else {
                                return Text(
                                    "No profiles found, try double checking your spelling and internet connection.");
                              }
                            },
                          );
                        },
                      );
                    })
                : Container();
            //});
          });
    }
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
          return AlertDialog(
            backgroundColor: Theme.Colors.midnightBlue,
            title: Text("Your DateMate", style: TextStyle(color: Colors.white)),
            content: Container(
              height: MediaQuery.of(context).size.height / 3.5,
              child: Column(
                children: <Widget>[
                  Container(
                    color: Theme.Colors.midnightBlue,
                    padding: EdgeInsets.all(15),
                    child: Hero(
                        tag: partnerProfile['uid'],
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(partnerProfile['photo'] ?? ''),
                          radius: 33,
                        )),
                  ),
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
              StreamBuilder(
                  stream: Firestore.instance
                      .collection('users')
                      .document(currentProfileUid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return (snapshot.hasData &&
                            snapshot.data['date_mate_requests'] == null)
                        ? FlatButton(
                            color: Colors.white.withOpacity(.30),
                            child: Text("REQUEST",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                            onPressed: () {
                              Firestore.instance
                                  .collection('users')
                                  .document(partnerProfile['uid'])
                                  .updateData({
                                'date_mate_requests': currentProfileUid
                              });
                            },
                          )
                        : (snapshot.data['date_mate'] != null &&
                                snapshot.data['date_mate'] ==
                                    partnerProfile['uid'])
                            ? FlatButton(
                                color: Colors.white.withOpacity(.30),
                                child: Text("GO",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white)),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                })
                            : CircularProgressIndicator();
                  }),
              FlatButton(
                color: Colors.white.withOpacity(.30),
                child: Text("Cancel",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
                onPressed: () {
                  Firestore.instance
                      .collection('users')
                      .document(partnerProfile['uid'])
                      .updateData({'date_mate_requests': null});
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
