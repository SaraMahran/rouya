import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/rouya_themes.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isFeminine = true;

  bool get isFeminine => _isFeminine;
  RouyaTheme get theme => RouyaTheme(isFeminine: _isFeminine);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _isFeminine = prefs.getBool('isFeminine') ?? true;
    notifyListeners();
  }

  Future<void> toggle() async {
    _isFeminine = !_isFeminine;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFeminine', _isFeminine);
    notifyListeners();
  }
}