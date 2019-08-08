import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'signup_page.dart';
class FormCard extends StatelessWidget {
  final String validation;
  final saveemail;
  final savepwd;
  FormCard({this.saveemail, this.savepwd, this.validation});

  //save;
  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      decoration: BoxDecoration(
      color: Theme.Colors.darkBlue,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 15.0),
                blurRadius: 15.0),
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, -10.0),
                blurRadius: 10.0),
          ]),
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Login",
                style: TextStyle(
                  color: Colors.white,
                    fontSize: ScreenUtil.getInstance().setSp(45),
                    fontFamily: "Poppins-Bold",
                    letterSpacing: .6)),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(15),
            ),
            Text("Email",
                style: TextStyle(
                    fontFamily: "Poppins-Medium",
                    fontSize: ScreenUtil.getInstance().setSp(26))),

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
            Text(
              "Password",
              style: TextStyle(
                  fontFamily: "Poppins-Medium",
                  fontSize: ScreenUtil.getInstance().setSp(26)),
            ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "Forgot Password?",
                  style: TextStyle(
                      color: Colors.blue,
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(28)),
                )
              ],
            ),SizedBox(
              height: ScreenUtil.getInstance().setHeight(35),
            ),
             Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "New User? ",
                            style: TextStyle(fontFamily: "Poppins-Medium", color: Colors.white),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Siginup()));
                            },
                            child: Text("Sign Up",
                                style: TextStyle(
                                    color: Theme.Colors.mustard,
                                    fontFamily: "Poppins-Bold")),
                          )
                        ],
                      ), SizedBox(
              height: ScreenUtil.getInstance().setHeight(35),
            ),
          ],
        ),
      ),
    );
  }
}
