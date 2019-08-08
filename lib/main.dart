import 'package:cool_date_night/ui/authentication/login_page.dart';
import 'package:flutter/material.dart';
import 'package:cool_date_night/ui/home/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';

//TODO: - IMPORTANT: IOS integration for push notifications on Xcode
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
