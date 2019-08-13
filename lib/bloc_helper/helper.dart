import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'validators.dart';

class Avatar extends StatelessWidget {

  final double radius;
  final String imagePath;
  final String heroTag;

  const Avatar({
    Key key, 
    this.radius, 
    this.imagePath,
    this.heroTag
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      constraints: new BoxConstraints(
        minHeight: radius,
        maxHeight: radius,
        minWidth: radius,
        maxWidth: radius,
      ),
      child: new ClipOval(
        child: new CachedNetworkImage(
          placeholder: (context, url) => CircularProgressIndicator(),
          fit: BoxFit.cover,
          imageUrl: imagePath,
        ),
      ),
    );
  }

}
class UserData {
  final FirebaseUser firebaseUser;
  final DocumentSnapshot data;

  const UserData({this.firebaseUser, this.data});
}

class MainBloc extends Object with Validators {
  MainBloc();
  Future<FirebaseUser> getCurrentFirebaseUser() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    return await _firebaseAuth.currentUser();
  }
  
  Future<UserData> getCurrentFirebaseUserData() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    return await _firebaseAuth.currentUser().then((user) async {
        return await (Firestore.instance.collection("users").document(user.uid).get()).then((userData) {
          return UserData(data: userData, firebaseUser: user);
        });
    });
  }


  Future<Map> getUser(String uid) async {
    var doc = await (Firestore.instance.collection("users").document(uid).get());
    return doc.data;
  }

  void changeProfilePic()  async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) { 
    });
  }


  Widget showPartnerRequestDialog(
      {@required BuildContext context, @required String profileuid, @required String uid}) {
          return StreamBuilder(
            stream: Firestore.instance.collection('users').document(profileuid).snapshots(),
            builder:  (BuildContext context, userSnapshot) {
           return (userSnapshot.hasData) ? 
           AlertDialog(
            backgroundColor: Theme.Colors.darkBlue,
            title: Text("Date Mate Request",
                style: TextStyle(color: Colors.white)),
            content: Container(
              height: 100,
              child: Column(
                children: <Widget>[
                  Container(
                    color: Theme.Colors.darkBlue,
                    padding: EdgeInsets.all(10),
                    child: Avatar(
                      imagePath: userSnapshot.data['photo'] ?? "",
                      radius: 50,
                      heroTag: 'datemate'
                    )
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width - 50,
                      child: Center(
                          child: Text(userSnapshot.data['name'],
                              style: TextStyle(
                                  fontSize: 21, color: Colors.white))))
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.white.withOpacity(.30),
                child: Text("GO",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
                onPressed: () {
                  Firestore.instance.collection('users').document(uid).updateData({
                    'date_mate_requests' : null
                  });
                  Firestore.instance.collection('users').document(uid).updateData({
                    'date_mate' : profileuid
                  });
                  
                  Firestore.instance.collection('users').document(profileuid).updateData({
                    'date_mate' : uid
                  });
                },
              ),
              FlatButton(
                color: Colors.white.withOpacity(.30),
                child: Text("Ignore",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
                onPressed: () {
                  Firestore.instance.collection('users').document(uid).updateData({
                    'date_mate_requests' : null
                  });
                },
              )
            ],
          ) : Center(
            child: Container(
              child: CircularProgressIndicator(),
              height: 50,
              width: 50,
            )
          );});
  }
}
