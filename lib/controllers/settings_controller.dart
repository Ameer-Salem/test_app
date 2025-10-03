import 'package:flutter/material.dart';

enum ThemeModeOption { system, light, dark }

class SettingsController extends ChangeNotifier {

  ThemeModeOption _selected = ThemeModeOption.system;

  ThemeModeOption get selected => _selected;

  void updateTheme(ThemeModeOption newTheme) {
    _selected = newTheme;
    notifyListeners();
  }


}