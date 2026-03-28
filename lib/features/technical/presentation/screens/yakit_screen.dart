import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import '../../../utility/data/services/history_service.dart';
import '../../../utility/data/models/calculation_history.dart';

class YakitScreen extends StatefulWidget {
  const YakitScreen({super.key});
  @override
  State<YakitScreen> createState() => _YakitScreenState();
}

class _YakitScreenState extends State<YakitScreen> {
  final _kmCtrl = TextEditingController();
  final _yakitCtrl = TextEditingController();
  final _fiyatCtrl = TextEditingController();
  String? _resultText;
  bool _showResult = false;

  void _calculate() {
    final km = double.tryParse(_kmCtrl.text.replaceAll(',', '.'));
    final yakit = double.tryParse(_yakitCtrl.text.replaceAll(',', '.'));
    final fiyat = double.tryParse(_fiyatCtrl.text.replaceAll(',', '.'));
    if (km == null || yakit == null || km <= 0 || yakit <= 0) return;

    final tuketim100 = (yakit / km) * 100;
    double? maliyet;
    if (fiyat != null && fiyat > 0) maliyet = yakit * fiyat;

    HistoryService.saveHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Yakıt: $km km / $yakit L',
      result: '${tuketim100.toStringAsFixed(2)} L/100km',
      date: DateTime.now(),
    ));
    setState(() {
      _resultText = 'Tüketim: ${tuketim100.toStringAsFixed(2)} L/100 km'
          '${maliyet != null ? '\nYakıt Maliyeti: ${maliyet.toStringAsFixed(2)} ₺' : ''}';
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) => CalculatorLayout(
        title: 'Yakıt Tüketimi Hesaplayıcı',
        showResult: _showResult,
        resultText: _resultText,
        resultLabel: 'Yakıt Analizi',
        onCalculate: _calculate,
        child: Column(children: [
          CustomInput(controller: _kmCtrl, hintText: 'Yol (km)', keyboardType: const TextInputType.numberWithOptions(decimal: true), prefixIcon: LucideIcons.mapPin, onChanged: (_) => setState(() => _showResult = false)),
          CustomInput(controller: _yakitCtrl, hintText: 'Harcanan Yakıt (Litre)', keyboardType: const TextInputType.numberWithOptions(decimal: true), prefixIcon: LucideIcons.fuel, onChanged: (_) => setState(() => _showResult = false)),
          CustomInput(controller: _fiyatCtrl, hintText: 'Yakıt Fiyatı ₺/L (isteğe bağlı)', keyboardType: const TextInputType.numberWithOptions(decimal: true), prefixIcon: LucideIcons.tag, onChanged: (_) => setState(() => _showResult = false)),
        ]),
      );
}
