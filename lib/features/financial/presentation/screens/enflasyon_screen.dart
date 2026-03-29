import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import '../../../utility/data/models/calculation_history.dart';
import '../../../utility/presentation/providers/history_provider.dart';

class EnflasyonScreen extends ConsumerStatefulWidget {
  const EnflasyonScreen({super.key});
  @override
  ConsumerState<EnflasyonScreen> createState() => _EnflasyonScreenState();
}

class _EnflasyonScreenState extends ConsumerState<EnflasyonScreen> {
  final _tutarCtrl = TextEditingController();
  final _oranCtrl = TextEditingController();
  final _yilCtrl = TextEditingController();
  String? _resultText;
  bool _showResult = false;

  void _calculate() {
    final tutar = double.tryParse(_tutarCtrl.text.replaceAll(',', '.'));
    final oran = double.tryParse(_oranCtrl.text.replaceAll(',', '.'));
    final yil = int.tryParse(_yilCtrl.text);
    if (tutar == null || oran == null || yil == null || tutar <= 0 || oran < 0 || yil < 1) return;

    // Bileşik enflasyon formülü: FV = PV * (1 + r)^n
    final gelecegiDeger = tutar * (1 + oran / 100) * yil;
    final satirAlmaGucu = (tutar / gelecegiDeger) * 100;

    ref.read(historyProvider.notifier).addHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Enflasyon: $tutar ₺ × $yil yıl @ %$oran',
      result: '$yil yıl sonra: ${gelecegiDeger.toStringAsFixed(2)} ₺',
      date: DateTime.now(),
    ));
    setState(() {
      _resultText =
          '$yil yıl sonra: ${gelecegiDeger.toStringAsFixed(2)} ₺\nBugünün satın alma gücü: %${satirAlmaGucu.toStringAsFixed(1)}';
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) => CalculatorLayout(
        title: 'Enflasyon Hesaplayıcı',
        showResult: _showResult,
        resultText: _resultText,
        resultLabel: 'Enflasyon Etkisi',
        onCalculate: _calculate,
        child: Column(children: [
          CustomInput(controller: _tutarCtrl, hintText: 'Tutar (₺)', keyboardType: const TextInputType.numberWithOptions(decimal: true), prefixIcon: LucideIcons.banknote, onChanged: (_) => setState(() => _showResult = false)),
          CustomInput(controller: _oranCtrl, hintText: 'Yıllık Enflasyon Oranı (%)', keyboardType: const TextInputType.numberWithOptions(decimal: true), prefixIcon: LucideIcons.trendingUp, onChanged: (_) => setState(() => _showResult = false)),
          CustomInput(controller: _yilCtrl, hintText: 'Süre (Yıl)', keyboardType: TextInputType.number, prefixIcon: LucideIcons.calendar, onChanged: (_) => setState(() => _showResult = false)),
        ]),
      );
}
