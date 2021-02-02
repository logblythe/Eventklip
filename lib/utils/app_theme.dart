import 'package:flutter/material.dart';
import 'package:eventklip/utils/resources/colors.dart';

class AppTheme {
  //
  AppTheme._();

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: appBackground,
    splashColor: navigationBackground,
    primaryColor: colorPrimary,
    primaryColorDark: colorPrimaryDark,
    errorColor: Color(0xFFE15858),
    hoverColor: Colors.grey,
    accentColor: colorPrimary,
    cardColor: cardColor,
    appBarTheme: AppBarTheme(
      color: appBackground,
      iconTheme: IconThemeData(
        color: textColorPrimary,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: colorPrimary,
      onPrimary: colorPrimary,
      primaryVariant: colorPrimary,
      secondary: colorPrimary,
    ),

    iconTheme: IconThemeData(
      color: textColorPrimary,
    ),
    textTheme: TextTheme(
        button: TextStyle(color: Colors.white),
        subtitle1: TextStyle(
          color: textColorPrimary,
        ),
        headline6: TextStyle(
          color: textColorPrimary,
        ),
        subtitle2: TextStyle(
          color: textColorSecondary,
        ),
        caption: TextStyle(color: textColorThird)),
  );
}
