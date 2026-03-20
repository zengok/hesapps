import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/calculator_model.dart';
import '../core/constants.dart';

class AppDataProvider extends ChangeNotifier {
  List<Category> get categories => AppConstants.categories;
  
  List<CalculatorItem> get calculators => AppConstants.calculators;

  /// Kategori ID'sine göre o kategoriye ait araçları filtreleyip getirir
  List<CalculatorItem> getCalculatorsByCategory(String categoryId) {
    return calculators.where((calc) => calc.categoryId == categoryId).toList();
  }
  
  /// Arama yapmak için (İleride eklenebilecek bir Search özelliği)
  List<CalculatorItem> searchCalculators(String query) {
    if (query.isEmpty) return [];
    return calculators.where((calc) => 
      calc.title.toLowerCase().contains(query.toLowerCase())).toList();
  }
}
