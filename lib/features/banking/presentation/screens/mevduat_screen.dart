import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import '../../../utility/data/models/calculation_history.dart';
import '../../../utility/presentation/providers/history_provider.dart';

class MevduatScreen extends ConsumerStatefulWidget {
  const MevduatScreen({super.key});
  @override
  ConsumerState<MevduatScreen> createState() => _MevduatScreenState();
}

class _MevduatScreenState extends ConsumerState<MevduatScreen> {
  final _tutarCtrl = TextEditingController();
  final _faizCtrl = TextEditingController();
  final _gunCtrl = TextEditingController();
  String? _resultText;
  bool _showResult = false;

  void _calculate() {
    final tutar = double.tryParse(_tutarCtrl.text.replaceAll(',', '.'));
    final faiz = double.tryParse(_faizCtrl.text.replaceAll(',', '.'));
    final gun = int.tryParse(_gunCtrl.text);
    if (tutar == null || faiz == null || gun == null || tutar <= 0 || faiz <= 0 || gun <= 0) return;

    // Basit faiz: Getiri = Anapara × Faiz/100 × Gün/365
    final getiri = tutar * (faiz / 100) * (gun / 365);
    final stopaj = getiri * 0.10; // %10 stopaj
    final netGetiri = getiri - stopaj;
    final toplam = tutar + netGetiri;

    ref.read(historyProvider.notifier).addHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Mevduat: $tutar ₺ × $gun gün @ %$faiz',
      result: 'Net Getiri: ${netGetiri.toStringAsFixed(2)} ₺',
      date: DateTime.now(),
    ));
    setState(() {
      _resultText =
          'Brüt Getiri: ${getiri.toStringAsFixed(2)} ₺\nStopaj (%10): ${stopaj.toStringAsFixed(2)} ₺\nNet Getiri: ${netGetiri.toStringAsFixed(2)} ₺\nToplam: ${toplam.toStringAsFixed(2)} ₺';
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) => CalculatorLayout(
        title: 'Mevduat Getirisi',
        showResult: _showResult,
        resultText: _resultText,
        resultLabel: 'Mevduat Analizi',
        onCalculate: _calculate,
        child: Column(children: [
          CustomInput(controller: _tutarCtrl, hintText: 'Anapara (₺)', keyboardType: const TextInputType.numberWithOptions(decimal: true), prefixIcon: LucideIcons.piggyBank, onChanged: (_) => setState(() => _showResult = false)),
          CustomInput(controller: _faizCtrl, hintText: 'Yıllık Faiz Oranı (%)', keyboardType: const TextInputType.numberWithOptions(decimal: true), prefixIcon: LucideIcons.percent, onChanged: (_) => setState(() => _showResult = false)),
          CustomInput(controller: _gunCtrl, hintText: 'Vade (Gün)', keyboardType: TextInputType.number, prefixIcon: LucideIcons.calendar, onChanged: (_) => setState(() => _showResult = false)),
        ]),
      );
}
