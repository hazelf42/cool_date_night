import 'package:auto_size_text/auto_size_text.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/bloc_helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:cool_date_night/ui/home/HomePage.dart';
class WelcomeScreen extends StatelessWidget {
  final _welcomeString = "Each Cool Date contains 20 questions that you and your Date Mate can read and take turns answering. You'll find a category that fits every type of couple! Just be honest and take time to explain your decisions, but most importantly, HAVE FUN!";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: prefix0.MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/img/darkblue.jpg"), fit: BoxFit.cover)),
      padding: EdgeInsets.symmetric(vertical: 75, horizontal: 50),
      child: Container(
        child: Card(
          elevation: 5,
          color: Theme.Colors.midnightBlue,
          child:
          Container(
            padding: prefix0.EdgeInsets.all(10),
            child:  SingleChildScrollView(child: Stack(
            children: <Widget>[
              prefix0.SizedBox(height: 40),
              Image(image: AssetImage('assets/img/cooldatenightmustard.png'), height: 50, width: 50),
              prefix0.SizedBox(height: 40),
              Text("Welcome!", style: Theme.TextStyles.dateTitle),
              prefix0.SizedBox(height: 40),
              AutoSizeText(_welcomeString, style: Theme.TextStyles.bodyLight, textAlign: prefix0.TextAlign.center, maxLines: 11),
              prefix0.SizedBox(height: 40),

              prefix0.FlatButton(
                color: Theme.Colors.mustard,
                child: Text("OK",
                    style: Theme.TextStyles.subheading2Dark),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                          builder: (context) => HomePage())
                  );
                },
              )
            ],
          ))),
        ),
      ),
    ));
  }
}
