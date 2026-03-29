import 'package:flutter/widgets.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/search_tool.dart';

const List<SearchTool> allTools = [
  // FİNANSAL
  SearchTool(id: 'kredi', name: 'Kredi Hesaplama', keywords: ['kredi', 'faiz', 'taksit', 'loan', 'banka', 'kredi hesap', 'aylık taksit', 'pmt', 'kgf', 'bsmv', 'kkdf'], route: '/kredi', icon: 'building_2', usageRank: 1),
  SearchTool(id: 'maas', name: 'Maaş Hesaplama', keywords: ['maaş', 'vergi', 'net maaş', 'brüt', 'sgk', 'gelir vergisi', 'salary', 'ücret', 'kesinti'], route: '/maasvergi', icon: 'wallet', usageRank: 2),
  SearchTool(id: 'kdv', name: 'KDV Hesaplama', keywords: ['kdv', 'katma değer', 'vergi', 'vat', 'fatura', 'kdv dahil', 'kdv hariç', '%20', '%10', '%1'], route: '/kdv', icon: 'receipt', usageRank: 3),
  SearchTool(id: 'doviz', name: 'Döviz Çevirici', keywords: ['döviz', 'kur', 'dolar', 'euro', 'usd', 'eur', 'gbp', 'sterlin', 'çevir', 'kur çevirici', 'forex'], route: '/doviz', icon: 'arrow_left_right', usageRank: 4),
  SearchTool(id: 'iskonto', name: 'İskonto Hesaplama', keywords: ['iskonto', 'indirim', 'yüzde', 'hesap', 'ticari'], route: '/iskonto', icon: 'calculator', usageRank: 7),
  SearchTool(id: 'karmarji', name: 'Kar Marjı Hesaplama', keywords: ['kar', 'marj', 'kazanç', 'fiyat', 'satış', 'maliyet'], route: '/karmarji', icon: 'calculator', usageRank: 8),
  SearchTool(id: 'enflasyon', name: 'Enflasyon Hesaplama', keywords: ['enflasyon', 'tüfe', 'fiyat', 'oran', 'değer kaybı', 'zaman'], route: '/enflasyon', icon: 'calculator', usageRank: 9),

  // BANKACILIK
  SearchTool(id: 'mevduat', name: 'Mevduat Hesaplama', keywords: ['mevduat', 'faiz', 'getiri', 'para', 'vadeli'], route: '/mevduat', icon: 'building_2', usageRank: 10),
  SearchTool(id: 'kredikartiasgari', name: 'Kredi Kartı Asgari', keywords: ['kredi kartı', 'asgari', 'ödeme', 'taksit', 'banka', 'kart'], route: '/kredikartiasgari', icon: 'wallet', usageRank: 11),

  // SAĞLIK
  SearchTool(id: 'bmi', name: 'BMI Hesaplama', keywords: ['bmi', 'vücut kitle', 'kilo', 'boy', 'beden kitle indeksi', 'obezite', 'sağlık', 'ideal kilo'], route: '/bmi', icon: 'activity', usageRank: 5),
  SearchTool(id: 'idealkilo', name: 'İdeal Kilo Hesaplama', keywords: ['ideal kilo', 'kilo', 'boy', 'hedeflenen kilo', 'sağlık'], route: '/idealkilo', icon: 'activity', usageRank: 12),
  SearchTool(id: 'bmr', name: 'BMR (Kalori) Hesaplama', keywords: ['bmr', 'kalori', 'bazal metabolizma', 'enerji', 'diyet', 'sağlık'], route: '/bmr', icon: 'activity', usageRank: 13),
  SearchTool(id: 'sutuketimi', name: 'Su Tüketimi Hesaplama', keywords: ['su', 'içme', 'ihtiyaç', 'sıvı', 'tüketim', 'sağlık'], route: '/sutuketimi', icon: 'activity', usageRank: 14),
  SearchTool(id: 'hamilelik', name: 'Hamilelik Hesaplama', keywords: ['hamilelik', 'gebelik', 'doğum', 'bebek', 'hafta'], route: '/hamilelik', icon: 'activity', usageRank: 15),

  // TEKNİK
  SearchTool(id: 'birim', name: 'Birim Dönüştürücü', keywords: ['birim', 'çevirici', 'uzunluk', 'ağırlık', 'hacim', 'dönüşüm'], route: '/birim', icon: 'calculator', usageRank: 16),
  SearchTool(id: 'sicaklik', name: 'Sıcaklık Dönüştürücü', keywords: ['sıcaklık', 'derece', 'celsius', 'fahrenheit', 'kelvin', 'çevirici'], route: '/sicaklik', icon: 'calculator', usageRank: 17),
  SearchTool(id: 'yakit', name: 'Yakıt Tüketimi Hesaplama', keywords: ['yakıt', 'tüketim', 'araba', 'benzin', 'mazot', 'lpg', 'km', 'litre'], route: '/yakit', icon: 'calculator', usageRank: 18),
  SearchTool(id: 'internet', name: 'İnternet Hızı Hesaplama', keywords: ['internet', 'hız', 'bağlantı', 'ping', 'indirme', 'yükleme', 'mbps'], route: '/internet', icon: 'calculator', usageRank: 19),

  // EĞİTİM
  SearchTool(id: 'lgsyks', name: 'LGS/YKS Puanı Hesaplama', keywords: ['lgs', 'yks', 'puan', 'sınav', 'eğitim', 'okul', 'net'], route: '/lgsyks', icon: 'calculator', usageRank: 20),
  SearchTool(id: 'gno', name: 'GNO/Not Ortalaması', keywords: ['gno', 'ortalama', 'not', 'eğitim', 'okul', 'ders'], route: '/gno', icon: 'calculator', usageRank: 21),
  SearchTool(id: 'yas', name: 'Yaş Hesaplama', keywords: ['yaş', 'doğum tarihi', 'gün', 'ay', 'yıl', 'hesapla'], route: '/yas', icon: 'calculator', usageRank: 22),

  // GÜNLÜK
  SearchTool(id: 'bahsis', name: 'Bahşiş Hesaplama', keywords: ['bahşiş', 'hesap', 'restoran', 'ödeme', 'yüzde'], route: '/bahsis', icon: 'calculator', usageRank: 23),
  SearchTool(id: 'indirimfiyat', name: 'İndirim & Fiyat Hesaplama', keywords: ['indirim', 'fiyat', 'hesap', 'yüzde', 'alışveriş', 'kampanya'], route: '/indirimlifiyat', icon: 'calculator', usageRank: 24),
  SearchTool(id: 'tarihfarki', name: 'Tarih Farkı Hesaplama', keywords: ['tarih', 'fark', 'gün', 'ay', 'yıl', 'zaman', 'süre'], route: '/tarihfarki', icon: 'calculator', usageRank: 25),
];

IconData toolIcon(String iconName) {
  switch (iconName) {
    case 'building_2':   return LucideIcons.building2;
    case 'wallet':       return LucideIcons.wallet;
    case 'receipt':      return LucideIcons.coins;
    case 'arrow_left_right': return LucideIcons.arrowLeftRight;
    case 'activity':     return LucideIcons.activity;
    default:             return LucideIcons.calculator;
  }
}
