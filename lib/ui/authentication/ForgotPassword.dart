import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/helpers/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/services.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String _email;
  var _error;
  bool _loading = false;
  bool _complete = false;

  @override
  Widget build(BuildContext context) {
    Future<void> resetPassword(String email) async {
      print("email: " + email);
      setState(() {
        _loading = true;
        _error = null;
      });
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .catchError((e) {
        setState(() {
          if (e is PlatformException) {
            if (e.code == 'ERROR_INVALID_EMAIL') {
              _error = "Invalid email format";
            } else if (e.code == "ERROR_USER_NOT_FOUND") {
              _error = "User not found with that email";
              MainBloc().showSignupAgainDialog(context);
            } else {
              _error = "An error occurred, please try again later.";
            }
          } else {
            _error = "A network error occurred, please try again later.";
          }
          _loading = false;
        });
      }).then((_) {
        if (_error == null) {
          setState(() {
            _complete = true;
            _loading = false;
          });
        }
      });
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.Colors.midnightBlue,
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/img/darkblue.jpg"),
                  fit: BoxFit.cover)),
          child: Column(children: [
            prefix0.SizedBox(height: 80),
            Padding(
                padding: prefix0.EdgeInsets.all(20),
                child: TextFormField(
                    style: TextStyle(color: Colors.black, fontSize: 14.0),
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Theme.Colors.mustard)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        hintText: "Email",
                        hintStyle:
                            TextStyle(color: Colors.black54, fontSize: 12.0)),
                    obscureText: false,
                    onChanged: (email) {
                      setState(() {
                        _email = email;
                      });
                    })),
            FlatButton(
                padding: prefix0.EdgeInsets.all(5),
                child: _loading
                    ? prefix0.CircularProgressIndicator()
                    : Text(_complete ? "Done ✔" : "Send Reset Email"),
                color: Theme.Colors.mustard,
                onPressed: () => (_loading == true)
                    ? () {}
                    : (_complete == true
                        ? Navigator.of(context).pop()
                        : resetPassword(_email))),
            Container(
                padding: _error == null
                    ? prefix0.EdgeInsets.zero
                    : prefix0.EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: (_error != null || _complete == true)
                      ? Theme.Colors.midnightBlue.withAlpha(235)
                      : Colors.transparent,
                ),
                child: Text(
                  _error ?? (_complete == false ? "" : "Email sent"),
                  style: _error == null ? TextStyle(color: Colors.white) : TextStyle(color: Colors.red),
                )),
          ]),
        ));
  }
}
