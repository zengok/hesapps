import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import '../../../utility/data/models/calculation_history.dart';
import '../../../utility/presentation/providers/history_provider.dart';

class SicaklikScreen extends ConsumerStatefulWidget {
  const SicaklikScreen({super.key});
  @override
  ConsumerState<SicaklikScreen> createState() => _SicaklikScreenState();
}

class _SicaklikScreenState extends ConsumerState<SicaklikScreen> {
  final _degerCtrl = TextEditingController();
  String _from = 'Celsius';
  String _to = 'Fahrenheit';
  String? _resultText;
  bool _showResult = false;

  final _birimler = ['Celsius', 'Fahrenheit', 'Kelvin'];

  double _toCelsius(double val, String unit) {
    switch (unit) {
      case 'Fahrenheit': return (val - 32) * 5 / 9;
      case 'Kelvin': return val - 273.15;
      default: return val;
    }
  }

  double _fromCelsius(double celsius, String unit) {
    switch (unit) {
      case 'Fahrenheit': return celsius * 9 / 5 + 32;
      case 'Kelvin': return celsius + 273.15;
      default: return celsius;
    }
  }

  void _calculate() {
    final val = double.tryParse(_degerCtrl.text.replaceAll(',', '.'));
    if (val == null) return;
    final celsius = _toCelsius(val, _from);
    final sonuc = _fromCelsius(celsius, _to);

    ref.read(historyProvider.notifier).addHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Sıcaklık: $val° $_from → $_to',
      result: '${sonuc.toStringAsFixed(2)}° $_to',
      date: DateTime.now(),
    ));
    setState(() {
      _resultText = '$val° $_from = ${sonuc.toStringAsFixed(2)}° $_to';
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ddColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    return CalculatorLayout(
      title: 'Sıcaklık Çevirici',
      showResult: _showResult,
      resultText: _resultText,
      resultLabel: 'Dönüşüm',
      onCalculate: _calculate,
      child: Column(children: [
        CustomInput(controller: _degerCtrl, hintText: 'Sıcaklık Değeri', keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), prefixIcon: LucideIcons.thermometer, onChanged: (_) => setState(() => _showResult = false)),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: Container(padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(16)),
            child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: _from, dropdownColor: ddColor, isExpanded: true,
              items: _birimler.map((b) => DropdownMenuItem(value: b, child: Text(b, style: TextStyle(color: textColor)))).toList(),
              onChanged: (v) => setState(() { _from = v!; _showResult = false; }))))),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Icon(LucideIcons.arrowRight, color: Colors.orange)),
          Expanded(child: Container(padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(16)),
            child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: _to, dropdownColor: ddColor, isExpanded: true,
              items: _birimler.map((b) => DropdownMenuItem(value: b, child: Text(b, style: TextStyle(color: textColor)))).toList(),
              onChanged: (v) => setState(() { _to = v!; _showResult = false; }))))),
        ]),
      ]),
    );
  }
}
