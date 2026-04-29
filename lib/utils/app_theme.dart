import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppColors {
  static const mahogany = Color(0xFF4A2C20);
  static const darkMahogany = Color(0xFF301A12);
  static const cream = Color(0xFFFBF3E2);
  static const ivory = Color(0xFFF7EBD3);
  static const gold = Color(0xFFCBA135);
  static const deepGold = Color(0xFFA0791E);
  static const wood = Color(0xFF8B5A2B);
  static const woodDark = Color(0xFF5C3A1E);
  static const parchment = Color(0xFFF5E6C8);
  static const inkBrown = Color(0xFF3B2412);
  static const shelfShadow = Color(0xFF2A1810);
  static const nightBg = Color(0xFF1B1108);
  static const nightSurface = Color(0xFF2A1A10);
}

class AppTheme {
  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.mahogany,
        brightness: Brightness.light,
        primary: AppColors.mahogany,
        secondary: AppColors.gold,
        surface: AppColors.ivory,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.mahogany,
        foregroundColor: AppColors.cream,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: GoogleFonts.lora(
          color: AppColors.cream,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
      textTheme: GoogleFonts.loraTextTheme(base.textTheme).apply(
        bodyColor: AppColors.inkBrown,
        displayColor: AppColors.darkMahogany,
      ),
      cardTheme: CardTheme(
        color: AppColors.ivory,
        elevation: 4,
        shadowColor: AppColors.shelfShadow.withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      iconTheme: const IconThemeData(color: AppColors.mahogany),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.darkMahogany,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.deepGold,
        thickness: 1.2,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.parchment,
        modalBackgroundColor: AppColors.parchment,
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.nightBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.mahogany,
        brightness: Brightness.dark,
        primary: AppColors.gold,
        secondary: AppColors.deepGold,
        surface: AppColors.nightSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkMahogany,
        foregroundColor: AppColors.cream,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: GoogleFonts.lora(
          color: AppColors.cream,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
      textTheme: GoogleFonts.loraTextTheme(base.textTheme).apply(
        bodyColor: AppColors.parchment,
        displayColor: AppColors.cream,
      ),
      cardTheme: CardTheme(
        color: AppColors.nightSurface,
        elevation: 4,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      iconTheme: const IconThemeData(color: AppColors.gold),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.darkMahogany,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.deepGold,
        thickness: 1.2,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.nightSurface,
        modalBackgroundColor: AppColors.nightSurface,
      ),
    );
  }

  static TextStyle englishReadingStyle(double fontSize, Brightness brightness) {
    return GoogleFonts.merriweather(
      fontSize: fontSize,
      height: 1.7,
      color: brightness == Brightness.light
          ? AppColors.inkBrown
          : AppColors.parchment,
    );
  }

  static TextStyle urduReadingStyle(double fontSize, Brightness brightness) {
    return TextStyle(
      fontFamily: 'NotoNastaliqUrdu',
      fontSize: fontSize + 2,
      height: 2.2,
      color: brightness == Brightness.light
          ? AppColors.inkBrown
          : AppColors.parchment,
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  static const _kDarkModeKey = 'app_dark_mode';
  bool _isDark = false;
  bool get isDark => _isDark;

  ThemeProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool(_kDarkModeKey) ?? false;
    notifyListeners();
  }

  Future<void> toggle() async {
    _isDark = !_isDark;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kDarkModeKey, _isDark);
  }
}
