import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import '../../../utility/data/services/history_service.dart';
import '../../../utility/data/models/calculation_history.dart';

class BahsisScreen extends StatefulWidget {
  const BahsisScreen({super.key});
  @override
  State<BahsisScreen> createState() => _BahsisScreenState();
}

class _BahsisScreenState extends State<BahsisScreen> {
  final _tutarCtrl = TextEditingController();
  final _kisCtrl = TextEditingController();
  double _oran = 10;
  String? _resultText;
  bool _showResult = false;

  void _calculate() {
    final tutar = double.tryParse(_tutarCtrl.text.replaceAll(',', '.'));
    final kis = int.tryParse(_kisCtrl.text) ?? 1;
    if (tutar == null || tutar <= 0) return;

    final toplamBahsis = tutar * _oran / 100;
    final kisiBasina = toplamBahsis / kis;

    HistoryService.saveHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Bahşiş: $tutar ₺ × %${_oran.toInt()}',
      result: 'Toplam: ${toplamBahsis.toStringAsFixed(2)} ₺',
      date: DateTime.now(),
    ));
    setState(() {
      _resultText = 'Toplam Bahşiş (%${_oran.toInt()}): ${toplamBahsis.toStringAsFixed(2)} ₺'
          '\n${kis > 1 ? 'Kişi Başına: ${kisiBasina.toStringAsFixed(2)} ₺' : ''}';
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CalculatorLayout(
      title: 'Bahşiş Hesaplama',
      showResult: _showResult,
      resultText: _resultText,
      resultLabel: 'Bahşiş',
      onCalculate: _calculate,
      child: Column(children: [
        CustomInput(controller: _tutarCtrl, hintText: 'Hesap Tutarı (₺)', keyboardType: const TextInputType.numberWithOptions(decimal: true), prefixIcon: LucideIcons.fileText, onChanged: (_) => setState(() => _showResult = false)),
        CustomInput(controller: _kisCtrl, hintText: 'Kişi Sayısı', keyboardType: TextInputType.number, prefixIcon: LucideIcons.users, onChanged: (_) => setState(() => _showResult = false)),
        const SizedBox(height: 12),
        Text('Bahşiş Oranı: %${_oran.toInt()}', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
        Slider(
          value: _oran, min: 5, max: 30, divisions: 5,
          activeColor: Colors.amber,
          onChanged: (v) => setState(() { _oran = v; _showResult = false; }),
        ),
      ]),
    );
  }
}
