import 'package:flutter/material.dart';

/// Mid violet from the same family as the lilac app icon (`#C9A8F0`).
const Color _seed = Color(0xFF6F5A96);

const Color _darkSurface = Color(0xFF241E30);
const Color _darkSurfaceContainerLow = Color(0xFF2C263A);
const Color _darkSurfaceContainer = Color(0xFF342C44);
const Color _darkSurfaceContainerHigh = Color(0xFF3C3450);
const Color _darkSurfaceContainerHighest = Color(0xFF463C5C);

ThemeData buildAppTheme({Brightness brightness = Brightness.light}) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: _seed,
    brightness: brightness,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

ThemeData buildLightTheme() => buildAppTheme(brightness: Brightness.light);

ThemeData buildDarkTheme() {
  final theme = buildAppTheme(brightness: Brightness.dark);
  final scheme = theme.colorScheme.copyWith(
    surface: _darkSurface,
    surfaceContainerLow: _darkSurfaceContainerLow,
    surfaceContainer: _darkSurfaceContainer,
    surfaceContainerHigh: _darkSurfaceContainerHigh,
    surfaceContainerHighest: _darkSurfaceContainerHighest,
  );
  return theme.copyWith(
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: theme.appBarTheme.copyWith(backgroundColor: scheme.surface),
  );
}

abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}
