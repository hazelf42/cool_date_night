import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/ui/home/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'register_form.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => new _SignupState();
}

class _SignupState extends State<Signup> {
  String _email;
  String _password;
  String _name;
  File _photo;

  //google sign
  /// GoogleSignIn googleauth = new GoogleSignIn();
  final formkey = new GlobalKey<FormState>();
  checkFields() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  createUser() async {
    if (checkFields()) {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password)
          .then((user) async {
        UserUpdateInfo userUpdateInfo = UserUpdateInfo();
        userUpdateInfo.displayName = _name;
        print('signed in as ${user.uid}');
        if (_photo != null) {
          await _getImageUrl(_photo, user.uid).then((imageUrl) async {
            userUpdateInfo.photoUrl = imageUrl;
            await user.updateProfile(userUpdateInfo);
            await Firestore().collection("users").document(user.uid).setData({
              'uid': user.uid,
              'email': user.email,
              'lower_name': _name.toLowerCase(),
              'name': _name,
              'last_seen': DateTime.now(),
              'photo': imageUrl
            }, merge: true);
          }).then((_) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomePage()));
          }).catchError((e) {
            print(e);
          });
        } else {
          await Firestore().collection("users").document(user.uid).setData({
            'uid': user.uid,
            'email': user.email,
            'lower_name': _name.toLowerCase(),
            'name': _name,
            'last_seen': DateTime.now(),
          }, merge: true).then((_) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomePage()));
          }).catchError((e) {
            print(e);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/img/darkblue.jpg"),
                    fit: BoxFit.cover)),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 28.0, right: 28.0, top: 35.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 25),
                        Form(
                            key: formkey,
                            child: SignupFormCard(
                              button: OutlineButton(
                                child: ClipOval(
                                    child: Image(
                                        fit: _photo != null
                                            ? BoxFit.cover
                                            : BoxFit.fitHeight,
                                        height: 50,
                                        width: 50,
                                        image: _photo != null
                                            ? FileImage(_photo)
                                            : AssetImage(
                                                "assets/img/camera.png"))),
                                onPressed: () async {
                                  await _getImage(ImageSource.gallery)
                                      .then((image) {
                                    setState(() {
                                      _photo = image;
                                    });
                                  });
                                },
                              ),
                              validation: 'required',
                              saveemail: (value) => _email = value,
                              savepwd: (value) => _password = value,
                              savename: (value) => _name = value,
                            )),
                        SizedBox(
                            height: ScreenUtil.getInstance().setHeight(40)),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 12.0,
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                          ],
                        ),
                        Center(
                          child: InkWell(
                            onTap: createUser,
                            child: Container(
                              width: ScreenUtil.getInstance().setWidth(330),
                              height: ScreenUtil.getInstance().setHeight(100),
                              decoration: prefix0.BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Theme.Colors.midnightBlue.withAlpha(235),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: createUser,
                                  child: Center(
                                    child: Text("SIGN UP",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Poppins-Bold",
                                            fontSize: 18,
                                            letterSpacing: 1.0)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )));
  }

  Future<File> _getImage(
    ImageSource imageSource,
  ) async {
    return PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage)
        .then((isAllowed) async {
      if (isAllowed != PermissionStatus.granted) {
        PermissionHandler()
            .requestPermissions([PermissionGroup.storage]).then((_) async {
          return await ImagePicker.pickImage(source: imageSource);
        });
      } else {
        return await ImagePicker.pickImage(source: imageSource);
      }
    });
    //TODO: iOS permissions
  }
}

Future<String> _getImageUrl(File image, String uid) async {
  StorageReference ref =
      FirebaseStorage.instance.ref().child(uid).child("profilepic.png");
  StorageUploadTask uploadTask = ref.putFile(image);
  return await (await uploadTask.onComplete).ref.getDownloadURL();
}
// .then((image) async {
//       StorageReference ref =
//           FirebaseStorage.instance.ref().child(uid).child("profilepic.png");
//       StorageUploadTask uploadTask = ref.putFile(image);
//       return await (await uploadTask.onComplete).ref.getDownloadURL();
//     });
