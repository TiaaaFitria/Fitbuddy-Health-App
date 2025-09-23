import 'package:flutter/foundation.dart';

class SettingsModel extends ChangeNotifier {
  bool _isDarkMode = false;
  String _language = "en";

  bool get isDarkMode => _isDarkMode;
  String get language => _language;

  set isDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  set language(String value) {
    if (value.isNotEmpty) {
      _language = value;
      notifyListeners();
    }
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setLanguage(String lang) {
    if (lang.isNotEmpty) {
      _language = lang;
      notifyListeners();
    }
  }
}
