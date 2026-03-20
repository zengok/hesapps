import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/category_model.dart';
import '../models/calculator_model.dart';
import 'theme.dart';

class AppConstants {
  static const String appName = 'Tüm Hesaplamalar';

  // 6 Kategorimiz
  static const List<Category> categories = [
    Category(id: 'finansal', title: 'FİNANSAL', color: AppTheme.emerald, icon: LucideIcons.wallet),
    Category(id: 'bankacilik', title: 'BANKACILIK', color: AppTheme.indigo, icon: LucideIcons.building),
    Category(id: 'saglik', title: 'SAĞLIK', color: AppTheme.rose, icon: LucideIcons.heartPulse),
    Category(id: 'teknik', title: 'TEKNİK', color: Colors.blueGrey, icon: LucideIcons.wrench),
    Category(id: 'egitim', title: 'EĞİTİM', color: AppTheme.amber, icon: LucideIcons.graduationCap),
    Category(id: 'gunluk', title: 'GÜNLÜK', color: Colors.deepPurple, icon: LucideIcons.coffee),
  ];

  // Hesaplama Araçları (Calculator Items)
  static const List<CalculatorItem> calculators = [
    // 1. FİNANSAL
    CalculatorItem(id: 'kdv', title: 'KDV (Ekleme/Ayırma)', icon: LucideIcons.percent, route: '/calc/kdv', categoryId: 'finansal'),
    CalculatorItem(id: 'iskonto', title: 'İskonto (İndirim)', icon: LucideIcons.tags, route: '/calc/iskonto', categoryId: 'finansal'),
    CalculatorItem(id: 'karmarji', title: 'Kar Marjı', icon: LucideIcons.trendingUp, route: '/calc/karmarji', categoryId: 'finansal'),
    CalculatorItem(id: 'enflasyon', title: 'Enflasyon Hesaplayıcı', icon: LucideIcons.barChart, route: '/calc/enflasyon', categoryId: 'finansal'),

    // 2. BANKACILIK
    CalculatorItem(id: 'kreditaksit', title: 'Kredi Taksit (İht. / Konut)', icon: LucideIcons.home, route: '/calc/kreditaksit', categoryId: 'bankacilik'),
    CalculatorItem(id: 'mevduatgetirisi', title: 'Mevduat Getirisi', icon: LucideIcons.piggyBank, route: '/calc/mevduatgetirisi', categoryId: 'bankacilik'),
    CalculatorItem(id: 'kredikartiasgari', title: 'Kredi Kartı Asgari Tutar', icon: LucideIcons.creditCard, route: '/calc/kredikartiasgari', categoryId: 'bankacilik'),
    CalculatorItem(id: 'doviz', title: 'Döviz Çevirici', icon: LucideIcons.dollarSign, route: '/calc/doviz', categoryId: 'bankacilik'),

    // 3. SAĞLIK
    CalculatorItem(id: 'bmi', title: 'BMI (VKE)', icon: LucideIcons.activity, route: '/calc/bmi', categoryId: 'saglik'),
    CalculatorItem(id: 'idealkilo', title: 'İdeal Kilo', icon: LucideIcons.scale, route: '/calc/idealkilo', categoryId: 'saglik'),
    CalculatorItem(id: 'bmr', title: 'Günlük Kalori (BMR)', icon: LucideIcons.flame, route: '/calc/bmr', categoryId: 'saglik'),
    CalculatorItem(id: 'sutuketimi', title: 'Su Tüketimi Takibi', icon: LucideIcons.droplet, route: '/calc/sutuketimi', categoryId: 'saglik'),
    CalculatorItem(id: 'hamilelik', title: 'Hamilelik Takvimi', icon: LucideIcons.baby, route: '/calc/hamilelik', categoryId: 'saglik'),

    // 4. TEKNİK
    CalculatorItem(id: 'birim', title: 'Birim Dönüştürücü', icon: LucideIcons.refreshCw, route: '/calc/birim', categoryId: 'teknik'),
    CalculatorItem(id: 'sicaklik', title: 'Sıcaklık Çevirici', icon: LucideIcons.thermometer, route: '/calc/sicaklik', categoryId: 'teknik'),
    CalculatorItem(id: 'yakit', title: 'Yakıt Tüketimi', icon: LucideIcons.fuel, route: '/calc/yakit', categoryId: 'teknik'),
    CalculatorItem(id: 'internet', title: 'İnternet Hızı (MB-Mb)', icon: LucideIcons.wifi, route: '/calc/internet', categoryId: 'teknik'),

    // 5. EĞİTİM
    CalculatorItem(id: 'lgsyks', title: 'LGS/YKS Net Hesaplama', icon: LucideIcons.calculator, route: '/calc/lgsyks', categoryId: 'egitim'),
    CalculatorItem(id: 'gno', title: 'GNO / Dönemlik Not', icon: LucideIcons.bookOpen, route: '/calc/gno', categoryId: 'egitim'),
    CalculatorItem(id: 'yas', title: 'Yaş Hesaplayıcı', icon: LucideIcons.calendarDays, route: '/calc/yas', categoryId: 'egitim'),

    // 6. GÜNLÜK
    CalculatorItem(id: 'bahsis', title: 'Bahşiş Hesaplama', icon: LucideIcons.coins, route: '/calc/bahsis', categoryId: 'gunluk'),
    CalculatorItem(id: 'indirimlifiyat', title: 'İndirimli Fiyat', icon: LucideIcons.tag, route: '/calc/indirimlifiyat', categoryId: 'gunluk'),
    CalculatorItem(id: 'tarihfarki', title: 'Tarih Farkı', icon: LucideIcons.calendarClock, route: '/calc/tarihfarki', categoryId: 'gunluk'),
  ];
}
