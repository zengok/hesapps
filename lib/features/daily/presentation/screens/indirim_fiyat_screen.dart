import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import '../../../utility/data/models/calculation_history.dart';
import '../../../utility/presentation/providers/history_provider.dart';

class IndirimFiyatScreen extends ConsumerStatefulWidget {
  const IndirimFiyatScreen({super.key});
  @override
  ConsumerState<IndirimFiyatScreen> createState() => _IndirimFiyatScreenState();
}

class _IndirimFiyatScreenState extends ConsumerState<IndirimFiyatScreen> {
  final _fiyatCtrl = TextEditingController();
  final _oranCtrl = TextEditingController();
  String? _resultText;
  bool _showResult = false;

  void _calculate() {
    final fiyat = double.tryParse(_fiyatCtrl.text.replaceAll(',', '.'));
    final oran = double.tryParse(_oranCtrl.text.replaceAll(',', '.'));
    if (fiyat == null || oran == null || fiyat <= 0 || oran < 0 || oran > 100) return;
    final indirim = fiyat * oran / 100;
    final sonFiyat = fiyat - indirim;
    ref.read(historyProvider.notifier).addHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'İndirimli Fiyat: $fiyat ₺ - %$oran',
      result: 'Son: ${sonFiyat.toStringAsFixed(2)} ₺',
      date: DateTime.now(),
    ));
    setState(() {
      _resultText = 'İndirim: ${indirim.toStringAsFixed(2)} ₺\nSon Fiyat: ${sonFiyat.toStringAsFixed(2)} ₺';
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) => CalculatorLayout(
        title: 'İndirimli Fiyat Hesaplama',
        showResult: _showResult,
        resultText: _resultText,
        resultLabel: 'İndirim Sonucu',
        onCalculate: _calculate,
        child: Column(children: [
          CustomInput(controller: _fiyatCtrl, hintText: 'Orijinal Fiyat (₺)', keyboardType: const TextInputType.numberWithOptions(decimal: true), prefixIcon: LucideIcons.shoppingBag, onChanged: (_) => setState(() => _showResult = false)),
          CustomInput(controller: _oranCtrl, hintText: 'İndirim Oranı (%)', keyboardType: const TextInputType.numberWithOptions(decimal: true), prefixIcon: LucideIcons.tag, onChanged: (_) => setState(() => _showResult = false)),
        ]),
      );
}
