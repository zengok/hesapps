import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import '../../../utility/data/services/history_service.dart';
import '../../../utility/data/models/calculation_history.dart';

class KrediKartiScreen extends StatefulWidget {
  const KrediKartiScreen({super.key});
  @override
  State<KrediKartiScreen> createState() => _KrediKartiScreenState();
}

class _KrediKartiScreenState extends State<KrediKartiScreen> {
  final _borcCtrl = TextEditingController();
  final _faizCtrl = TextEditingController();
  String? _resultText;
  bool _showResult = false;

  void _calculate() {
    final borc = double.tryParse(_borcCtrl.text.replaceAll(',', '.'));
    final faiz = double.tryParse(_faizCtrl.text.replaceAll(',', '.'));
    if (borc == null || faiz == null || borc <= 0 || faiz <= 0) return;

    // Asgari ödeme = Borç × %3 (BDDK minimum)
    final asgari = borc * 0.03;
    // Aylık faiz tutarı
    final aylikFaiz = borc * (faiz / 100);
    // Bu ödemede anaparaya giden
    final anaparaOdeme = asgari - aylikFaiz;

    HistoryService.saveHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Kredi Kartı Asgari: $borc ₺',
      result: 'Asgari Ödeme: ${asgari.toStringAsFixed(2)} ₺',
      date: DateTime.now(),
    ));
    setState(() {
      _resultText =
          'Asgari Ödeme (%3): ${asgari.toStringAsFixed(2)} ₺\nÖdenen Faiz: ${aylikFaiz.toStringAsFixed(2)} ₺\nAnaparaya Giden: ${anaparaOdeme > 0 ? anaparaOdeme.toStringAsFixed(2) : '0.00'} ₺';
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) => CalculatorLayout(
        title: 'Kredi Kartı Asgari Tutar',
        showResult: _showResult,
        resultText: _resultText,
        resultLabel: 'Ödeme Detayı',
        onCalculate: _calculate,
        child: Column(children: [
          CustomInput(controller: _borcCtrl, hintText: 'Toplam Borç (₺)', keyboardType: const TextInputType.numberWithOptions(decimal: true), prefixIcon: LucideIcons.creditCard, onChanged: (_) => setState(() => _showResult = false)),
          CustomInput(controller: _faizCtrl, hintText: 'Aylık Faiz Oranı (%)', keyboardType: const TextInputType.numberWithOptions(decimal: true), prefixIcon: LucideIcons.percent, onChanged: (_) => setState(() => _showResult = false)),
        ]),
      );
}
