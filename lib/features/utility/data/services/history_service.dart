import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/calculation_history.dart';

class HistoryService {
  static const String _historyKey = 'calculation_history';

  static Future<void> saveHistory(CalculationHistory history) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> records = prefs.getStringList(_historyKey) ?? [];

    records.insert(0, jsonEncode(history.toJson()));

    // Lazy loading için 100 kayıt limitine çıkarıldı
    if (records.length > 100) {
      records = records.sublist(0, 100);
    }

    await prefs.setStringList(_historyKey, records);
  }

  static Future<List<CalculationHistory>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> records = prefs.getStringList(_historyKey) ?? [];
    return records
        .map((r) => CalculationHistory.fromJson(jsonDecode(r)))
        .toList();
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}

