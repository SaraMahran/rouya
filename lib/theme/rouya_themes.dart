import 'package:flutter/material.dart';

// ─── Rouya Theme Tokens ───────────────────────────────────────────────────────
// Mirrors the exact colors from the Claude Design prototype (themes.js)

class RouyaColors {
  // Feminine Power palette
  static const femBg0        = Color(0xFF0F0420);
  static const femBg1        = Color(0xFF1A0A2E);
  static const femBg2        = Color(0xFF241040);
  static const femAccent     = Color(0xFFFF2D7A); // electric rose
  static const femAccent2    = Color(0xFFC77DFF); // lavender
  static const femGold       = Color(0xFFF2C76E);
  static const femText       = Color(0xFFFBEFFF);
  static const femTextDim    = Color(0x9EFBEFFF);
  static const femTextFaint  = Color(0x61FBEFFF);
  static const femSurface    = Color(0x0AFFFFFF);
  static const femSurfaceHi  = Color(0x12FFFFFF);
  static const femBorder     = Color(0x2EC77DFF);
  static const femNavBg      = Color(0xC70F0420);

  // Obsidian palette
  static const obsBg0        = Color(0xFF050505);
  static const obsBg1        = Color(0xFF0D0D0D);
  static const obsBg2        = Color(0xFF161616);
  static const obsAccent     = Color(0xFF00F5D4); // teal
  static const obsAccent2    = Color(0xFF4CC9F0); // electric blue
  static const obsGold       = Color(0xFFFFD166);
  static const obsText       = Color(0xFFECFEFB);
  static const obsTextDim    = Color(0x99ECFEFB);
  static const obsTextFaint  = Color(0x57ECFEFB);
  static const obsSurface    = Color(0x09FFFFFF);
  static const obsSurfaceHi  = Color(0x0FFFFFFF);
  static const obsBorder     = Color(0x2900F5D4);
  static const obsNavBg      = Color(0xD1050505);

}

// ─── Theme Data class passed around the app ───────────────────────────────────
class RouyaTheme {
  final bool isFeminine;
  double glowMul = 1.0;
  double radius = 22.0;
  RouyaTheme({required this.isFeminine});

  // Backgrounds
  Color get bg0   => isFeminine ? RouyaColors.femBg0    : RouyaColors.obsBg0;
  Color get bg1   => isFeminine ? RouyaColors.femBg1    : RouyaColors.obsBg1;
  Color get bg2   => isFeminine ? RouyaColors.femBg2    : RouyaColors.obsBg2;

  // Accents
  Color get accent  => isFeminine ? RouyaColors.femAccent    : RouyaColors.obsAccent;
  Color get accent2  => isFeminine ? RouyaColors.femAccent2    : RouyaColors.obsAccent2;
  Color get gold  => isFeminine ? RouyaColors.femGold    : RouyaColors.obsGold;

  // Text color that reads well on top of accent-colored backgrounds
  Color get onAccent => isFeminine ? Colors.white : RouyaColors.obsBg0;

  // Text
  Color get text  => isFeminine ? RouyaColors.femText    : RouyaColors.obsText;
  Color get textDim  => isFeminine ? RouyaColors.femTextDim    : RouyaColors.obsTextDim;
  Color get textFaint  => isFeminine ? RouyaColors.femTextFaint    : RouyaColors.obsTextFaint;

  // Surfaces
  Color get surface  => isFeminine ? RouyaColors.femSurface    : RouyaColors.obsSurface;
  Color get surfaceHi  => isFeminine ? RouyaColors.femSurfaceHi    : RouyaColors.obsSurfaceHi;
  Color get border  => isFeminine ? RouyaColors.femBorder    : RouyaColors.obsBorder;
  Color get navBg  => isFeminine ? RouyaColors.femNavBg    : RouyaColors.obsNavBg;

  // Tints (for card background)
  Color get accentTint  => accent.withValues(alpha: 0.14);
  Color get accent2Tint  => accent2.withValues(alpha: 0.16);
  Color get goldTint  => gold.withValues(alpha: 0.14);

  // Glow shadows
  List<BoxShadow> get glowAccent => [
    BoxShadow(color: accent.withValues(alpha: 0.35 * glowMul),
        blurRadius: 32, spreadRadius: 0)
  ];
  List<BoxShadow> get glowAccent2 => [
    BoxShadow(color: accent2.withValues(alpha: 0.35 * glowMul),
        blurRadius: 28, spreadRadius: 0)
  ];

  List<BoxShadow> get glowGold => [
    BoxShadow(color: gold.withValues(alpha: 0.35 * glowMul),
        blurRadius: 24, spreadRadius: 0)
  ];


  // Background gradient
  Gradient get bgGradient => isFeminine
      ? const RadialGradient(
    center: Alignment(-0.6, -0.8),
    radius: 1.2,
    colors: [Color(0xFF0F1A1E), Color(0xFF1A0A2E), Color(0xFF0F0420)],
    stops: [0.0, 0.5, 1.0],
  )
      : const RadialGradient(
    center: Alignment(0.6, -0.8),
    radius: 1.2,
    colors: [Color(0xFF0F1A1E), Color(0xFF0D0D0D), Color(0xFF050505)],
    stops: [0.0, 0.5, 1.0],
  );

  // Material ThemeData for widgets that need it
  ThemeData get materialTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bg0,
    colorScheme: ColorScheme.dark(
      primary: accent,
      secondary: accent2,
      surface: bg1,
    ),
    splashColor: accent.withValues(alpha: 0.1),
    highlightColor: accent.withValues(alpha: 0.05),
  );

}