import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_color.dart';

ThemeData buildThemeData() {
  return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      // fontFamily: 'Muli',
      appBarTheme: appBarTheme(),
      textTheme: textTheme(),
      inputDecorationTheme: inputDecorationTheme(),
      visualDensity: VisualDensity.adaptivePlatformDensity);
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
      color: Colors.white, elevation: 1, systemOverlayStyle: SystemUiOverlayStyle.light, iconTheme: IconThemeData(color: Colors.blue), titleTextStyle: TextStyle(color: Colors.white, fontSize: 18));
}

TextTheme textTheme() {
  return const TextTheme(
    bodyText1: TextStyle(color: AppColor.secondaryColor),
    bodyText2: TextStyle(color: AppColor.secondaryColor),
  );
}

InputDecorationTheme inputDecorationTheme() {
  var outlineInputBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColor.grey), gapPadding: 10);
  return InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      contentPadding: const EdgeInsets.only(left: 20, right: 5, bottom: 5, top: 5),
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder.copyWith(borderSide: const BorderSide(color: Colors.green)),
      focusedErrorBorder: outlineInputBorder.copyWith(borderSide: const BorderSide(color: Colors.red)),
      border: outlineInputBorder);
}

class AppTheme {
  static TextStyle copyStyle({Color? color, FontWeight fontWeight = FontWeight.normal, double fontSize = 14, double? letterSpacing, TextDecoration? decoration}) =>
      TextStyle(fontSize: fontSize, color: color ?? Colors.black, fontWeight: fontWeight, letterSpacing: letterSpacing, decoration: decoration);
}
