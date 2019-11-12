import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/helpers/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'LoginForm.dart';
import 'WelcomeScreen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<LoginPage> {
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
        if (e.code == "ERROR_USER_NOT_FOUND") {
              MainBloc().showSignupAgainDialog(context); 
           }
        setState(() {
           
          if (e is PlatformException) {
            _error = e.code == 'ERROR_NETWORK_REQUEST_FAILED'
                ? "Login failed, please try again"
                : (e.code == "ERROR_USER_NOT_FOUND" ? _error = "User not found." : "An error occurred. Errorcode ${e.code}"); 
          } else {
            _error = "A network error occurred.";
          }
          _isLoading = false;
        });
        return;
      });
    }
  }

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
                                  child: _isLoading
                                      ? prefix0.CircularProgressIndicator()
                                      : Text("SIGN IN",
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
