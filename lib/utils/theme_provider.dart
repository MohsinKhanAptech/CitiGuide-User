import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode currentTheme = ThemeMode.system;

  Future<void> getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? theme = sharedPreferences.getString('theme');

    if (theme == 'light') {
      currentTheme = ThemeMode.light;
    } else if (theme == 'dark') {
      currentTheme = ThemeMode.dark;
    } else {
      currentTheme = ThemeMode.system;
    }
    notifyListeners();
  }

  Future<void> changeTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (currentTheme == ThemeMode.light) {
      currentTheme = ThemeMode.dark;
      sharedPreferences.setString('theme', 'dark');
    } else {
      currentTheme = ThemeMode.light;
      sharedPreferences.setString('theme', 'light');
    }
    notifyListeners();
  }
}
