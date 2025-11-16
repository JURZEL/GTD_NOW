import 'package:flutter/material.dart';

class AppTheme {
  // Centralized theme configuration. We use a seed color to generate a
  // Material 3 ColorScheme, then customize a few roles intentionally so
  // that accents and focusable actions (FAB, important buttons) stand out.
  static ThemeData light() {
    const seed = Color(0xFF00695C); // teal – good contrast and calm accent
    final base = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light);
    // Start from the generated scheme but explicitly ensure high-contrast
    // pairs for critical roles to meet Material accessibility guidance.
    final colorScheme = base.copyWith(
      // make the secondary color a warm accent to draw attention when needed
      secondary: const Color(0xFFFFA000), // amber
      // keep a bright tertiary for small accents
      tertiary: const Color(0xFFFF7043), // deep orange
      // explicit readable foreground/background pairs
      primary: const Color(0xFF00695C),
      onPrimary: Colors.white,
  surface: Colors.white,
  onSurface: Colors.black87,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      // Typography tuned to match Android Material scale
      textTheme: TextTheme(
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
        bodyMedium: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colorScheme.onPrimary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 1,
        centerTitle: false,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
      ),
      // Card visuals are adjusted locally on the widgets to avoid Theme API
      // incompatibilities across Flutter versions.
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        horizontalTitleGap: 12,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          minimumSize: const Size(64, 48),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          foregroundColor: colorScheme.onSecondary,
          minimumSize: const Size(64, 48),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary.withAlpha(31)),
          minimumSize: const Size(64, 44),
        ),
      ),
      // Floating action button: slightly elevated and prominent on Android
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
        elevation: 6,
        extendedIconLabelSpacing: 8,
      ),
      // Chips and cards use surfaceVariant and secondaryContainer to create
      // subtle groups and stronger highlighted states respectively.
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.secondaryContainer,
        labelStyle: TextStyle(color: colorScheme.onSurface, fontSize: 13),
        secondaryLabelStyle: TextStyle(color: colorScheme.onSecondaryContainer, fontSize: 13),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
      // Cards keep default theming; margins and shapes are set where needed.
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.surface,
        contentTextStyle: TextStyle(color: colorScheme.onSurface),
      ),
    );
  }

  static ThemeData dark() {
    const seed = Color(0xFF00695C);
    final base = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark);
    // For dark mode, ensure onSurface/onBackground have sufficient contrast
    final colorScheme = base.copyWith(
      secondary: const Color(0xFFFFA000),
      tertiary: const Color(0xFFFF7043),
      primary: const Color(0xFF00695C),
      onPrimary: Colors.white,
  surface: const Color(0xFF121212),
  onSurface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      textTheme: TextTheme(
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: colorScheme.onSurface),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
        bodyMedium: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 1,
        centerTitle: false,
      ),
      // Card visuals are adjusted locally on the widgets to avoid Theme API
      // incompatibilities across Flutter versions.
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        horizontalTitleGap: 12,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          foregroundColor: colorScheme.onSecondary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.onSurface.withAlpha(31)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.secondaryContainer,
        labelStyle: TextStyle(color: colorScheme.onSurface),
        secondaryLabelStyle: TextStyle(color: colorScheme.onSecondaryContainer),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      // Cards keep default theming; margins and shapes are set where needed.
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.surface,
        contentTextStyle: TextStyle(color: colorScheme.onSurface),
      ),
    );
  }
}
