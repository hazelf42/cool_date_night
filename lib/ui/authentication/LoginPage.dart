import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/ui/home/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'LoginForm.dart';
import 'WelcomeScreen.dart';

class Login extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<Login> {
  String _email;
  String _password;
  String _error;
  bool _isLoading = false;
  //google sign
  /// GoogleSignIn googleauth = new GoogleSignIn();
  final formkey = new GlobalKey<FormState>();
  checkFields() {
    final form = formkey.currentState;
    if (form != null) {
      if (form.validate()) {
        form.save();
        return true;
      }
      return false;
    }
  }

  loginUser() {
    if (checkFields() != null && checkFields()) {
      setState(() {
       _isLoading = true; 
      });
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password)
          .then((user) {
        print("signed in as ${user.uid}");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
      }).catchError((e) {
        setState(() {
          if (e is PlatformException) {
            _error = e.code == 'ERROR_NETWORK_REQUEST_FAILED'
                ? "Login failed, please try again"
                : "Incorrect password or email";
          } else {
            _error = "A network error occurred.";
          }
          _isLoading = false;
        });
        return;
      });
    }
  }

  Widget radioButton(bool isSelected) => Container(
        width: 16.0,
        height: 16.0,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2.0, color: Colors.black)),
        child: isSelected
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.black),
              )
            : Container(),
      );

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil.getInstance().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return new Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: true,
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
                  padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 35.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: ScreenUtil.getInstance().setHeight(275),
                      ),
                      Form(
                          key: formkey,
                          child: FormCard(
                            validation: 'required',
                            saveemail: (value) => _email = value,
                            savepwd: (value) => _password = value,
                          )),
                      SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                      Center(
                        child: InkWell(
                          onTap: () => loginUser(),
                          child: Container(
                            width: ScreenUtil.getInstance().setWidth(330),
                            height: ScreenUtil.getInstance().setHeight(100),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.Colors.midnightBlue.withAlpha(235),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                child: Center(
                                  child: 
                                  
            _isLoading ? prefix0.CircularProgressIndicator() : Text("SIGN IN",
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
                      prefix0.SizedBox(height: 10),
                      Container(
                          padding: _error == null
                              ? prefix0.EdgeInsets.zero
                              : prefix0.EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: _error != null
                                ? Theme.Colors.midnightBlue.withAlpha(235)
                                : Colors.transparent,
                          ),
                          child: Text(
                            _error ?? "",
                            style: TextStyle(color: Colors.red),
                          )),
                      SizedBox(
                        height: ScreenUtil.getInstance().setHeight(30),
                      ),
                      SizedBox(
                        height: ScreenUtil.getInstance().setHeight(30),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
