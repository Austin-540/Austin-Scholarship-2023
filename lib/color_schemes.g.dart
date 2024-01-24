import 'package:flutter/material.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF00658F),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFC8E6FF),
  onPrimaryContainer: Color(0xFF001E2E),
  secondary: Color(0xFF4F616E),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFD2E5F5),
  onSecondaryContainer: Color(0xFF0B1D29),
  tertiary: Color(0xFF00658F),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFC7E7FF), //Using this as success container
  onTertiaryContainer: Color(0xFF001E2E),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFCFCFF),
  onBackground: Color(0xFF191C1E),
  surface: Color(0xFFFCFCFF),
  onSurface: Color(0xFF191C1E),
  surfaceVariant: Color(0xFFDDE3EA),
  onSurfaceVariant: Color(0xFF41484D),
  outline: Color(0xFF71787E),
  onInverseSurface: Color(0xFFF0F0F3),
  inverseSurface: Color(0xFF2E3133),
  inversePrimary: Color(0xFF86CEFF),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF00658F),
  outlineVariant: Color(0xFFC1C7CE),
  scrim: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF86CEFF),
  onPrimary: Color(0xFF00344C),
  primaryContainer: Color(0xFF004C6D),
  onPrimaryContainer: Color(0xFFC8E6FF),
  secondary: Color(0xFFB7C9D8),
  onSecondary: Color(0xFF21323E),
  secondaryContainer: Color(0xFF384956),
  onSecondaryContainer: Color(0xFFD2E5F5),
  tertiary: Color(0xFF86CFFF),
  onTertiary: Color(0xFF00344C),
  tertiaryContainer: Color.fromARGB(255, 0, 36, 109),
  onTertiaryContainer: Color(0xFFC7E7FF),
  error: Color(0xFFFFB4AB),
  errorContainer: Color.fromARGB(255, 91, 0, 6),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF191C1E),
  onBackground: Color(0xFFE2E2E5),
  surface: Color(0xFF191C1E),
  onSurface: Color(0xFFE2E2E5),
  surfaceVariant: Color(0xFF41484D),
  onSurfaceVariant: Color(0xFFC1C7CE),
  outline: Color(0xFF8B9198),
  onInverseSurface: Color(0xFF191C1E),
  inverseSurface: Color(0xFFE2E2E5),
  inversePrimary: Color.fromARGB(255, 32, 77, 211),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF86CEFF),
  outlineVariant: Color(0xFF41484D),
  scrim: Color(0xFF000000),
);
