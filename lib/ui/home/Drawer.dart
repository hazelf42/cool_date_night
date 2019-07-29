import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_date_night/bloc_helper/helper.dart';
import 'package:cool_date_night/ui/signin/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DrawerScreen extends StatefulWidget {
  DrawerScreen(this._firebaseUser);
  final DocumentSnapshot _firebaseUser;
  _DrawerScreen createState() => _DrawerScreen(_firebaseUser);
}

class _DrawerScreen extends State<DrawerScreen> {
  @override
  final DocumentSnapshot _firebaseUser;
  _DrawerScreen(this._firebaseUser);

  //var image = NetworkImage(_firebaseUser.);
  Widget build(BuildContext context) {
   return (_firebaseUser == null) ? 
     FutureBuilder(
                                future: MainBloc().getCurrentFirebaseUser(),
                                builder:
                                    (BuildContext context, _firebaseUser) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(),//Image(),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Change Profile Picture'),
            onTap: (){ _getImage(imageSource: ImageSource.gallery);}
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              runApp(MaterialApp(home: Login()));
            },
          ),
        ],
      ),
    );}) : 
     Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(),//Image(),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Change Profile Picture'),
            onTap: (){ _getImage(imageSource: ImageSource.gallery);}
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              runApp(MaterialApp(home: Login()));
            },
          ),
        ],
      ),
    ) ;
  }

    static Future _getImage({
    @required ImageSource imageSource,
  }) async {
    var image = await ImagePicker.pickImage(source: imageSource);
  }

}
