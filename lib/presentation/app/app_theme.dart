import 'package:flutter/material.dart';

import '../../generated/assets/colors.gen.dart';

final appTheme = ThemeData(
 // backgroundColor: ColorName.background,
  primaryColor: Colors.white,
    //useMaterial3: true,
    canvasColor: ColorName.background,
    //fontFamily: FontFamily.onest,
    textTheme: textTheme,
    scaffoldBackgroundColor: ColorName.background,
    inputDecorationTheme: inputTheme);

const textTheme = TextTheme(
  bodyLarge: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.black),
  bodyMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black),
  bodySmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.black),
  labelSmall:
      TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Color(0xFFBBBCBE), letterSpacing: 0.5),
  labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFFBBBCBE)),
  labelLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
  titleMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black),
  titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFFBBBCBE)),
);
final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
  textStyle: TextStyle(color: Colors.white),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
);
final inputTheme = InputDecorationTheme(
    hintStyle: TextStyle(
  fontWeight: FontWeight.w400,
  color: Color(0xFF7C7D8B),
  fontSize: 17,
));
