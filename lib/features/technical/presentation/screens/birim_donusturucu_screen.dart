import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import '../../../utility/data/services/history_service.dart';
import '../../../utility/data/models/calculation_history.dart';

class BirimDonusturucuScreen extends StatefulWidget {
  const BirimDonusturucuScreen({super.key});
  @override
  State<BirimDonusturucuScreen> createState() => _BirimDonusturucuScreenState();
}

class _BirimDonusturucuScreenState extends State<BirimDonusturucuScreen> {
  final _degerCtrl = TextEditingController();
  String _kategori = 'Uzunluk';
  String _from = 'Metre';
  String _to = 'Kilometre';
  String? _resultText;
  bool _showResult = false;

  static const _birimler = {
    'Uzunluk': {'Metre': 1.0, 'Kilometre': 0.001, 'Santimetre': 100.0, 'Milimetre': 1000.0, 'Mil': 0.000621371, 'Yarda': 1.09361, 'Fit': 3.28084, 'İnç': 39.3701},
    'Kütle': {'Kilogram': 1.0, 'Gram': 1000.0, 'Ton': 0.001, 'Pound': 2.20462, 'Ons': 35.274},
    'Alan': {'m²': 1.0, 'km²': 0.000001, 'cm²': 10000.0, 'Hektar': 0.0001, 'Dönüm': 0.001},
    'Hacim': {'Litre': 1.0, 'Mililitre': 1000.0, 'm³': 0.001, 'Galon': 0.264172},
  };

  List<String> get _birimListesi => _birimler[_kategori]!.keys.toList();

  void _calculate() {
    final deger = double.tryParse(_degerCtrl.text.replaceAll(',', '.'));
    if (deger == null) return;
    final fromFactor = _birimler[_kategori]![_from]!;
    final toFactor = _birimler[_kategori]![_to]!;
    // Önce baz birime çevir, sonra hedef birime
    final sonuc = deger / fromFactor * toFactor;

    HistoryService.saveHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Birim: $deger $_from → $_to',
      result: '${sonuc.toStringAsFixed(6).replaceAll(RegExp(r'0+$'), '')} $_to',
      date: DateTime.now(),
    ));
    setState(() {
      _resultText = '$deger $_from = ${sonuc.toStringAsFixed(6).replaceAll(RegExp(r'0+$'), '')} $_to';
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ddColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    return CalculatorLayout(
      title: 'Birim Dönüştürücü',
      showResult: _showResult,
      resultText: _resultText,
      resultLabel: 'Dönüşüm Sonucu',
      onCalculate: _calculate,
      child: Column(children: [
        // Kategori seçimi
        Wrap(spacing: 8, runSpacing: 8, children: _birimler.keys.map((k) {
          final sel = _kategori == k;
          return GestureDetector(
            onTap: () => setState(() {
              _kategori = k;
              _from = _birimler[k]!.keys.first;
              _to = _birimler[k]!.keys.elementAt(1);
              _showResult = false;
            }),
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: sel ? Colors.blue.withOpacity(0.3) : Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: sel ? Colors.blue : Colors.white24)),
              child: Text(k, style: TextStyle(color: textColor, fontSize: 13))),
          );
        }).toList()),
        const SizedBox(height: 16),
        CustomInput(controller: _degerCtrl, hintText: 'Değer', keyboardType: const TextInputType.numberWithOptions(decimal: true), prefixIcon: LucideIcons.hash, onChanged: (_) => setState(() => _showResult = false)),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: Container(padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(16)),
            child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: _from, dropdownColor: ddColor, isExpanded: true,
              items: _birimListesi.map((b) => DropdownMenuItem(value: b, child: Text(b, style: TextStyle(color: textColor, fontSize: 13)))).toList(),
              onChanged: (v) => setState(() { _from = v!; _showResult = false; }))))),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Icon(LucideIcons.repeat, color: Colors.blue.shade300)),
          Expanded(child: Container(padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(16)),
            child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: _to, dropdownColor: ddColor, isExpanded: true,
              items: _birimListesi.map((b) => DropdownMenuItem(value: b, child: Text(b, style: TextStyle(color: textColor, fontSize: 13)))).toList(),
              onChanged: (v) => setState(() { _to = v!; _showResult = false; }))))),
        ]),
      ]),
    );
  }
}
