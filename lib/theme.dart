import 'package:flutter/material.dart';

const Color primary = Color.fromRGBO(4, 41, 58, 1);
const Color primaryColorDark = Color.fromRGBO(4, 28, 50, 1);
const Color primaryColorAccent = Color.fromRGBO(236, 179, 101, 1);
const Color primaryColorLight = Color.fromRGBO(6, 70, 99, 1);

ColorScheme _customColorScheme = const ColorScheme(
    primary: primary,
    primaryVariant: primaryColorDark,
    secondary: primaryColorAccent,
    secondaryVariant: primaryColorAccent,
    surface: Colors.purpleAccent,
    background: Colors.white,
    error: Colors.redAccent,
    onPrimary: Colors.white,
    onSecondary: primaryColorDark,
    onSurface: primaryColorAccent,
    onBackground: primaryColorAccent,
    onError: Colors.redAccent,
    brightness: Brightness.light);

class GlobalTheme {
  final globalTheme = ThemeData(
    colorScheme: _customColorScheme,

    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      titleTextStyle: TextStyle(
          fontSize: 24.0,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold),
    ),

    switchTheme: SwitchThemeData(
        trackColor:
            MaterialStateProperty.all(primaryColorDark.withOpacity(0.5)),
        thumbColor: MaterialStateProperty.all(primaryColorDark),
        overlayColor: MaterialStateProperty.all(primaryColorAccent)),

    snackBarTheme: SnackBarThemeData(backgroundColor: primaryColorAccent),
    // Define the default font family.
    fontFamily: 'WorkSans',

    // Define the default `TextTheme`. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: const TextTheme(
      headline1: TextStyle(
          fontSize: 36.0, fontWeight: FontWeight.w800, color: primary),
      headline4: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: primary,
      ),
      headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyText2: TextStyle(fontSize: 12.0),
    ),
  );
}
