import 'package:flutter/material.dart';

/// Basit, zero-dependency localization — intl paketi gerektirmez.
/// Dil değişikliği anında gerçekleşir, restart gerekmez.
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('tr'),
    Locale('en'),
    Locale('de'),
    Locale('ar'),
  ];

  static const Map<String, Map<String, String>> _localizedStrings = {
    'tr': {
      // Genel
      'app_name': 'Tüm Hesaplamalar',
      'hello': 'Merhaba,',
      'what_to_calculate': 'Ne hesaplamak istersin?',
      'all_tools': 'Tüm Araçlar',
      'favorites': 'Favoriler',
      'recent': 'Son İşlemler',
      'calculate': 'Hesapla',
      'result': 'Sonuç',
      'close': 'Kapat',
      'share_result': 'Sonucu Paylaş',
      'back': 'Geri',
      'tools_suffix': 'ARAÇ',

      // Navigasyon
      'nav_home': 'Ana Sayfa',
      'nav_history': 'Geçmiş',
      'nav_search': 'Ara',
      'nav_settings': 'Ayarlar',

      // Ayarlar
      'settings': 'Ayarlar',
      'dark_mode': 'Karanlık Mod',
      'language': 'Dil Seçimi',
      'about': 'Hakkımızda',
      'rate_app': 'Uygulamayı Puanla',

      // Kategoriler
      'cat_finansal': 'FİNANSAL',
      'cat_bankacilik': 'BANKACILIK',
      'cat_saglik': 'SAĞLIK',
      'cat_teknik': 'TEKNİK',
      'cat_egitim': 'EĞİTİM',
      'cat_gunluk': 'GÜNLÜK',
      'calculation_tools': 'Hesaplama Araçları',

      // Hesaplayıcı ekranları
      'calculation_result': 'Hesaplama Sonucu',
    },
    'en': {
      'app_name': 'All Calculators',
      'hello': 'Hello,',
      'what_to_calculate': 'What would you like to calculate?',
      'all_tools': 'All Tools',
      'favorites': 'Favorites',
      'recent': 'Recent',
      'calculate': 'Calculate',
      'result': 'Result',
      'close': 'Close',
      'share_result': 'Share Result',
      'back': 'Back',
      'tools_suffix': 'TOOLS',
      'nav_home': 'Home',
      'nav_history': 'History',
      'nav_search': 'Search',
      'nav_settings': 'Settings',
      'settings': 'Settings',
      'dark_mode': 'Dark Mode',
      'language': 'Language',
      'about': 'About',
      'rate_app': 'Rate App',
      'cat_finansal': 'FINANCIAL',
      'cat_bankacilik': 'BANKING',
      'cat_saglik': 'HEALTH',
      'cat_teknik': 'TECHNICAL',
      'cat_egitim': 'EDUCATION',
      'cat_gunluk': 'DAILY',
      'calculation_tools': 'Calculation Tools',
      'calculation_result': 'Calculation Result',
    },
    'de': {
      'app_name': 'Alle Rechner',
      'hello': 'Hallo,',
      'what_to_calculate': 'Was möchten Sie berechnen?',
      'all_tools': 'Alle Tools',
      'favorites': 'Favoriten',
      'recent': 'Letzte',
      'calculate': 'Berechnen',
      'result': 'Ergebnis',
      'close': 'Schließen',
      'share_result': 'Ergebnis teilen',
      'back': 'Zurück',
      'tools_suffix': 'TOOLS',
      'nav_home': 'Startseite',
      'nav_history': 'Verlauf',
      'nav_search': 'Suchen',
      'nav_settings': 'Einstellungen',
      'settings': 'Einstellungen',
      'dark_mode': 'Dunkler Modus',
      'language': 'Sprache',
      'about': 'Über uns',
      'rate_app': 'App bewerten',
      'cat_finansal': 'FINANZIELL',
      'cat_bankacilik': 'BANKEN',
      'cat_saglik': 'GESUNDHEIT',
      'cat_teknik': 'TECHNISCH',
      'cat_egitim': 'BILDUNG',
      'cat_gunluk': 'TÄGLICH',
      'calculation_tools': 'Berechnungstools',
      'calculation_result': 'Berechnungsergebnis',
    },
    'ar': {
      'app_name': 'جميع الحاسبات',
      'hello': 'مرحباً،',
      'what_to_calculate': 'ماذا تريد أن تحسب؟',
      'all_tools': 'جميع الأدوات',
      'favorites': 'المفضلة',
      'recent': 'الأخيرة',
      'calculate': 'احسب',
      'result': 'النتيجة',
      'close': 'إغلاق',
      'share_result': 'مشاركة النتيجة',
      'back': 'رجوع',
      'tools_suffix': 'أداة',
      'nav_home': 'الرئيسية',
      'nav_history': 'السجل',
      'nav_search': 'بحث',
      'nav_settings': 'الإعدادات',
      'settings': 'الإعدادات',
      'dark_mode': 'الوضع المظلم',
      'language': 'اللغة',
      'about': 'حول',
      'rate_app': 'تقييم التطبيق',
      'cat_finansal': 'مالي',
      'cat_bankacilik': 'مصرفي',
      'cat_saglik': 'صحة',
      'cat_teknik': 'تقني',
      'cat_egitim': 'تعليم',
      'cat_gunluk': 'يومي',
      'calculation_tools': 'أدوات الحساب',
      'calculation_result': 'نتيجة الحساب',
    },
  };

  String get(String key) {
    final langCode = locale.languageCode;
    final langMap = _localizedStrings[langCode] ?? _localizedStrings['tr']!;
    return langMap[key] ?? _localizedStrings['tr']![key] ?? key;
  }

  // Convenience getters
  String get appName => get('app_name');
  String get hello => get('hello');
  String get whatToCalculate => get('what_to_calculate');
  String get allTools => get('all_tools');
  String get favorites => get('favorites');
  String get recent => get('recent');
  String get calculate => get('calculate');
  String get result => get('result');
  String get close => get('close');
  String get shareResult => get('share_result');
  String get settings => get('settings');
  String get darkMode => get('dark_mode');
  String get language => get('language');
  String get about => get('about');
  String get rateApp => get('rate_app');
  String get navHome => get('nav_home');
  String get navHistory => get('nav_history');
  String get navSearch => get('nav_search');
  String get navSettings => get('nav_settings');
  String get toolsSuffix => get('tools_suffix');
  String get calculationTools => get('calculation_tools');
  String get calculationResult => get('calculation_result');

  /// Kategori ID'sine göre lokalize isim
  String categoryName(String categoryId) {
    return get('cat_$categoryId');
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
