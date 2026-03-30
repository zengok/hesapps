import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import '../../../utility/data/models/calculation_history.dart';
import '../../../utility/presentation/providers/history_provider.dart';

class KidemTazminatiScreen extends ConsumerStatefulWidget {
  const KidemTazminatiScreen({super.key});

  @override
  ConsumerState<KidemTazminatiScreen> createState() =>
      _KidemTazminatiScreenState();
}

class _KidemTazminatiScreenState extends ConsumerState<KidemTazminatiScreen> {
  final _maasCtrl = TextEditingController();
  final _yilCtrl = TextEditingController();
  final _ayCtrl = TextEditingController();
  String? _resultText;
  bool _showResult = false;

  // 2026 kıdem tazminatı tavanı (Ocak 2026 dönemi)
  static const double _tavan2026 = 47551.74;

  @override
  void dispose() {
    _maasCtrl.dispose();
    _yilCtrl.dispose();
    _ayCtrl.dispose();
    super.dispose();
  }

  void _calculate() {
    FocusScope.of(context).unfocus();
    final brutMaas = double.tryParse(_maasCtrl.text.replaceAll(',', '.'));
    final yil = int.tryParse(_yilCtrl.text) ?? 0;
    final ay = int.tryParse(_ayCtrl.text) ?? 0;

    if (brutMaas == null || brutMaas <= 0 || (yil == 0 && ay == 0)) return;

    // Brüt maaşa ek ödemeleri de ekle (taşıt, yemek vb. sabit ödemeler dahil sayılır)
    // Basit hesaplama: brüt maaş esası
    // Tavan kontrolü
    final hesapMaas = brutMaas > _tavan2026 ? _tavan2026 : brutMaas;

    // Toplam çalışma süresi (yıl cinsinden)
    final toplamYil = yil + ay / 12;

    // Kıdem tazminatı = Brüt maaş × Çalışma yılı
    final brutKidem = hesapMaas * toplamYil;

    // Damga vergisi (‰7.59 = %0.759)
    final damgaVergisi = brutKidem * 0.00759;
    final netKidem = brutKidem - damgaVergisi;

    // Tavan uyarısı
    final tavanUyarisi = brutMaas > _tavan2026
        ? '\n⚠️ Maaşınız tavan (${_tavan2026.toStringAsFixed(2)} ₺) üstünde, tavan esas alındı.'
        : '';

    ref.read(historyProvider.notifier).addHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Kıdem Tazminatı: $yil yıl $ay ay',
      result: 'Net: ${netKidem.toStringAsFixed(2)} ₺',
      date: DateTime.now(),
    ));

    setState(() {
      _resultText =
          'Brüt Tazminat: ${brutKidem.toStringAsFixed(2)} ₺\n'
          'Damga Vergisi (‰7.59): ${damgaVergisi.toStringAsFixed(2)} ₺\n'
          'Net Tazminat: ${netKidem.toStringAsFixed(2)} ₺'
          '$tavanUyarisi';
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CalculatorLayout(
      title: 'Kıdem Tazminatı',
      showResult: _showResult,
      resultText: _resultText,
      resultLabel: 'Tazminat Sonucu',
      onCalculate: _calculate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomInput(
            controller: _maasCtrl,
            hintText: 'Brüt Maaş (₺)',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: LucideIcons.wallet,
            onChanged: (_) => setState(() => _showResult = false),
          ),
          Row(
            children: [
              Expanded(
                child: CustomInput(
                  controller: _yilCtrl,
                  hintText: 'Çalışma Yılı',
                  keyboardType: TextInputType.number,
                  prefixIcon: LucideIcons.calendarDays,
                  onChanged: (_) => setState(() => _showResult = false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomInput(
                  controller: _ayCtrl,
                  hintText: 'Ay (0-11)',
                  keyboardType: TextInputType.number,
                  prefixIcon: LucideIcons.calendarClock,
                  onChanged: (_) => setState(() => _showResult = false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '2026 Tavan: ${_tavan2026.toStringAsFixed(2)} ₺ · Damga vergisi ‰7.59',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
          ),
        ],
      ),
    );
  }
}
