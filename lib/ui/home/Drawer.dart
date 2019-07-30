import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_date_night/bloc_helper/helper.dart';
import 'package:cool_date_night/ui/signin/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'PairView.dart';
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
                            Container(
                              padding: EdgeInsets.all(20),
                              child: ClipOval(
                                  child: 
                                  Image(
                                fit: BoxFit.cover,
                                height: 100,
                                width: 100,
                                image: NetworkImage(
                                    firebaseUserData
                                            .data.firebaseUser.photoUrl ??
                                        "",
                                    scale: 1),
                              )),
                            ),
                            SizedBox(height: 10),
                            Text(firebaseUserData.data.data['name'],
                                style: Theme.TextStyles.dateTitle),
                            SizedBox(height: 20)
                          ])
                        : prefix0.CircularProgressIndicator()),
                ListTile(
                    title: Text('Change Profile Picture'),
                    onTap: () {
                      _getImage(ImageSource.gallery,
                              firebaseUserData.data.firebaseUser.uid)
                          .then((imageUrl) async {
                        var update = UserUpdateInfo();
                        update.photoUrl = imageUrl.toString();
                        await firebaseUserData.data.firebaseUser
                            .updateProfile((update));
                      });
                    }),
                    ListTile(title: Text("Search Datemates"),
                    onTap: () { 
                       Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PairView()));}
                    ),
                ListTile(
                  title: Text("Retrieve purchases"),
                  onTap: () {},
                ),
                ListTile(
                  title: Text('Log out'),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    runApp(MaterialApp(home: Login()));
                  },
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
