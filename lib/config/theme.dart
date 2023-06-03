import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palette_generator/palette_generator.dart';
// ignore: depend_on_referenced_packages
import 'package:material_color_utilities/material_color_utilities.dart';

@immutable
class BaseTheme extends ThemeExtension<BaseTheme> {
  const BaseTheme({
    this.primaryColor = const Color(0xFF9B4056),
    this.neutralColor = const Color(0xFF988e90),
    this.tertiaryColor = const Color(0xFF7A5832),
  });

  final Color primaryColor, tertiaryColor, neutralColor;

  // final scheme = ColorScheme.fromSeed(seedColor: primaryColor);

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

  Scheme _scheme() {
    final base = CorePalette.contentOf(primaryColor.value);
    final primary = base.primary;
    final tertiary = CorePalette.of(tertiaryColor.value).primary;
    final neutral = CorePalette.of(neutralColor.value).neutral;
    return Scheme(
      primary: primary.get(40),
      onPrimary: primary.get(100),
      primaryContainer: primary.get(90),
      onPrimaryContainer: primary.get(10),
      secondary: base.secondary.get(40),
      onSecondary: base.secondary.get(100),
      secondaryContainer: base.secondary.get(90),
      onSecondaryContainer: base.secondary.get(10),
      tertiary: tertiary.get(40),
      onTertiary: tertiary.get(100),
      tertiaryContainer: tertiary.get(90),
      onTertiaryContainer: tertiary.get(10),
      error: base.error.get(90),
      onError: base.error.get(100),
      errorContainer: base.error.get(90),
      onErrorContainer: base.error.get(10),
      background: neutral.get(99),
      onBackground: neutral.get(10),
      surface: neutral.get(99),
      onSurface: neutral.get(10),
      outline: base.neutralVariant.get(50),
      outlineVariant: base.neutralVariant.get(80),
      shadow: neutral.get(0),
      scrim: neutral.get(0),
      inverseSurface: neutral.get(20),
      inverseOnSurface: neutral.get(95),
      inversePrimary: primary.get(80),
      surfaceVariant: base.neutralVariant.get(90),
      onSurfaceVariant: base.neutralVariant.get(30),
    );
  }

  ThemeData _base(ColorScheme colorScheme) {
    final primaryTextTheme = GoogleFonts.robotoFlexTextTheme();
    final condensedTextTheme = GoogleFonts.robotoCondensedTextTheme();
    final monoTextTheme = GoogleFonts.robotoMonoTextTheme();

    // final textTheme = primaryTextTheme.copyWith(
    //   displaySmall: condensedTextTheme.displaySmall;
    // );

    final textTheme = primaryTextTheme;

    // final isLight = colorScheme.brightness == Brightness.light;
    return ThemeData(
        cardTheme: const CardTheme(
          elevation: 0,
        ),
        textTheme: textTheme,
        colorScheme: colorScheme,
        extensions: [this],
        // colorSchemeSeed: primaryColor,
        useMaterial3: true,
        filledButtonTheme: const FilledButtonThemeData(
            style: ButtonStyle(visualDensity: VisualDensity.comfortable))
        // scaffoldBackgroundColor: ,
        // scaffoldBackgroundColor: isLight ? neutralColor : colorScheme.background,
        );
  }

  ThemeData toThemeData(bool isDefault) {
    ColorScheme scheme = isDefault
        ? lightColorScheme
        : _scheme().toColorScheme(Brightness.light);

    return _base(scheme).copyWith(
        navigationRailTheme: NavigationRailThemeData(
          backgroundColor: scheme.onInverseSurface,
        ),
        navigationDrawerTheme: NavigationDrawerThemeData(
          backgroundColor: lightColorScheme.onInverseSurface,
        ),
        scaffoldBackgroundColor: scheme.onInverseSurface,
        brightness: Brightness.light);
  }

  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF9C404C),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFFFDADB),
    onPrimaryContainer: Color(0xFF40000F),
    secondary: Color(0xFF765658),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFFFDADB),
    onSecondaryContainer: Color(0xFF2C1517),
    tertiary: Color(0xFF775930),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFDDB5),
    onTertiaryContainer: Color(0xFF2A1800),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFFFFBFF),
    onBackground: Color(0xFF201A1A),
    outline: Color(0xFF857374),
    onInverseSurface: Color(0xFFFBEEEE),
    inverseSurface: Color(0xFF362F2F),
    inversePrimary: Color(0xFFFFB2B8),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF9C404C),
    outlineVariant: Color(0xFFD7C1C2),
    scrim: Color(0xFF000000),
    surface: Color(0xFFFFF8F7),
    onSurface: Color(0xFF201A1A),
    surfaceVariant: Color(0xFFF4DDDE),
    onSurfaceVariant: Color(0xFF524344),
  );

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
}

class CardPostTheme extends StatelessWidget {
  const CardPostTheme({
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
extension on Scheme {
  ColorScheme toColorScheme(Brightness brightness) {
    return ColorScheme(
        brightness: brightness,
        primary: Color(primary),
        onPrimary: Color(onPrimary),
        secondary: Color(secondary),
        onSecondary: Color(onSecondary),
        error: Color(error),
        onError: Color(onError),
        background: Color(background),
        onBackground: Color(onBackground),
        surface: Color(surface),
        onSurface: Color(onSurface));
  }
}
