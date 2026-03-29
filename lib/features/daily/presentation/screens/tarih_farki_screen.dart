import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../utility/data/models/calculation_history.dart';
import '../../../utility/presentation/providers/history_provider.dart';

class TarihFarkiScreen extends ConsumerStatefulWidget {
  const TarihFarkiScreen({super.key});
  @override
  ConsumerState<TarihFarkiScreen> createState() => _TarihFarkiScreenState();
}

class _TarihFarkiScreenState extends ConsumerState<TarihFarkiScreen> {
  DateTime? _baslangic;
  DateTime? _bitis;
  String? _resultText;
  bool _showResult = false;

  Future<void> _pickDate(bool isBaslangic, BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isBaslangic ? (_baslangic ?? DateTime.now().subtract(const Duration(days: 30))) : (_bitis ?? DateTime.now()),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
      if (isBaslangic) {
        _baslangic = picked;
      } else {
        _bitis = picked;
      }
      _showResult = false;
    });
    }
  }

  void _calculate() {
    if (_baslangic == null || _bitis == null) return;
    final fark = _bitis!.difference(_baslangic!);
    final gun = fark.inDays.abs();
    final hafta = gun ~/ 7;
    final ay = (gun / 30.44).floor();
    final yl = (gun / 365.25).floor();

    ref.read(historyProvider.notifier).addHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Tarih Farkı',
      result: '$gun gün',
      date: DateTime.now(),
    ));
    setState(() {
      _resultText = '$gun gün\n$hafta hafta\n≈ $ay ay\n≈ $yl yıl';
      _showResult = true;
    });
  }

  String _formatDate(DateTime? d) => d == null ? 'Tarih Seçin' : '${d.day}/${d.month}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Widget dateBtn(String label, DateTime? val, bool isBaslangic) => GestureDetector(
      onTap: () => _pickDate(isBaslangic, context),
      child: Container(padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white24)),
        child: Column(children: [
          Text(label, style: TextStyle(color: isDark ? Colors.white54 : Colors.black45, fontSize: 12)),
          const SizedBox(height: 4),
          Text(_formatDate(val), style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.w600)),
        ])),
    );

    return CalculatorLayout(
      title: 'Tarih Farkı Hesaplama',
      showResult: _showResult,
      resultText: _resultText,
      resultLabel: 'Tarih Farkı',
      onCalculate: _calculate,
      child: Row(children: [
        Expanded(child: dateBtn('Başlangıç', _baslangic, true)),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Icon(LucideIcons.arrowRight, color: Colors.deepPurple)),
        Expanded(child: dateBtn('Bitiş', _bitis, false)),
      ]),
    );
  }
}
