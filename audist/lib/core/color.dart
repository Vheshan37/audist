import 'dart:ui';

import 'package:flutter/cupertino.dart';

class AppColors {
  // private constructor to prevent instantiation
  AppColors._();

  static const Color primaryColor = Color(0xFF777C6D);
  static const Color secondaryColor = Color(0xFF57564F);
  static const Color darkGreyColor = Color(0xFF8E8E8B);
  static const Color lightGreyColor = Color(0xFFCBCBCB);
  static const Color accentColor = Color(0xFF82CCDD);
  static const Color errorColor = Color(0xFFE55039);
  static const Color successColor = Color(0xFF78E08F);
  static const Color warningColor = Color(0xFFF6B93B);
  static const Color infoColor = Color(0xFF60A3BC);
  static const Color background = Color(0xFFF9F8F8);
  static const Color forground = Color(0xFF57564F);

  // === Brand / Primary Theme ===
  static const Color brandDark = Color(0xFF423736); // deep brown-gray tone
  static const Color brandAccentDark = Color(0xFF883964); // muted rose accent
  static const Color brandAccent = Color(0xFF987185); // muted rose accent

  static const Color labelBluePrimary = Color(0xFF0055CD); // deep brown-gray tone
  static const Color labelBlueSecondary = Color(0x3C004A98); // deep brown-gray tone

  // === Backgrounds ===
  static const Color backgroundLight = Color(0xFFF8F5F1); // main app background
  static const Color backgroundMuted = Color(
    0xFFDDD7CE,
  ); // secondary bg (cards, modals)

  // === Neutrals / Surfaces ===
  static const Color surfaceDark = Color(0xFF57564F); // text, icons on light bg
  static const Color surfaceSecondary = Color(
    0xFF858585,
  ); // text, icons on light bg
  static const Color surfaceLight = Color(0xFFF5F5F5); // card background

  // === Highlights / Warm Tones ===
  static const Color highlightSoft = Color(
    0xFFF4E2D1,
  ); // subtle highlight (headers, dividers)
  static const Color highlightWarm = Color(
    0xFFE9D5B7,
  ); // warmer highlight (buttons, accents)

  static const Gradient primaryGradient = LinearGradient(
    colors: [brandDark, brandAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient highlightGradient = LinearGradient(
    colors: [backgroundLight, backgroundMuted],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
