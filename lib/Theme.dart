import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;

class Colors {
  const Colors();

  static const Color mustard = const Color(0xFFFAB040);
  static const Color coral = const Color(0xFFFC615C);
  static const Color midnightBlue = const Color(0xFF142142);
  static const Color darkBlue = const Color(0xFF101A33);
  static const Color duskBlue = const Color(0xFF4670DB);
  static const Color lightBlue = const Color(0xFF0f85f1);

}
Map dateColors = {
    'Free Trial' : Colors.mustard,
    "Parents Night Out" : Colors.mustard,
    'Gear Shifter' : Colors.lightBlue,
    'Icebreaker' : Colors.lightBlue,
    'Spicy' : Colors.coral,
    'Vitalizer': Colors.coral

   };
class Dimens {
  const Dimens();

  static const planetWidth = 120.0;
}

class TextStyles {
  const TextStyles();

  static const TextStyle dateTitle = const TextStyle(
      color: prefix0.Colors.white, fontFamily: 'DKVisum', fontSize: 35.0);
       static const TextStyle dateTitleSmall = const TextStyle(
      color: prefix0.Colors.white, fontFamily: 'DKVisum', fontSize: 25.0);
  static const TextStyle bigTitle = const TextStyle(
      color: prefix0.Colors.white, fontFamily: 'DKVisum', fontSize: 46.0);

  static const TextStyle bodyDark = const TextStyle(
      color: Colors.midnightBlue,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w200,
      fontSize: 12.0);
  static const TextStyle bodyLight = const TextStyle(
    color: prefix0.Colors.white,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w300,
    fontSize: 14.0,
  );

  static const TextStyle subheadingDark = const TextStyle(
      color: Colors.midnightBlue,
      fontFamily: 'Roboto',
      fontSize: 24.0,
      fontWeight: FontWeight.w600);

  static const TextStyle subheadingLight = const TextStyle(
      color: prefix0.Colors.white,
      fontFamily: 'Roboto',
      fontSize: 24.0,
      fontWeight: FontWeight.w600);

//Should be all caps :)
  static const TextStyle subheading2Dark = const TextStyle(
      color: Colors.midnightBlue,
      fontFamily: 'Roboto',
      fontSize: 14.0,
      fontWeight: FontWeight.w600);

static const TextStyle subheading2Light = const TextStyle(
      color: prefix0.Colors.white,
      fontFamily: 'Roboto',
      fontSize: 14.0,
      fontWeight: FontWeight.w600);
}
