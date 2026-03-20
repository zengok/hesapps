import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  // Başlangıç dili Türkçe olsun
  Locale _currentLocale = const Locale('tr');

  Locale get currentLocale => _currentLocale;

  void changeLanguage(String languageCode) {
    _currentLocale = Locale(languageCode);
    notifyListeners();
  }
}
