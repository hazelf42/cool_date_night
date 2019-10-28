import 'package:cool_date_night/ui/authentication/LoginPage.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:cool_date_night/ui/home/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp',
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(),
        '/login': (context) => prefix0.LoginPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}

class LoginPage {
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed('/login');
      } else {
        Navigator.of(context).pushReplacementNamed('/home');
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
