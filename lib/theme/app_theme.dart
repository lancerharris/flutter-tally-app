import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const mainColor = Color.fromRGBO(255, 80, 0, 1);
  static const halfwayColor = Color.fromRGBO(128, 128, 128, 1);
  static const secondaryColor = Color.fromRGBO(0, 175, 255, 1);
  // static const secondaryColor = Color.fromRGBO(28, 202, 142, 1);
  static const disabledColor = Color.fromRGBO(100, 100, 100, 0.5);
  static const errorColor = Color.fromRGBO(255, 51, 51, 1);
  static const secondaryCardColor = Color.fromRGBO(80, 80, 80, 1);
  static const scratchBoxColor = Color.fromRGBO(100, 100, 100, 1);

  // consider yellow to blue for light theme
  // FFFF55 #00AEFF

  // 1
  static TextTheme lightTextTheme = TextTheme(
    bodyText1: GoogleFonts.handlee(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    headline1: GoogleFonts.permanentMarker(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    headline2: GoogleFonts.handlee(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    button: GoogleFonts.permanentMarker(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    headline3: GoogleFonts.handlee(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    headline6: GoogleFonts.permanentMarker(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  );

  static TextTheme disabledThemes = TextTheme(
    button: GoogleFonts.permanentMarker(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: Colors.grey,
    ),
  );
  // 2
  static TextTheme darkTextTheme = TextTheme(
    bodyText1: GoogleFonts.handlee(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headline1: GoogleFonts.permanentMarker(
      fontStyle: FontStyle.italic,
      letterSpacing: 1.2,
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headline2: GoogleFonts.handlee(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    button: GoogleFonts.permanentMarker(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headline3: GoogleFonts.handlee(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headline6: GoogleFonts.permanentMarker(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  );

  // 3
  static ThemeData light() {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: Brightness.light,
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith(
          (states) {
            return Colors.black;
          },
        ),
      ),
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black,
        backgroundColor: mainColor,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedIconTheme: IconThemeData(color: Colors.white),
        unselectedIconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: lightTextTheme,
    );
  }

  // 4
  static ThemeData dark() {
    return ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: mainColor,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedIconTheme: IconThemeData(color: Colors.white),
          unselectedIconTheme: IconThemeData(color: Colors.white),
          backgroundColor: mainColor,
        ),
        textTheme: darkTextTheme,
        errorColor: errorColor);
  }
}
