import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chess_app/helper/chess_colors.dart';

class ThemeProvider extends ChangeNotifier{
  ChessColors _currentTheme = availableThemes[0];
  ChessColors get currentTheme => _currentTheme;
  ThemeProvider(){
    _loadTheme();
  }

  void setTheme(ChessColors theme) async {
  _currentTheme = theme;
  notifyListeners();
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('themeName', theme.name);
}

void _loadTheme() async {
  final prefs = await SharedPreferences.getInstance();
  final themeName = prefs.getString('themeName') ?? 'Classic';
  _currentTheme = availableThemes.firstWhere(
    (theme) => theme.name == themeName,
    orElse: () => availableThemes[0], // Fallback to the first theme if not found
  );
  notifyListeners();
}
}

