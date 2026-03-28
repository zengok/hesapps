import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CurrencyRepository {
  final Dio _dio = Dio();
  final String _cacheKey = 'cached_exchange_rates';

  Future<Map<String, double>> fetchRates({String baseCurrency = 'USD'}) async {
    try {
      final response = await _dio.get('https://api.frankfurter.app/latest?from=$baseCurrency');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> ratesJson = response.data['rates'];
        final rates = ratesJson.map((key, value) => MapEntry(key, (value as num).toDouble()));
        rates[baseCurrency] = 1.0; 
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_cacheKey, jsonEncode(rates));
        
        return rates;
      } else {
        return await _getOfflineRates();
      }
    } catch (e) {
      return await _getOfflineRates();
    }
  }

  Future<Map<String, double>> _getOfflineRates() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_cacheKey);
    if (cachedData != null) {
      final Map<String, dynamic> decoded = jsonDecode(cachedData);
      return decoded.map((key, value) => MapEntry(key, (value as num).toDouble()));
    }
    
    return {
      "USD": 1.0,
      "TRY": 32.50,
      "EUR": 0.92,
      "GBP": 0.79,
      "JPY": 151.30,
    };
  }
}
