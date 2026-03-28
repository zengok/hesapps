import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import '../../../utility/data/services/history_service.dart';
import '../../../utility/data/models/calculation_history.dart';

class BmrScreen extends StatefulWidget {
  const BmrScreen({super.key});
  @override
  State<BmrScreen> createState() => _BmrScreenState();
}

class _BmrScreenState extends State<BmrScreen> {
  final _kiloctrl = TextEditingController();
  final _boyCtrl = TextEditingController();
  final _yasCtrl = TextEditingController();
  String _cinsiyet = 'Erkek';
  String _aktivite = 'Sedanter';
  String? _resultText;
  bool _showResult = false;

  static const _aktiviteFaktorleri = {
    'Sedanter': 1.2,
    'Hafif Aktif': 1.375,
    'Orta Aktif': 1.55,
    'Çok Aktif': 1.725,
    'Ekstra Aktif': 1.9,
  };

  void _calculate() {
    final kilo = double.tryParse(_kiloctrl.text.replaceAll(',', '.'));
    final boy = double.tryParse(_boyCtrl.text.replaceAll(',', '.'));
    final yas = int.tryParse(_yasCtrl.text);
    if (kilo == null || boy == null || yas == null) return;

    // Mifflin-St Jeor Formülü
    double bmr;
    if (_cinsiyet == 'Erkek') {
      bmr = 10 * kilo + 6.25 * boy - 5 * yas + 5;
    } else {
      bmr = 10 * kilo + 6.25 * boy - 5 * yas - 161;
    }
    final tdee = bmr * (_aktiviteFaktorleri[_aktivite] ?? 1.2);

    HistoryService.saveHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'BMR: $kilo kg - $boy cm - $yas yaş',
      result: 'TDEE: ${tdee.toStringAsFixed(0)} kcal',
      date: DateTime.now(),
    ));
    setState(() {
      _resultText =
          'Bazal Metabolizma (BMR): ${bmr.toStringAsFixed(0)} kcal\nGünlük İhtiyaç (TDEE): ${tdee.toStringAsFixed(0)} kcal\nZayıflama İçin: ${(tdee - 500).toStringAsFixed(0)} kcal\nKilo Alma İçin: ${(tdee + 300).toStringAsFixed(0)} kcal';
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white70 : Colors.black54;
    return CalculatorLayout(
      title: 'Günlük Kalori (BMR/TDEE)',
      showResult: _showResult,
      resultText: _resultText,
      resultLabel: 'Kalori İhtiyacı',
      onCalculate: _calculate,
      child: Column(children: [
        CustomInput(controller: _kiloctrl, hintText: 'Kilo (kg)', keyboardType: const TextInputType.numberWithOptions(decimal: true), prefixIcon: LucideIcons.activity, onChanged: (_) => setState(() => _showResult = false)),
        CustomInput(controller: _boyCtrl, hintText: 'Boy (cm)', keyboardType: const TextInputType.numberWithOptions(decimal: true), prefixIcon: LucideIcons.ruler, onChanged: (_) => setState(() => _showResult = false)),
        CustomInput(controller: _yasCtrl, hintText: 'Yaş', keyboardType: TextInputType.number, prefixIcon: LucideIcons.calendarDays, onChanged: (_) => setState(() => _showResult = false)),
        const SizedBox(height: 16),
        // Cinsiyet seçimi
        Row(children: [
          Expanded(child: GestureDetector(
            onTap: () => setState(() { _cinsiyet = 'Erkek'; _showResult = false; }),
            child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: _cinsiyet == 'Erkek' ? Colors.blue.withOpacity(0.3) : Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: _cinsiyet == 'Erkek' ? Colors.blue : Colors.white24)),
              child: Center(child: Text('Erkek', style: TextStyle(color: isDark ? Colors.white : Colors.black87)))),
          )),
          const SizedBox(width: 12),
          Expanded(child: GestureDetector(
            onTap: () => setState(() { _cinsiyet = 'Kadın'; _showResult = false; }),
            child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: _cinsiyet == 'Kadın' ? Colors.pink.withOpacity(0.3) : Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: _cinsiyet == 'Kadın' ? Colors.pink : Colors.white24)),
              child: Center(child: Text('Kadın', style: TextStyle(color: isDark ? Colors.white : Colors.black87)))),
          )),
        ]),
        const SizedBox(height: 16),
        // Aktivite seçimi
        Text('Aktivite Seviyesi', style: TextStyle(color: textColor, fontSize: 14)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: _aktiviteFaktorleri.keys.map((a) {
          final isSelected = _aktivite == a;
          return GestureDetector(
            onTap: () => setState(() { _aktivite = a; _showResult = false; }),
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: isSelected ? Colors.green.withOpacity(0.3) : Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: isSelected ? Colors.green : Colors.white24)),
              child: Text(a, style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 13))),
          );
        }).toList()),
      ]),
    );
  }
}
