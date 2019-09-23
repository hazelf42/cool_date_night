import 'dart:ui' as prefix1;
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/bloc_helper/helper.dart';
import 'package:cool_date_night/models/Date.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class DateCompleteScreen extends StatelessWidget {
  final Category category;
  DateCompleteScreen(this.category);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: prefix0.MediaQuery.of(context).size.width,
      color: Theme.dateColors[category.name],
      padding: EdgeInsets.symmetric(vertical: 75, horizontal: 50),
      child: Container(
        child: Card(
          elevation: 5,
          color: Theme.Colors.midnightBlue,
          child: Column(
            children: <Widget>[
              prefix0.SizedBox(height: 120),
              Avatar(
                  imagePath: category.image, radius: 75, heroTag: 'category'),
              prefix0.SizedBox(height: 50),
              Text("Date Complete!", style: Theme.TextStyles.dateTitle),
              prefix0.SizedBox(height: 75),
              Text("Snap a #cooldatenight selfie to celebrate!",
                  style: Theme.TextStyles.subheading2Light),
              Text("Then tag us with #cooldatenight",
                  style: Theme.TextStyles.bodyLight),
              IconButton(
                  icon: Icon(FontAwesomeIcons.cameraRetro),
                  onPressed: () {
                    _getSelfie(
                      imageSource: ImageSource.camera,
                    );
                  }),
              prefix0.FlatButton(
                color: Theme.dateColors[category.name],
                child: Text("BACK TO " + category.name.toUpperCase(),
                    style: Theme.TextStyles.subheading2Dark),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              )
            ],
          ),
        ),
      ),
    ));
  }
  //Image?

  static Future _getSelfie({
    @required ImageSource imageSource,
  }) async {
    await ImagePicker.pickImage(source: imageSource).then((image) async{
      print("Hi");
      //await showPicDialog();
    });
  }

  showPicDialog() {}
}
