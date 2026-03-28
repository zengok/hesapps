import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../utility/data/services/history_service.dart';
import '../../../utility/data/models/calculation_history.dart';

class YasHesaplamaScreen extends StatefulWidget {
  const YasHesaplamaScreen({super.key});
  @override
  State<YasHesaplamaScreen> createState() => _YasHesaplamaScreenState();
}

class _YasHesaplamaScreenState extends State<YasHesaplamaScreen> {
  DateTime? _dogumTarihi;
  String? _resultText;
  bool _showResult = false;

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() { _dogumTarihi = picked; _showResult = false; });
  }

  void _calculate() {
    if (_dogumTarihi == null) return;
    final today = DateTime.now();
    int yas = today.year - _dogumTarihi!.year;
    int ay = today.month - _dogumTarihi!.month;
    int gun = today.day - _dogumTarihi!.day;
    if (gun < 0) { ay--; gun += 30; }
    if (ay < 0) { yas--; ay += 12; }

    final toplamGun = today.difference(_dogumTarihi!).inDays;

    HistoryService.saveHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Yaş: ${_dogumTarihi!.day}/${_dogumTarihi!.month}/${_dogumTarihi!.year}',
      result: '$yas yıl $ay ay',
      date: DateTime.now(),
    ));
    setState(() {
      _resultText = '$yas yıl, $ay ay, $gun gün\nToplam: $toplamGun gün';
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CalculatorLayout(
      title: 'Yaş Hesaplayıcı',
      showResult: _showResult,
      resultText: _resultText,
      resultLabel: 'Yaşınız',
      onCalculate: _calculate,
      child: GestureDetector(
        onTap: () => _pickDate(context),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
          ),
          child: Row(children: [
            const Icon(LucideIcons.calendarDays, color: Colors.amber),
            const SizedBox(width: 12),
            Text(
              _dogumTarihi == null ? 'Doğum Tarihinizi Seçin' : '${_dogumTarihi!.day}/${_dogumTarihi!.month}/${_dogumTarihi!.year}',
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 16),
            ),
          ]),
        ),
      ),
    );
  }
}
