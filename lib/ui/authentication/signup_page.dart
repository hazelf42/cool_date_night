import 'package:flutter/material.dart' as prefix0;

import 'register_form.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_date_night/ui/home/HomePage.dart';
import 'package:cool_date_night/Theme.dart' as Theme;

class Siginup extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<Siginup> {
  String _email;
  String _password;
  String _name;

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
        print('signed in as ${user.uid}');

        await Firestore().collection("users").document(user.uid).setData({
          'uid': user.uid,
          'email': user.email,
          'lower_name': _name.toLowerCase(),
          'name': _name,
          'last_seen': DateTime.now(),
        }, merge: true);
      }).then((_) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomePage()));
      }).catchError((e) {
        print(e);
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
                        prefix0.SizedBox(height: 30),
                        Text("Logo here"),
                        prefix0.SizedBox(height: 30),
                        Text("REGISTER",
                            style: Theme.TextStyles.subheading2Light),
                        Form(
                            key: formkey,
                            child: SignupFormCard(
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
}
