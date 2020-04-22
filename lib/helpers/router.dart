import 'package:cool_date_night/ui/authentication/LoginPage.dart';
import 'package:cool_date_night/ui/authentication/WelcomeScreen.dart';
import 'package:cool_date_night/ui/home/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
class FluroRouter {
  static Router router = Router();
    static Handler _welcomeHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => WelcomeScreen());
  static Handler _loginHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => LoginPage());
  static Handler _homeHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => HomePage());
  static void setupRouter() {
    router.define(
      'login',
      handler: _loginHandler,
    );
    router.define(
      'home',
      handler: _homeHandler,
    );
    router.define(
      'welcome',
      handler: _welcomeHandler,
    );
  }
}
