import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/bloc_helper/helper.dart';
import 'package:cool_date_night/ui/authentication/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:image_picker/image_picker.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'PairView.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DrawerScreen extends StatefulWidget {
  _DrawerScreen createState() => _DrawerScreen();
}

class _DrawerScreen extends State<DrawerScreen> {
  _DrawerScreen();

  //var image = NetworkImage(_firebaseUser.);
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: MainBloc().getCurrentFirebaseUserData(),
        builder:
            (BuildContext context, AsyncSnapshot<UserData> firebaseUserData) {
          return Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              children: <Widget>[
                Container(
                    color: Theme.Colors.midnightBlue,
                    child: firebaseUserData.hasData
                        ? Column(children: [
                            Padding(
                                padding: EdgeInsets.all(15),
                                child: Avatar(
                                  imagePath: firebaseUserData
                                          .data.firebaseUser.photoUrl ??
                                      "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                  radius: 100,
                                )),
                            SizedBox(height: 10),
                            Text(firebaseUserData.data.data['name'] ?? "",
                                style: Theme.TextStyles.dateTitle),
                            SizedBox(height: 20)
                          ])
                        : prefix0.CircularProgressIndicator()),
                Container(
                  color: Theme.Colors.darkBlue,
                  height: MediaQuery.of(context).size.height - 150,
                  child: Column(
                    children: <Widget>[
                      MenuItem(
                          iconData: Icons.photo_camera,
                          string: "Change Profile Picture",
                          onTap: () {
                            _getImage(ImageSource.gallery,
                                    firebaseUserData.data.firebaseUser.uid)
                                .then((imageUrl) async {
                              var update = UserUpdateInfo();
                              update.photoUrl = imageUrl.toString();
                              await firebaseUserData.data.firebaseUser
                                  .updateProfile((update))
                                  .then((_) {
                                Firestore.instance
                                    .collection('users')
                                    .document(
                                        firebaseUserData.data.firebaseUser.uid)
                                    .updateData(({'photo': imageUrl}));
                              });
                            });
                          }),
                      Divider(height: 1, color: prefix0.Colors.white30),
                      MenuItem(
                          iconData: Icons.person_add,
                          string: "Search Datemates",
                          onTap: (() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PairView()));
                          })),
                      Divider(height: 1, color: prefix0.Colors.white30),
                      MenuItem(
                          iconData: Icons.shopping_cart,
                          string: "Retrieve Purchases",
                          onTap: (() async {
                            retrievePurchasesDialog(
                                context: context,
                                userData: firebaseUserData.data.data);
                          })),
                      Divider(height: 1, color: prefix0.Colors.white30),
                      MenuItem(
                          iconData: Icons.feedback,
                          string: "Feedback",
                          onTap: () => launch("http://cooldatenight.com")),
                      Divider(height: 1, color: prefix0.Colors.white30),
                      MenuItem(
                          iconData: Icons.exit_to_app,
                          string: "Log out",
                          onTap: () async {
                            await FirebaseAuth.instance.signOut().then((_) {
                              runApp(MaterialApp(home: Login()));
                            });
                          }),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<String> _getImage(
    ImageSource imageSource,
    String uid,
  ) async {
    return await ImagePicker.pickImage(source: imageSource).then((image) async {
      StorageReference ref =
          FirebaseStorage.instance.ref().child(uid).child("profilepic.png");
      StorageUploadTask uploadTask = ref.putFile(image);
      return await (await uploadTask.onComplete).ref.getDownloadURL();
    });
  }

  Future<Widget> retrievePurchasesDialog(
      {@required BuildContext context,
      @required DocumentSnapshot userData}) async {
    final snapshot =
        await InAppPurchaseConnection.instance.queryPastPurchases();
    if (snapshot.pastPurchases.length > 0 && userData['isPaid'] == false) {
      Firestore.instance
          .collection('users')
          .document(userData['uid'])
          .updateData({"isPaid": true});
    }
    prefix0.showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              actions: <Widget>[
                prefix0.FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
              title: snapshot.error != null
                  ? Text("An error occurred.")
                  : "Retrieve Purchases",
              content: snapshot.error != null
                  ? Text("In app purchases are not currently available.")
                  : (userData['isPaid'] == true)
                      ? Text("You have unlocked all dates.")
                      : (snapshot.pastPurchases.length > 0)
                          ? Text(
                              "Purchase found but could not process them. Please logout and log back in.")
                          : Text("You have unlocked all dates."));
        });
  }
}

class MenuItem extends StatelessWidget {
  final GestureTapCallback onTap;
  final IconData iconData;
  final String string;

  const MenuItem({
    @required this.onTap,
    @required this.iconData,
    @required this.string,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 8.0,
      ),
      child: InkWell(
        splashColor: Colors.white54,
        onTap: onTap,
        borderRadius: BorderRadius.circular(4.0),
        splashFactory: InkRipple.splashFactory,
        child: Container(
          height: 40.0,
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: Row(
            children: <Widget>[
              Icon(
                iconData,
                color: Colors.white54,
              ),
              Container(
                width: 22.0,
              ),
              Text(string, style: Theme.TextStyles.subheading2Light),
            ],
          ),
        ),
      ),
    );
  }
}
