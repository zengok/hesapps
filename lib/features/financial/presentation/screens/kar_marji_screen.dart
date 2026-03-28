import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import '../../../utility/data/services/history_service.dart';
import '../../../utility/data/models/calculation_history.dart';

class KarMarjiScreen extends StatefulWidget {
  const KarMarjiScreen({super.key});
  @override
  State<KarMarjiScreen> createState() => _KarMarjiScreenState();
}

class _KarMarjiScreenState extends State<KarMarjiScreen> {
  final _maliyetCtrl = TextEditingController();
  final _satisCtrl = TextEditingController();
  String? _resultText;
  bool _showResult = false;

  void _calculate() {
    final maliyet = double.tryParse(_maliyetCtrl.text.replaceAll(',', '.'));
    final satis = double.tryParse(_satisCtrl.text.replaceAll(',', '.'));
    if (maliyet == null || satis == null || maliyet <= 0 || satis <= 0) return;

    final kar = satis - maliyet;
    final karMarji = (kar / satis) * 100;
    final karOrani = (kar / maliyet) * 100;

    HistoryService.saveHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Kar Marjı: $maliyet → $satis ₺',
      result: 'Kar Marjı: %${karMarji.toStringAsFixed(2)}',
      date: DateTime.now(),
    ));
    setState(() {
      _resultText =
          'Kar: ${kar.toStringAsFixed(2)} ₺\nKar Marjı: %${karMarji.toStringAsFixed(2)}\nKar Oranı (Mark-up): %${karOrani.toStringAsFixed(2)}';
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) => CalculatorLayout(
        title: 'Kar Marjı Hesaplama',
        showResult: _showResult,
        resultText: _resultText,
        resultLabel: 'Kar Analizi',
        onCalculate: _calculate,
        child: Column(children: [
          CustomInput(controller: _maliyetCtrl, hintText: 'Maliyet Fiyatı (₺)', keyboardType: const TextInputType.numberWithOptions(decimal: true), prefixIcon: LucideIcons.packageOpen, onChanged: (_) => setState(() => _showResult = false)),
          CustomInput(controller: _satisCtrl, hintText: 'Satış Fiyatı (₺)', keyboardType: const TextInputType.numberWithOptions(decimal: true), prefixIcon: LucideIcons.shoppingCart, onChanged: (_) => setState(() => _showResult = false)),
        ]),
      );
}
