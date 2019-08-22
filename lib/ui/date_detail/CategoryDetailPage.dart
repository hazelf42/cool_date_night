import 'package:cool_date_night/models/Date.dart';
import 'package:cool_date_night/ui/date_detail/CategoryDetailBody.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:flutter/material.dart';

class CategoryDetailPage extends StatelessWidget {


  final Map userProfile;
  final Category category;
  CategoryDetailPage(this.userProfile, this.category);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(backgroundColor: Theme.Colors.midnightBlue),
      body: SingleChildScrollView( child: CategoryDetailBody( userProfile, category))
    );
  }
}
