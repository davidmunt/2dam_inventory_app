import 'package:flutter/material.dart';

const colorList = <Color>[
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.red,
  Colors.purple,
  Colors.deepPurple,
  Colors.orange,
  Colors.pink,
  Colors.pinkAccent,
];

class AppTheme {
  final bool useMaterial3;
  int selectedColor;
  final bool isDarkmode;
  final String fontFamily;

  AppTheme({
    this.useMaterial3 = true,
    this.selectedColor = 0,
    this.isDarkmode = false,
    this.fontFamily = "Roboto",
  });

  ThemeData getTheme() => ThemeData(
        useMaterial3: useMaterial3,
        brightness: isDarkmode ? Brightness.dark : Brightness.light,
        colorSchemeSeed: colorList[selectedColor],
        appBarTheme: AppBarTheme(
          color: colorList[selectedColor],
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontFamily: fontFamily),
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 45, color: Colors.black, fontFamily: fontFamily),
          bodyLarge: TextStyle(fontSize: 18, color: Colors.black87, fontFamily: fontFamily),
        ),
      );
}
