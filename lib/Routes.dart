import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:cool_date_night/ui/date_detail/DateDetailPage.dart';
import 'package:cool_date_night/ui/date_questions/OpenQuestion.dart';
class Routes {
  static final Router _router =  Router();


  // static var planetDetailHandler =  Handler(
  //   handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  //     return  DateDetailPage(params["id"][0]);
  //   });
  
  // static var questionHandler =  Handler(
  //   handlerFunc: (BuildContext context, Map <String, dynamic> params) { 
  //     return  OpenQuestion(params['id'][0]);
  //   }
  // )

  // static void initRoutes() {
  //   _router.define("/detail/:id", handler: planetDetailHandler);
  //  // _router.define("/questions/:id", handler: questionHandler);
  // }

  static void navigateTo(context, String route, {TransitionType transition}) {
    _router.navigateTo(context, route, transition: transition);
  }

}