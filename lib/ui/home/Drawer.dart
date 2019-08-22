import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/bloc_helper/helper.dart';
import 'package:cool_date_night/ui/authentication/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:image_picker/image_picker.dart';
import 'PairView.dart';
import 'package:cool_date_night/ui/purchases/Storefront.dart';
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
                                      "",
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
                      ListTile(
                          title: Text('Change Profile Picture',
                              style: Theme.TextStyles.subheading2Light),
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
                      ListTile(
                          title: Text("Search Datemates",
                              style: Theme.TextStyles.subheading2Light),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PairView()));
                          }),
                      Divider(height: 1, color: prefix0.Colors.white30),
                      ListTile(
                        title: Text(
                          "Retrieve purchases",
                          style: Theme.TextStyles.subheading2Light,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MarketScreen()));
                        },
                      ),
                      Divider(height: 1, color: prefix0.Colors.white30),
                      ListTile(
                        title: Text('Log out',
                            style: Theme.TextStyles.subheading2Light),
                        onTap: () async {
                          await FirebaseAuth.instance.signOut().then((_) {
                            runApp(MaterialApp(home: Login()));
                          });
                        },
                      ),
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
}
