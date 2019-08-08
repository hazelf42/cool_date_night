import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:flutter/material.dart' as prefix0;

@override
class ForgotPassword extends StatelessWidget {
  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  @override
  String _email;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.Colors.midnightBlue,),
        body: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/img/darkblue.jpg"), fit: BoxFit.cover)),
      child: Column(
        
        children: [
          prefix0.SizedBox(height: 80),
        Padding(
          padding: prefix0.EdgeInsets.all(20),
          child: TextFormField(
          style: TextStyle(color: Colors.black, fontSize: 14.0),
          decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.Colors.mustard)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintText: "Email",
              hintStyle: TextStyle(color: Colors.black54, fontSize: 12.0)),
          obscureText: false,
          onSaved: (value) async {
            _email = value;
            await resetPassword(value);
          },
        )),
        FlatButton(
            child: Text("Send Reset Email"),
            color: Colors.white,
            onPressed: () => resetPassword(_email))
      ]),
    ));
  }
}
