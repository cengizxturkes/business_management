import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/theme/data/models/theme_model.dart';

class ThemeService {
  static const String _themeKey = 'app_theme';

  static Future<void> saveTheme(ThemeModel theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, jsonEncode(theme.toJson()));
  }

  static Future<ThemeModel?> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeJson = prefs.getString(_themeKey);
    if (themeJson != null) {
      return ThemeModel.fromJson(jsonDecode(themeJson));
    }
    return null;
  }
}
