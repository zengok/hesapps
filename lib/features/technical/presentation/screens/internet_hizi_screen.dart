import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import '../../../utility/data/models/calculation_history.dart';
import '../../../utility/presentation/providers/history_provider.dart';

class InternetHiziScreen extends ConsumerStatefulWidget {
  const InternetHiziScreen({super.key});
  @override
  ConsumerState<InternetHiziScreen> createState() => _InternetHiziScreenState();
}

class _InternetHiziScreenState extends ConsumerState<InternetHiziScreen> {
  final _hizCtrl = TextEditingController();
  final _dosyaCtrl = TextEditingController();
  String _hizBirim = 'Mbps';
  String _dosyaBirim = 'GB';
  String? _resultText;
  bool _showResult = false;

  void _calculate() {
    final hiz = double.tryParse(_hizCtrl.text.replaceAll(',', '.'));
    final dosya = double.tryParse(_dosyaCtrl.text.replaceAll(',', '.'));
    if (hiz == null || dosya == null || hiz <= 0 || dosya <= 0) return;

    // Mbps cinsine çevir
    double hizMbps = _hizBirim == 'Gbps' ? hiz * 1000 : _hizBirim == 'Kbps' ? hiz / 1000 : hiz;
    // MB cinsine çevir
    double dosyaMB = _dosyaBirim == 'GB' ? dosya * 1024 : _dosyaBirim == 'TB' ? dosya * 1024 * 1024 : dosya;

    final saniye = (dosyaMB * 8) / hizMbps;
    final dakika = saniye / 60;
    final saat = dakika / 60;

    ref.read(historyProvider.notifier).addHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'İndirme: $dosya $_dosyaBirim @ $hiz $_hizBirim',
      result: '${saniye.toStringAsFixed(0)} saniye',
      date: DateTime.now(),
    ));
    setState(() {
      _resultText = saat >= 1
          ? '${saat.toStringAsFixed(2)} saat (${dakika.toStringAsFixed(0)} dk)'
          : dakika >= 1
              ? '${dakika.toStringAsFixed(2)} dakika'
              : '${saniye.toStringAsFixed(0)} saniye';
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ddColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    Widget dropdown(String val, List<String> items, ValueChanged<String?> onChanged) =>
      Container(padding: const EdgeInsets.symmetric(horizontal: 10), decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(12)),
        child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: val, dropdownColor: ddColor,
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: TextStyle(color: textColor, fontSize: 13)))).toList(),
          onChanged: onChanged)));

    return CalculatorLayout(
      title: 'İnternet Hızı / İndirme Süresi',
      showResult: _showResult,
      resultText: _resultText,
      resultLabel: 'Tahmini İndirme Süresi',
      onCalculate: _calculate,
      child: Column(children: [
        Row(children: [
          Expanded(child: CustomInput(controller: _hizCtrl, hintText: 'İnternet Hızı', keyboardType: const TextInputType.numberWithOptions(decimal: true), prefixIcon: LucideIcons.wifi, onChanged: (_) => setState(() => _showResult = false))),
          const SizedBox(width: 8),
          dropdown(_hizBirim, ['Kbps', 'Mbps', 'Gbps'], (v) => setState(() { _hizBirim = v!; _showResult = false; })),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: CustomInput(controller: _dosyaCtrl, hintText: 'Dosya Boyutu', keyboardType: const TextInputType.numberWithOptions(decimal: true), prefixIcon: LucideIcons.fileDown, onChanged: (_) => setState(() => _showResult = false))),
          const SizedBox(width: 8),
          dropdown(_dosyaBirim, ['MB', 'GB', 'TB'], (v) => setState(() { _dosyaBirim = v!; _showResult = false; })),
        ]),
      ]),
    );
  }
}
