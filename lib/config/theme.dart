import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:image/image.dart' as img;
import 'package:palette_generator/palette_generator.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

@immutable
class BaseTheme extends ThemeExtension<BaseTheme> {
  const BaseTheme({
    this.primaryColor = const Color(0xFF9B4056),
    this.neutralColor = const Color(0xFF988e90),
    this.tertiaryColor = const Color(0xFF7A5832),
  });

  final Color primaryColor, tertiaryColor, neutralColor;

  @override
  ThemeExtension<BaseTheme> copyWith(
          {Color? primary, Color? tertiary, Color? neutral}) =>
      BaseTheme(
        primaryColor: primary ?? primaryColor,
        neutralColor: neutral ?? neutralColor,
        tertiaryColor: tertiary ?? tertiaryColor,
      );

  @override
  BaseTheme lerp(covariant ThemeExtension<BaseTheme>? other, double t) {
    if (other is! BaseTheme) return this;
    return BaseTheme(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      neutralColor: Color.lerp(neutralColor, other.neutralColor, t)!,
      tertiaryColor: Color.lerp(tertiaryColor, other.tertiaryColor, t)!,
    );
  }

  ThemeData toThemeData() {
    final primaryTextTheme = GoogleFonts.robotoFlexTextTheme();
    final condensedTextTheme = GoogleFonts.robotoCondensedTextTheme();
    final monoTextTheme = GoogleFonts.robotoMonoTextTheme();

    // final textTheme = primaryTextTheme.copyWith(
    //   displaySmall: condensedTextTheme.displaySmall;
    // );
    final textTheme = primaryTextTheme;
    return ThemeData(
      useMaterial3: true,
      textTheme: textTheme,
    );
  }

  // Scheme _scheme()
  // {
  //   final base = CorePalette.of(primaryColor.value);
  //   final primary = base.primary;
  //   final tertiary = CorePalette.of(tertiaryColor.value).primary;
  //   final neutral = CorePalette.of(neutralColor.value).neutral;
  //   return Scheme(
  //     primary: primary.get(40),
  //     onPrimary:

  //   );
  // }

  // static const lightColorScheme = ColorScheme(
  //   brightness: Brightness.light,
  //   primary: Color(0xFF9B4056),
  //   onPrimary: Color(0xFFFFFFFF),
  //   primaryContainer: Color(0xFFFFD9DE),
  //   onPrimaryContainer: Color(0xFF3F0016),
  //   secondary: Color(0xFF75565B),
  //   onSecondary: Color(0xFFFFFFFF),
  //   secondaryContainer: Color(0xFFFFD9DE),
  //   onSecondaryContainer: Color(0xFF2B1519),
  //   tertiary: Color(0xFF7A5832),
  //   onTertiary: Color(0xFFFFFFFF),
  //   tertiaryContainer: Color(0xFFFFDCBB),
  //   onTertiaryContainer: Color(0xFF2B1700),
  //   error: Color(0xFFBA1A1A),
  //   errorContainer: Color(0xFFFFDAD6),
  //   onError: Color(0xFFFFFFFF),
  //   onErrorContainer: Color(0xFF410002),
  //   background: Color(0xFFFFFBFF),
  //   onBackground: Color(0xFF201A1B),
  //   surface: Color(0xFFF6EEF6),
  //   onSurface: Color(0xFF201A1B),
  //   surfaceVariant: Color(0xFFF3DDE0),
  //   onSurfaceVariant: Color(0xFF524345),
  //   outline: Color(0xFF847375),
  //   onInverseSurface: Color(0xFFFAEEEE),
  //   inverseSurface: Color(0xFF362F2F),
  //   inversePrimary: Color(0xFFFFB2BF),
  //   shadow: Color(0xFF000000),
  //   surfaceTint: Color(0xFF9B4056),
  //   outlineVariant: Color(0xFFD6C2C4),
  //   scrim: Color(0xFF000000),
  // );

  // static const darkColorScheme = ColorScheme(
  //   brightness: Brightness.dark,
  //   primary: Color(0xFFFFB2BF),
  //   onPrimary: Color(0xFF5F1129),
  //   primaryContainer: Color(0xFF7D283F),
  //   onPrimaryContainer: Color(0xFFFFD9DE),
  //   secondary: Color(0xFFE4BDC2),
  //   onSecondary: Color(0xFF43292E),
  //   secondaryContainer: Color(0xFF5C3F44),
  //   onSecondaryContainer: Color(0xFFFFD9DE),
  //   tertiary: Color(0xFFEBBE90),
  //   onTertiary: Color(0xFF462A08),
  //   tertiaryContainer: Color(0xFF5F401D),
  //   onTertiaryContainer: Color(0xFFFFDCBB),
  //   error: Color(0xFFFFB4AB),
  //   errorContainer: Color(0xFF93000A),
  //   onError: Color(0xFF690005),
  //   onErrorContainer: Color(0xFFFFDAD6),
  //   background: Color(0xFF201A1B),
  //   onBackground: Color(0xFFECE0E0),
  //   surface: Color(0xFF201A1B),
  //   onSurface: Color(0xFFECE0E0),
  //   surfaceVariant: Color(0xFF524345),
  //   onSurfaceVariant: Color(0xFFD6C2C4),
  //   outline: Color(0xFF9F8C8E),
  //   onInverseSurface: Color(0xFF201A1B),
  //   inverseSurface: Color(0xFFECE0E0),
  //   inversePrimary: Color(0xFF9B4056),
  //   shadow: Color(0xFF000000),
  //   surfaceTint: Color(0xFFFFB2BF),
  //   outlineVariant: Color(0xFF524345),
  //   scrim: Color(0xFF000000),
  // );

  // static var lightTheme = ThemeData(
  //   useMaterial3: true,
  //   // cardTheme: CardTheme(
  //   //     elevation: 0,
  //   //     shape: RoundedRectangleBorder(
  //   //         borderRadius: BorderRadius.all(Radius.circular(20)))),
  //   textTheme: GoogleFonts.sourceSansProTextTheme(),
  //   colorScheme: lightColorScheme,
  //   // inputDecorationTheme: InputDecorationTheme(
  //   //   border: OutlineInputBorder(
  //   //     borderRadius: BorderRadius.circular(10),
  //   //     borderSide: const BorderSide(),
  //   //   ),
  //   //   isDense: true,
  //   // ),
  // );

  // final  darkTheme = ThemeData(colorScheme: darkColorScheme);
}

class CardTheme extends StatelessWidget {
  const CardTheme({
    super.key,
    required this.imageAsUint8List,
    required this.child,
  });

  final Widget child;

  final Uint8List imageAsUint8List;

  Future<ColorScheme> imageToScheme(ColorScheme base) async {
    var image = Image.memory(imageAsUint8List).image;
    final PaletteGenerator palette =
        await PaletteGenerator.fromImageProvider(image);

    final colors = palette.colors;

    if (colors.isEmpty) return base;

    final to = base.primary.value;
    final from = colors.first.value;

    final blended = Color(Blend.harmonize(from, to));

    final scheme =
        ColorScheme.fromSeed(seedColor: blended, brightness: base.brightness);

    return scheme;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder(
      future: imageToScheme(theme.colorScheme),
      builder: (context, snapshot) {
        final scheme = snapshot.data ?? theme.colorScheme;
        return Theme(data: theme.copyWith(colorScheme: scheme), child: child);
      },
    );
  }
}

// class CardTheme extends ThemeExtension<BaseTheme>
