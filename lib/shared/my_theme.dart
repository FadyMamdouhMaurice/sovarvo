import 'package:flutter/material.dart';
class MyThemeData {
  static Color primaryColor = const Color(0xff8F3D96);
  static Color greyTextColor = Colors.grey;
  static Color whiteTextColor = Colors.white;

  // double screenHeight=MediaQuery.of(context).size.height;
  static ThemeData lightTheme = ThemeData(
    textTheme: const TextTheme(
        labelLarge: TextStyle(
            color: Colors.white, fontSize: 50, fontWeight: FontWeight.w700),
        labelMedium: TextStyle(
            color: Colors.white, fontSize: 25),
        labelSmall: TextStyle(
            color: Colors.white, fontSize: 20),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 28,
        ),
        headlineSmall: TextStyle(
          color: Colors.white,
          fontSize: 18,
        )),
  );
  static ThemeData darkTheme =  ThemeData(
    textTheme: const TextTheme(
        labelLarge: TextStyle(
            color: Colors.white, fontSize: 50, fontWeight: FontWeight.w700),
        labelMedium: TextStyle(
            color: Colors.white, fontSize: 25),
        labelSmall: TextStyle(
            color: Colors.white, fontSize: 20),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 28,
        ),
        headlineSmall: TextStyle(
          color: Colors.white,
          fontSize: 18,
        )),
  );
}