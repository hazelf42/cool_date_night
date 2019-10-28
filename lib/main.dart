import 'package:cool_date_night/ui/authentication/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:cool_date_night/ui/home/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  await FirebaseAuth.instance.currentUser().then((user) {
    if (user == null) {
      runApp(MaterialApp(
        home: Login(),
      ));
    } else {
      runApp(MaterialApp(
        home: HomePage(),
      ));
    }
  });
}
