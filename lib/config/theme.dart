import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF9B4056),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFFFD9DE),
    onPrimaryContainer: Color(0xFF3F0016),
    secondary: Color(0xFF75565B),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFFFD9DE),
    onSecondaryContainer: Color(0xFF2B1519),
    tertiary: Color(0xFF7A5832),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFDCBB),
    onTertiaryContainer: Color(0xFF2B1700),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFFFFBFF),
    onBackground: Color(0xFF201A1B),
    surface: Color(0xFFF6EEF6),
    onSurface: Color(0xFF201A1B),
    surfaceVariant: Color(0xFFF3DDE0),
    onSurfaceVariant: Color(0xFF524345),
    outline: Color(0xFF847375),
    onInverseSurface: Color(0xFFFAEEEE),
    inverseSurface: Color(0xFF362F2F),
    inversePrimary: Color(0xFFFFB2BF),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF9B4056),
    outlineVariant: Color(0xFFD6C2C4),
    scrim: Color(0xFF000000),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFFB2BF),
    onPrimary: Color(0xFF5F1129),
    primaryContainer: Color(0xFF7D283F),
    onPrimaryContainer: Color(0xFFFFD9DE),
    secondary: Color(0xFFE4BDC2),
    onSecondary: Color(0xFF43292E),
    secondaryContainer: Color(0xFF5C3F44),
    onSecondaryContainer: Color(0xFFFFD9DE),
    tertiary: Color(0xFFEBBE90),
    onTertiary: Color(0xFF462A08),
    tertiaryContainer: Color(0xFF5F401D),
    onTertiaryContainer: Color(0xFFFFDCBB),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF201A1B),
    onBackground: Color(0xFFECE0E0),
    surface: Color(0xFF201A1B),
    onSurface: Color(0xFFECE0E0),
    surfaceVariant: Color(0xFF524345),
    onSurfaceVariant: Color(0xFFD6C2C4),
    outline: Color(0xFF9F8C8E),
    onInverseSurface: Color(0xFF201A1B),
    inverseSurface: Color(0xFFECE0E0),
    inversePrimary: Color(0xFF9B4056),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFFFFB2BF),
    outlineVariant: Color(0xFF524345),
    scrim: Color(0xFF000000),
  );

  // static const lightScheme = ColorScheme.light(
  //   primary: Color(0xff1E3648),
  //   onPrimary: Color(0xffffffff),
  //   secondary: Color(0xffE0E3E5),
  //   onSecondary: Color(0xff0C1811),
  //   // error: Color(0xffba1a1a),
  //   // onError: Color(0xffffffff),
  //   background: Color(0xffffffff),
  //   onBackground: Color(0xff0C1811),
  //   // surface: Color(0xfffffbff),
  //   // onSurface: Color(0xff201a1b),
  //   tertiary: Color(0xffEA8585),
  //   onTertiary: Color(0xffffffff),
  //   // outline: Color(0xff837377),
  //   // primaryContainer: Color(0xffffd9e2),
  //   // onPrimaryContainer: Color(0xff3e001d),
  //   // tertiaryContainer: Color(0xffffdcc2),
  //   // onTertiaryContainer: Color(0xff2e1500),
  //   // surfaceVariant: Color(0xfff2dde2),
  //   // onSurfaceVariant: Color(0xff514347),
  // );

  // static const darkScheme = ColorScheme.dark(
  //   primary: Color(0xffffb0c8),
  //   onPrimary: Color(0xff650033),
  //   primaryContainer: Color(0xff87174a),
  //   onPrimaryContainer: Color(0xffffd9e2),
  //   secondary: Color(0xffe3bdc6),
  //   onSecondary: Color(0xff422931),
  //   secondaryContainer: Color(0xff5a3f47),
  //   onSecondaryContainer: Color(0xffffd9e2),
  //   tertiary: Color(0xffefbd94),
  //   onTertiary: Color(0xff48290c),
  //   tertiaryContainer: Color(0xff623f20),
  //   onTertiaryContainer: Color(0xffffdcc2),
  //   error: Color(0xffffb4ab),
  //   onError: Color(0xff690005),
  //   background: Color(0xff201a1b),
  //   onBackground: Color(0xffebe0e1),
  //   surface: Color(0xff201a1b),
  //   onSurface: Color(0xffebe0e1),
  //   outline: Color(0xff9e8c90),
  //   surfaceVariant: Color(0xff514347),
  //   onSurfaceVariant: Color(0xffd5c2c6),
  // );

  static var lightTheme = ThemeData(
    useMaterial3: true,
    cardTheme: const CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)))),
    textTheme: GoogleFonts.rubikTextTheme(),
    colorScheme: lightColorScheme,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(),
      ),
      isDense: true,
    ),
  );

  var darkTheme = ThemeData(colorScheme: darkColorScheme);

  // static const magenta = Color.fromRGBO(119, 67, 96, 1);
  // static const darkMagenta = Color.fromRGBO(76, 58, 81, 1);
  // static const lightMagenta = Color.fromRGBO(178, 80, 104, 1);
  // static const accentYellow = Color.fromRGBO(231, 171, 121, 1);

  // static const darkPink = Color.fromRGBO(187, 74, 133, 1);
  // static const pink = Color.fromRGBO(244, 227, 233, 1);
  // static const white = Colors.white;
}
