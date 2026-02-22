import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class TearDropTheme {
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF1E40AF);
  static const Color secondary = Color(0xFF60A5FA);
  static const Color backgroundLight = Color(0xFFF0F5FF);
  static const Color backgroundMedium = Color(0xFFDBEAFE);
  static const Color tearGold = Color(0xFFFFB74D);
  static const Color tearBlue = Color(0xFF93C5FD);
  static const Color errorRed = Color(0xFFDC2626);
  static const Color surfaceWhite = Color(0xFFFAFBFD);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);

  static ThemeData get lightTheme {
    final base = GoogleFonts.notoSansKrTextTheme();
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        primary: primary,
        secondary: secondary,
        surface: surfaceWhite,
      ),
      scaffoldBackgroundColor: surfaceWhite,
      textTheme: base,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        backgroundColor: surfaceWhite,
        surfaceTintColor: Colors.transparent,
        foregroundColor: textPrimary,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: GoogleFonts.notoSansKr(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.notoSansKr(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: const BorderSide(color: border),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 64,
        backgroundColor: surfaceWhite,
        surfaceTintColor: Colors.transparent,
        indicatorColor: primary.withValues(alpha: 0.1),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.notoSansKr(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: primary,
            );
          }
          return GoogleFonts.notoSansKr(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: textSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(size: 22, color: primary);
          }
          return const IconThemeData(size: 22, color: textSecondary);
        }),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border, width: 0.5),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 0.5,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 2,
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
