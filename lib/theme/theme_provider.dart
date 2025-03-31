import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isDark = false;

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _isDark;

  Future<void> loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDark = prefs.getBool('isDark') ?? false;
      _themeMode = _isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    } catch (e) {
      // Fallback to light theme if error occurs
      _isDark = false;
      _themeMode = ThemeMode.light;
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    try {
      _isDark = !_isDark;
      _themeMode = _isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDark', _isDark);
    } catch (e) {
      // Revert changes if error occurs
      _isDark = !_isDark;
      notifyListeners();
    }
  }
}