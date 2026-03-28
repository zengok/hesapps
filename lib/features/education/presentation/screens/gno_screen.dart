import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import '../../../utility/data/services/history_service.dart';
import '../../../utility/data/models/calculation_history.dart';

class GnoScreen extends StatefulWidget {
  const GnoScreen({super.key});
  @override
  State<GnoScreen> createState() => _GnoScreenState();
}

class _GnoScreenState extends State<GnoScreen> {
  final List<Map<String, TextEditingController>> _dersler = [
    {'not': TextEditingController(), 'kredi': TextEditingController()},
  ];
  String? _resultText;
  bool _showResult = false;

  void _addDers() => setState(() => _dersler.add({'not': TextEditingController(), 'kredi': TextEditingController()}));
  void _removeDers() { if (_dersler.length > 1) setState(() => _dersler.removeLast()); }

  void _calculate() {
    double toplamKrediXNot = 0;
    double toplamKredi = 0;
    for (final d in _dersler) {
      final not = double.tryParse(d['not']!.text.replaceAll(',', '.'));
      final kredi = double.tryParse(d['kredi']!.text.replaceAll(',', '.'));
      if (not != null && kredi != null && kredi > 0) {
        toplamKrediXNot += not * kredi;
        toplamKredi += kredi;
      }
    }
    if (toplamKredi == 0) return;
    final gno = toplamKrediXNot / toplamKredi;
    HistoryService.saveHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'GNO Hesaplama (${_dersler.length} ders)',
      result: 'GNO: ${gno.toStringAsFixed(2)}',
      date: DateTime.now(),
    ));
    setState(() {
      _resultText = 'GNO / Dönemlik Not Ortalaması:\n${gno.toStringAsFixed(2)} / 4.00';
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CalculatorLayout(
      title: 'GNO / Dönemlik Not Hesaplama',
      showResult: _showResult,
      resultText: _resultText,
      resultLabel: 'Not Ortalaması',
      onCalculate: _calculate,
      child: Column(children: [
        ..._dersler.asMap().entries.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(children: [
            Text('${e.key + 1}.', style: TextStyle(color: isDark ? Colors.white54 : Colors.black45, fontSize: 13)),
            const SizedBox(width: 8),
            Expanded(child: CustomInput(controller: e.value['not']!, hintText: 'Not (0-4)', keyboardType: const TextInputType.numberWithOptions(decimal: true), prefixIcon: LucideIcons.star, onChanged: (_) => setState(() => _showResult = false))),
            const SizedBox(width: 8),
            Expanded(child: CustomInput(controller: e.value['kredi']!, hintText: 'Kredi', keyboardType: const TextInputType.numberWithOptions(decimal: true), prefixIcon: LucideIcons.bookOpen, onChanged: (_) => setState(() => _showResult = false))),
          ]),
        )),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          IconButton(icon: const Icon(LucideIcons.plusCircle, color: Colors.green), onPressed: _addDers),
          if (_dersler.length > 1) IconButton(icon: const Icon(LucideIcons.minusCircle, color: Colors.red), onPressed: _removeDers),
        ]),
      ]),
    );
  }
}
