import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupFormCard extends StatelessWidget {
  final String validation;
  final saveemail;
  final savepwd;
  final savename;
  SignupFormCard(
      {this.saveemail, this.savepwd, this.savename, this.validation});

  //save;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.Colors.darkBlue,
      elevation: 10,
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Text("Email",
                style: TextStyle(color: Theme.Colors.mustard, fontSize: 14.0)),
            TextFormField(
                style: TextStyle(color: Colors.white, fontSize: 14.0),
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.Colors.mustard)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Email",
                    hintStyle:
                        TextStyle(color: Colors.white70, fontSize: 12.0)),
                obscureText: false,
                validator: (value) => value.isEmpty ? validation : null,
                onSaved: saveemail),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Text("Name",
                style: TextStyle(color: Theme.Colors.mustard, fontSize: 14.0)),
            TextFormField(
                style: TextStyle(color: Colors.white, fontSize: 14.0),
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.Colors.mustard)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Name",
                    hintStyle:
                        TextStyle(color: Colors.white70, fontSize: 12.0)),
                obscureText: false,
                validator: (value) => value.isEmpty ? validation : null,
                onSaved: savename),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Text("Password",
                style: TextStyle(color: Theme.Colors.mustard, fontSize: 14.0)),
            TextFormField(
                style: TextStyle(color: Colors.white, fontSize: 14.0),
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.Colors.mustard)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Password",
                    hintStyle:
                        TextStyle(color: Colors.white70, fontSize: 12.0)),
                obscureText: true,
                validator: (value) => value.isEmpty ? validation : null,
                onSaved: savepwd),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(35),
            ),
          ],
        ),
      ),
    );
  }
}
