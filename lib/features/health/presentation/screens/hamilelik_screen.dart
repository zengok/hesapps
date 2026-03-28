import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import '../../../utility/data/services/history_service.dart';
import '../../../utility/data/models/calculation_history.dart';

class HamilelikScreen extends StatefulWidget {
  const HamilelikScreen({super.key});
  @override
  State<HamilelikScreen> createState() => _HamilelikScreenState();
}

class _HamilelikScreenState extends State<HamilelikScreen> {
  DateTime? _sonRegl;
  String? _resultText;
  bool _showResult = false;

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 28)),
      firstDate: DateTime.now().subtract(const Duration(days: 300)),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() { _sonRegl = picked; _showResult = false; });
  }

  void _calculate() {
    if (_sonRegl == null) return;
    // Naegele Kuralı: Tahmini Doğum = Son Regl + 280 gün
    final tahminiDogum = _sonRegl!.add(const Duration(days: 280));
    final bugun = DateTime.now();
    final gecenGun = bugun.difference(_sonRegl!).inDays;
    final hafta = gecenGun ~/ 7;
    final gun = gecenGun % 7;
    final kalanGun = tahminiDogum.difference(bugun).inDays;

    HistoryService.saveHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Hamilelik: ${_sonRegl!.day}/${_sonRegl!.month}/${_sonRegl!.year}',
      result: 'Tahmini Doğum: ${tahminiDogum.day}/${tahminiDogum.month}/${tahminiDogum.year}',
      date: DateTime.now(),
    ));
    setState(() {
      _resultText =
          'Hafta: $hafta hafta $gun gün\nTahmini Doğum: ${tahminiDogum.day}/${tahminiDogum.month}/${tahminiDogum.year}\nDoğuma Kalan: $kalanGun gün';
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CalculatorLayout(
      title: 'Hamilelik Takvimi',
      showResult: _showResult,
      resultText: _resultText,
      resultLabel: 'Hamilelik Bilgileri',
      onCalculate: _calculate,
      child: Column(children: [
        GestureDetector(
          onTap: () => _pickDate(context),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(children: [
              const Icon(LucideIcons.calendar, color: Colors.pink),
              const SizedBox(width: 12),
              Text(
                _sonRegl == null ? 'Son Regl Tarihini Seçin' : '${_sonRegl!.day}/${_sonRegl!.month}/${_sonRegl!.year}',
                style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 16),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}
