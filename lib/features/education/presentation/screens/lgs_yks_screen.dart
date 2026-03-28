import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import '../../../utility/data/services/history_service.dart';
import '../../../utility/data/models/calculation_history.dart';

class LgsYksScreen extends StatefulWidget {
  const LgsYksScreen({super.key});
  @override
  State<LgsYksScreen> createState() => _LgsYksScreenState();
}

class _LgsYksScreenState extends State<LgsYksScreen> {
  String _sinav = 'TYT';
  final Map<String, TextEditingController> _dogru = {};
  final Map<String, TextEditingController> _yanlis = {};
  String? _resultText;
  bool _showResult = false;

  static const _tytDersler = ['Türkçe', 'Matematik', 'Fen', 'Sosyal'];
  static const _aytDersler = ['Matematik', 'Geometri', 'Fizik', 'Kimya', 'Biyoloji'];
  static const _lgsDersler = ['Türkçe', 'Matematik', 'Fen', 'İnkılap', 'Din', 'İngilizce'];

  List<String> get _dersler => _sinav == 'TYT' ? _tytDersler : _sinav == 'AYT' ? _aytDersler : _lgsDersler;

  TextEditingController _ctrl(Map<String, TextEditingController> map, String key) =>
      map.putIfAbsent(key, () => TextEditingController());

  void _calculate() {
    double toplamNet = 0;
    for (final ders in _dersler) {
      final d = double.tryParse(_ctrl(_dogru, ders).text) ?? 0;
      final y = double.tryParse(_ctrl(_yanlis, ders).text) ?? 0;
      toplamNet += d - (y * 0.25);
    }
    HistoryService.saveHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '$_sinav Net Hesaplama',
      result: 'Toplam Net: ${toplamNet.toStringAsFixed(2)}',
      date: DateTime.now(),
    ));
    setState(() {
      _resultText = 'Toplam Net: ${toplamNet.toStringAsFixed(2)}\n(Her yanlış ¼ doğruyu götürür)';
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CalculatorLayout(
      title: 'LGS / YKS Net Hesaplama',
      showResult: _showResult,
      resultText: _resultText,
      resultLabel: 'Net Sonuç',
      onCalculate: _calculate,
      child: Column(children: [
        Wrap(spacing: 8, children: ['TYT', 'AYT', 'LGS'].map((s) {
          final sel = _sinav == s;
          return GestureDetector(
            onTap: () => setState(() { _sinav = s; _showResult = false; }),
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(color: sel ? Colors.indigo.withOpacity(0.3) : Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: sel ? Colors.indigo : Colors.white24)),
              child: Text(s, style: TextStyle(color: isDark ? Colors.white : Colors.black87))),
          );
        }).toList()),
        const SizedBox(height: 16),
        ..._dersler.map((ders) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(children: [
            SizedBox(width: 90, child: Text(ders, style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 13))),
            const SizedBox(width: 8),
            Expanded(child: CustomInput(controller: _ctrl(_dogru, ders), hintText: 'D', keyboardType: TextInputType.number, prefixIcon: LucideIcons.check, onChanged: (_) => setState(() => _showResult = false))),
            const SizedBox(width: 8),
            Expanded(child: CustomInput(controller: _ctrl(_yanlis, ders), hintText: 'Y', keyboardType: TextInputType.number, prefixIcon: LucideIcons.x, onChanged: (_) => setState(() => _showResult = false))),
          ]),
        )),
      ]),
    );
  }
}
