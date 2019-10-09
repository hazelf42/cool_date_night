import 'package:auto_size_text/auto_size_text.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/ui/home/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;

class WelcomeScreen extends StatelessWidget {
  final _welcomeString =
      "Each Cool Date contains 20 questions that you and your Date Mate can read and take turns answering. You'll find a category that fits every type of couple! Just be honest and take time to explain your decisions, but most importantly, HAVE FUN!";
  @override
  Widget build(BuildContext context) {
  var height = prefix0.MediaQuery.of(context).size.height;
    return Scaffold(body:(Container(
      height:prefix0.MediaQuery.of(context).size.height,
      width: prefix0.MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/img/darkblue.jpg"), fit: BoxFit.cover)),
         padding: EdgeInsets.symmetric(vertical: (height/5), horizontal: 50),
      child: Container(
        
        child: Card(
            elevation: 5,
            color: Theme.Colors.midnightBlue,
                child: Column(
                  children: <Widget>[
                    prefix0.SizedBox(height: height/20),
                    Image(
                        image:
                            AssetImage('assets/img/cooldatenightmustard.png'),
                        height: 50,
                        width: 50),
                    prefix0.SizedBox(height: height/20),
                    Text("Welcome!", style: Theme.TextStyles.dateTitle),
                    prefix0.SizedBox(height: height/20),
                    Expanded(
                        flex: 1,
                        child: SingleChildScrollView(
                          
        padding: EdgeInsets.all(10),
                            child: AutoSizeText(_welcomeString,
                                style: TextStyle(color: Colors.white, fontSize: 16),
                                textAlign: prefix0.TextAlign.center, 
                                maxLines: 7))),
                    prefix0.SizedBox(height: height/20),
                    prefix0.FlatButton(
                      color: Theme.Colors.mustard,
                      child:
                          Text("Let's Go!", style: Theme.TextStyles.subheading2Dark),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => HomePage()));
                      },
                    ),
                    prefix0.SizedBox(height: height/30),
                  ],
                ))),
      )));
  }
}
