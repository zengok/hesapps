import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import '../../../utility/data/models/calculation_history.dart';
import '../../../utility/presentation/providers/history_provider.dart';

class IskontoScreen extends ConsumerStatefulWidget {
  const IskontoScreen({super.key});
  @override
  ConsumerState<IskontoScreen> createState() => _IskontoScreenState();
}

class _IskontoScreenState extends ConsumerState<IskontoScreen> {
  final _fiyatCtrl = TextEditingController();
  final _oranCtrl = TextEditingController();
  String? _resultText;
  bool _showResult = false;

  void _calculate() {
    final fiyat = double.tryParse(_fiyatCtrl.text.replaceAll(',', '.'));
    final oran = double.tryParse(_oranCtrl.text.replaceAll(',', '.'));
    if (fiyat == null || oran == null || fiyat <= 0 || oran < 0) return;

    final indirilenTutar = fiyat * oran / 100;
    final sonFiyat = fiyat - indirilenTutar;

    ref.read(historyProvider.notifier).addHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'İskonto: $fiyat ₺ - %$oran',
      result: 'Son Fiyat: ${sonFiyat.toStringAsFixed(2)} ₺',
      date: DateTime.now(),
    ));
    setState(() {
      _resultText =
          'İndirim Tutarı: ${indirilenTutar.toStringAsFixed(2)} ₺\nSon Fiyat: ${sonFiyat.toStringAsFixed(2)} ₺';
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) => CalculatorLayout(
        title: 'İskonto (İndirim) Hesaplama',
        showResult: _showResult,
        resultText: _resultText,
        resultLabel: 'İndirim Sonucu',
        onCalculate: _calculate,
        child: Column(children: [
          CustomInput(controller: _fiyatCtrl, hintText: 'Orijinal Fiyat (₺)', keyboardType: const TextInputType.numberWithOptions(decimal: true), prefixIcon: LucideIcons.tag, onChanged: (_) => setState(() => _showResult = false)),
          CustomInput(controller: _oranCtrl, hintText: 'İskonto Oranı (%)', keyboardType: const TextInputType.numberWithOptions(decimal: true), prefixIcon: LucideIcons.percent, onChanged: (_) => setState(() => _showResult = false)),
        ]),
      );
}
