import 'package:flutter/material.dart';
import 'package:cool_date_night/Theme.dart' as Theme;

  final double barHeight = 66.0;
AppBar getAppBar(String title) {
  return AppBar(title: Text(title), backgroundColor: Theme.Colors.darkBlue);
}

// AppBar(child: Container(
//       padding:  EdgeInsets.only(top: statusbarHeight),
//       height: statusbarHeight + barHeight,
//       child:  Center(
//         child:  Text(
//           "Cool Date Night",
//           style: Theme.TextStyles.dateTitle,
//         ),
//       ),
//       color: Colors.black.withOpacity(.5),
//       // decoration:  BoxDecoration(
//       //   gradient:  LinearGradient(
//       //     colors: [Theme.Colors.appBarGradientStart, Theme.Colors.appBarGradientEnd],
//       //     begin: const FractionalOffset(0.0, 0.0),
//       //     end: const FractionalOffset(0.5, 0.0),
//       //     stops: [0.0, 1.0],
//       //     tileMode: TileMode.clamp
//       //   ),
//       // ),
//     );
//   });
