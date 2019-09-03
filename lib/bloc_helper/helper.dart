import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/models/Date.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import 'validators.dart';

//Custom avatar
class Avatar extends StatelessWidget {
  final double radius;
  final String imagePath;
  final String heroTag;

  const Avatar({Key key, this.radius, this.imagePath, this.heroTag})
      : super(key: key);

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

//Userdata class which accesses FirebaseUser and the data fetched from Firebase about them
class UserData {
  final FirebaseUser firebaseUser;
  final DocumentSnapshot data;

  const UserData({this.firebaseUser, this.data});
}

class MainBloc extends Object with Validators {
  MainBloc();
  final listOfChallenges = [
    'Agree enthusiastically with your partner',
    'Take your partner’s answer as a personal insult',
    'Act as if your partner’s answer is the funniest thing you’ve heard',
    'Twist your partner’s answer to mean something totally different',
    'Pretend to be confused by your partner’s answer. Get them to explain as many times as you can',
    'Express a deep sadness in your partner’s choice of response',
    'Be overjoyed that your partner answered as they did',
    'Stand up and deliver a court room closing argument about why your answer is the correct one',
    'Try to persuade your partner into selecting a different response',
    'Probe your partner for further insight into their decision',
    'Try to explain why you think your partner chose the way they did',
    'Be astonished that your partner picked their response over another of your choice',
    'Playfully question whether your partner is being truthful',
    'Offer constructive criticism to your partner’s selection',
    'Be intensely relieved that your partner didn’t pick one of the other options',
    'Forgive your partner for answering as they did',
    'Act honoured to be in the presence of one so wise for picking as they did',
    'Stare at your partner with no expression and without smiling for 20 seconds',
    'The next time your partner speaks, put a finger to their lips and say “hush” without explanation',
    'Lean in close to your partner and ask them to tell you more',
    'Begin your next sentence with “I’m glad you answered that way because otherwise...”',
    'Act extremely surprised at your partner’s selection',
    'Offer an opinion that supports your partner’s choice',
    'Make a ridiculously bad argument to try and change your partner’s mind',
    'Explain what the best thing would be about living with someone who thinks like your partner does in this instance',
    'Act as if your partner’s response is a huge turn on',
    'Be extremely impressed with the choice your partner has made',
    'Say “The way you answered that question makes me want to...”',
    'Predict what the future may look like for someone who made a choice like your partner just did',
    'Explain how your partner’s answer makes total sense to you',
    'Wink at your partner and say “Ok, now I understand”, as if you have unlocked some secret',
    'Stroke your chin and be very interested in your partner’s response. Get them to elaborate on their decision',
    'Be completely shocked at your partner’s choice',
    'Get your partner to give you a high five for an awesome answer. Repeat until satisfying slap has occurred',
    'Act as if you knew with complete certainty that your partner would answer as they did',
    'Say something random and totally unrelated to the question at hand',
    'Wonder aloud about what kind of person could have possibly answered as your partner just did',
    'Compliment your partner profusely about their selection',
    'Respond to your partner’s choice as either Yoda, Elmo or Batman',
    'Tell your partner something you find very attractive about their thought process"'
  ];
  Future<FirebaseUser> getCurrentFirebaseUser() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    return await _firebaseAuth.currentUser();
  }

  Future<UserData> getCurrentFirebaseUserData() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    return await _firebaseAuth.currentUser().then((user) async {
      return await (Firestore.instance
              .collection("users")
              .document(user.uid)
              .get())
          .then((userData) {
        return UserData(data: userData, firebaseUser: user);
      });
    });
  }

  Future<Map> getUser(String uid) async {
    var doc =
        await (Firestore.instance.collection("users").document(uid).get());
    return doc.data;
  }

  void changeProfilePic() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {});
  }

//What it says on the tin
  Widget showPartnerRequestDialog(
      {@required BuildContext context,
      @required String profileuid,
      @required String uid}) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(profileuid)
            .snapshots(),
        builder: (BuildContext context, userSnapshot) {
          return (userSnapshot.hasData)
              ? AlertDialog(
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
                                heroTag: 'datemate')),
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
                        Firestore.instance
                            .collection('users')
                            .document(uid)
                            .updateData({'date_mate_requests': null});
                        Firestore.instance
                            .collection('users')
                            .document(uid)
                            .updateData({'date_mate': profileuid});

                        Firestore.instance
                            .collection('users')
                            .document(profileuid)
                            .updateData({'date_mate': uid});
                      },
                    ),
                    FlatButton(
                      color: Colors.white.withOpacity(.30),
                      child: Text("Ignore",
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                      onPressed: () {
                        Firestore.instance
                            .collection('users')
                            .document(uid)
                            .updateData({'date_mate_requests': null});
                      },
                    )
                  ],
                )
              : Center(
                  child: Container(
                  child: CircularProgressIndicator(),
                  height: 50,
                  width: 50,
                ));
        });
  }

  Future<List> randomizeDateQuestions(Date date) async {
    return await Firestore.instance
        .collection('dates_with_questions').document(date.name).get().then((snapshot) {
      var openList = new List.from(snapshot['open_questions']);
      openList = openList.reversed.toList();
      final finalQuestion = openList.removeLast();
      var mcList = new List.from(snapshot['mc_questions']);
      mcList = mcList.reversed.toList();
      var random = Random();
      var randDateList = [];
      var n = openList.length + mcList.length;
      while (randDateList.length < n) {
        if (random.nextInt(2) == 0 && openList.length != 0) {
          randDateList.add(openList.removeAt(0));
        } else if (mcList.length != 0) {
          randDateList.add(mcList.removeAt(0));
        }
      }
      randDateList.add(finalQuestion);
      return randDateList;
    });
  }
}

//Determine whether the next question will be MC or Open with RNG
