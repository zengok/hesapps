import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/category_model.dart';
import '../models/calculator_model.dart';
import 'theme.dart';

class AppConstants {
  static const String appName = 'Tüm Hesaplamalar';

  // 7 Kategorimiz
  static const List<Category> categories = [
    Category(id: 'finansal',  title: 'FİNANSAL',   color: AppTheme.emerald,      icon: LucideIcons.wallet),
    Category(id: 'bankacilik',title: 'BANKACILIK',  color: AppTheme.indigo,       icon: LucideIcons.building),
    Category(id: 'saglik',    title: 'SAĞLIK',      color: AppTheme.rose,         icon: LucideIcons.heartPulse),
    Category(id: 'teknik',    title: 'TEKNİK',      color: Colors.blueGrey,       icon: LucideIcons.wrench),
    Category(id: 'egitim',    title: 'EĞİTİM',      color: AppTheme.amber,        icon: LucideIcons.graduationCap),
    Category(id: 'gunluk',    title: 'GÜNLÜK',      color: Colors.deepPurple,     icon: LucideIcons.coffee),
    Category(id: 'kargo',     title: 'KARGO & TİC.', color: Color(0xFFFF7043),   icon: LucideIcons.package),
  ];

  // Hesaplama Araçları (Calculator Items)
  static const List<CalculatorItem> calculators = [
    // 1. FİNANSAL
    CalculatorItem(id: 'kdv',            title: 'KDV (Ekleme/Ayırma)',     icon: LucideIcons.percent,     route: '/kdv',            categoryId: 'finansal'),
    CalculatorItem(id: 'maasvergi',      title: 'Maaş & Gelir Vergisi (2026)', icon: LucideIcons.fileText, route: '/maasvergi',     categoryId: 'finansal'),
    CalculatorItem(id: 'iskonto',        title: 'İskonto (İndirim)',        icon: LucideIcons.tags,        route: '/iskonto',        categoryId: 'finansal'),
    CalculatorItem(id: 'karmarji',       title: 'Kar Marjı',                icon: LucideIcons.trendingUp,  route: '/karmarji',       categoryId: 'finansal'),
    CalculatorItem(id: 'enflasyon',      title: 'Enflasyon Hesaplayıcı',   icon: LucideIcons.barChart,    route: '/enflasyon',      categoryId: 'finansal'),
    CalculatorItem(id: 'faiz',           title: 'Faiz Hesaplama',           icon: LucideIcons.percent,     route: '/faiz',           categoryId: 'finansal'),
    CalculatorItem(id: 'kidemtazminati', title: 'Kıdem Tazminatı (2026)',  icon: LucideIcons.briefcase,   route: '/kidemtazminati', categoryId: 'finansal'),

    // 2. BANKACILIK
    CalculatorItem(id: 'kreditaksit',      title: 'Kredi Taksit (İht. / Konut)', icon: LucideIcons.home,       route: '/kredi',            categoryId: 'bankacilik'),
    CalculatorItem(id: 'mevduatgetirisi',  title: 'Mevduat Getirisi',            icon: LucideIcons.piggyBank,  route: '/mevduat',          categoryId: 'bankacilik'),
    CalculatorItem(id: 'kredikartiasgari', title: 'Kredi Kartı Asgari Tutar',    icon: LucideIcons.creditCard, route: '/kredikartiasgari', categoryId: 'bankacilik'),
    CalculatorItem(id: 'doviz',            title: 'Döviz Çevirici',              icon: LucideIcons.dollarSign, route: '/doviz',            categoryId: 'bankacilik'),

    // 3. SAĞLIK
    CalculatorItem(id: 'bmi',        title: 'BMI (VKE)',           icon: LucideIcons.activity,   route: '/bmi',        categoryId: 'saglik'),
    CalculatorItem(id: 'idealkilo',  title: 'İdeal Kilo',          icon: LucideIcons.scale,      route: '/idealkilo',  categoryId: 'saglik'),
    CalculatorItem(id: 'bmr',        title: 'Günlük Kalori (BMR)', icon: LucideIcons.flame,      route: '/bmr',        categoryId: 'saglik'),
    CalculatorItem(id: 'sutuketimi', title: 'Su Tüketimi Takibi',  icon: LucideIcons.droplet,    route: '/sutuketimi', categoryId: 'saglik'),
    CalculatorItem(id: 'hamilelik',  title: 'Hamilelik Takvimi',   icon: LucideIcons.baby,       route: '/hamilelik',  categoryId: 'saglik'),

    // 4. TEKNİK
    CalculatorItem(id: 'birim',    title: 'Birim Dönüştürücü',    icon: LucideIcons.refreshCw,   route: '/birim',    categoryId: 'teknik'),
    CalculatorItem(id: 'sicaklik', title: 'Sıcaklık Çevirici',    icon: LucideIcons.thermometer, route: '/sicaklik', categoryId: 'teknik'),
    CalculatorItem(id: 'yakit',    title: 'Yakıt Tüketimi',       icon: LucideIcons.fuel,        route: '/yakit',    categoryId: 'teknik'),
    CalculatorItem(id: 'internet', title: 'İnternet Hızı (MB-Mb)',icon: LucideIcons.wifi,        route: '/internet', categoryId: 'teknik'),

    // 5. EĞİTİM
    CalculatorItem(id: 'lgsyks', title: 'LGS/YKS Net Hesaplama', icon: LucideIcons.calculator, route: '/lgsyks', categoryId: 'egitim'),
    CalculatorItem(id: 'gno',    title: 'GNO / Dönemlik Not',    icon: LucideIcons.bookOpen,   route: '/gno',    categoryId: 'egitim'),
    CalculatorItem(id: 'yas',    title: 'Yaş Hesaplayıcı',       icon: LucideIcons.calendarDays,route: '/yas',   categoryId: 'egitim'),
    CalculatorItem(id: 'kpss',   title: 'KPSS Puan Hesaplama',   icon: LucideIcons.pencil,     route: '/kpss',   categoryId: 'egitim'),

    // 6. GÜNLÜK
    CalculatorItem(id: 'bahsis',        title: 'Bahşiş Hesaplama',    icon: LucideIcons.coins,       route: '/bahsis',        categoryId: 'gunluk'),
    CalculatorItem(id: 'indirimlifiyat',title: 'İndirimli Fiyat',     icon: LucideIcons.tag,         route: '/indirimlifiyat',categoryId: 'gunluk'),
    CalculatorItem(id: 'tarihfarki',    title: 'Tarih Farkı',         icon: LucideIcons.calendarClock,route: '/tarihfarki',  categoryId: 'gunluk'),
    CalculatorItem(id: 'yuzde',         title: 'Yüzde Hesaplama',     icon: LucideIcons.percent,     route: '/yuzde',         categoryId: 'gunluk'),

    // 7. KARGO & TİCARET
    CalculatorItem(id: 'desi', title: 'Desi Hesaplama', icon: LucideIcons.package, route: '/desi', categoryId: 'kargo'),
  ];
}
