import 'package:flutter/material.dart';

class CalculatorItem {
  final String id;
  final String title;
  final IconData icon;
  final String route;
  final String categoryId;

  const CalculatorItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.route,
    required this.categoryId,
  });
}
