import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/ui/home/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;

class WelcomeScreen extends StatelessWidget {
  static const _welcomeString =
      "Each Cool Date contains 20 questions that you and your Date Mate can read and take turns answering. You'll find a category that fits every type of couple! Just be honest and take time to explain your decisions, but most importantly, HAVE FUN!";
  @override
  Widget build(BuildContext context) {
    var height = prefix0.MediaQuery.of(context).size.height;
    return Scaffold(
        body: (Container(
            height: prefix0.MediaQuery.of(context).size.height,
            width: prefix0.MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/img/darkblue.jpg"),
                    fit: BoxFit.cover)),
            child: Center(
                child: Wrap(children: <Widget>[
              Card(
                  margin:
                      prefix0.EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                  color: Theme.Colors.midnightBlue,
                  elevation: 5,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      prefix0.SizedBox(
                          height: height / 30, width: double.infinity),
                      Image(
                          image:
                              AssetImage('assets/img/cooldatenightmustard.png'),
                          height: 50,
                          width: 50),
                      prefix0.SizedBox(height: 30, width: double.infinity),
                      Text("Welcome!", style: Theme.TextStyles.dateTitle),

                      prefix0.SizedBox(
                          height: 10, width: double.infinity),
                      SingleChildScrollView(
                          padding: EdgeInsets.all(10),
                          child: Text(_welcomeString,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                              textAlign: prefix0.TextAlign.center)),
                      prefix0.SizedBox(height: 10, width: double.infinity),
                      prefix0.FlatButton(
                        color: Theme.Colors.mustard,
                        child: Text("Let's Go!",
                            style: Theme.TextStyles.subheading2Dark),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              settings: RouteSettings(name: HomePage.routeName),
                              builder: (context) => HomePage(),
                            ),
                          );
                        },
                      ),
                      prefix0.SizedBox(height: 30, width: double.infinity),
                    ],
                  ))
            ])))));
  }
}
