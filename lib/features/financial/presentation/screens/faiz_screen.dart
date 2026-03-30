import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import '../../../../widgets/glass_button.dart';
import '../../../../theme/app_theme.dart';
import '../../../utility/data/models/calculation_history.dart';
import '../../../utility/presentation/providers/history_provider.dart';

enum _FaizTipi { basit, bilesik }

class FaizScreen extends ConsumerStatefulWidget {
  const FaizScreen({super.key});

  @override
  ConsumerState<FaizScreen> createState() => _FaizScreenState();
}

class _FaizScreenState extends ConsumerState<FaizScreen> {
  final _anaParaCtrl = TextEditingController();
  final _oranCtrl = TextEditingController();
  final _sureCtrl = TextEditingController();
  _FaizTipi _tip = _FaizTipi.basit;
  bool _yillikMi = true; // true = yıllık, false = aylık
  String? _resultText;
  bool _showResult = false;

  @override
  void dispose() {
    _anaParaCtrl.dispose();
    _oranCtrl.dispose();
    _sureCtrl.dispose();
    super.dispose();
  }

  void _calculate() {
    FocusScope.of(context).unfocus();
    final anaPara = double.tryParse(_anaParaCtrl.text.replaceAll(',', '.'));
    final oran = double.tryParse(_oranCtrl.text.replaceAll(',', '.'));
    final sure = double.tryParse(_sureCtrl.text.replaceAll(',', '.'));

    if (anaPara == null || oran == null || sure == null ||
        anaPara <= 0 || oran <= 0 || sure <= 0) { return; }

    // Oranı yüzden ondalığa çevir
    final r = oran / 100;
    // Süreyi yıla çevir
    final t = _yillikMi ? sure : sure / 12;

    double faiz;
    double toplam;

    if (_tip == _FaizTipi.basit) {
      faiz = anaPara * r * t;
      toplam = anaPara + faiz;
    } else {
      toplam = anaPara * (1 + r) * (1 + r);
      // Bileşik: A = P * (1 + r)^t
      toplam = anaPara;
      for (int i = 0; i < t.floor(); i++) {
        toplam *= (1 + r);
      }
      // Kalan kesirli yıl için lineer interpolasyon
      final kesirliyil = t - t.floor();
      if (kesirliyil > 0) {
        toplam *= (1 + r * kesirliyil);
      }
      faiz = toplam - anaPara;
    }

    ref.read(historyProvider.notifier).addHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '${_tip == _FaizTipi.basit ? "Basit" : "Bileşik"} Faiz: $anaPara ₺',
      result: 'Faiz: ${faiz.toStringAsFixed(2)} ₺',
      date: DateTime.now(),
    ));

    setState(() {
      _resultText =
          'Ana Para: ${anaPara.toStringAsFixed(2)} ₺\n'
          'Faiz: ${faiz.toStringAsFixed(2)} ₺\n'
          'Toplam: ${toplam.toStringAsFixed(2)} ₺';
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.white70 : Colors.black87;

    return CalculatorLayout(
      title: 'Faiz Hesaplama',
      showResult: _showResult,
      resultText: _resultText,
      resultLabel: 'Faiz Sonucu',
      onCalculate: _calculate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Faiz türü seçimi
          Text('Faiz Türü', style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GlassButton(
                    onTap: () => setState(() { _tip = _FaizTipi.basit; _showResult = false; }),
                    height: 46,
                    borderRadius: 14,
                    child: Text(
                      'Basit Faiz',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _tip == _FaizTipi.basit ? AppTheme.emerald : Colors.white70,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: GlassButton(
                    onTap: () => setState(() { _tip = _FaizTipi.bilesik; _showResult = false; }),
                    height: 46,
                    borderRadius: 14,
                    child: Text(
                      'Bileşik Faiz',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _tip == _FaizTipi.bilesik ? AppTheme.emerald : Colors.white70,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomInput(
            controller: _anaParaCtrl,
            hintText: 'Ana Para (₺)',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: LucideIcons.coins,
            onChanged: (_) => setState(() => _showResult = false),
          ),
          CustomInput(
            controller: _oranCtrl,
            hintText: 'Faiz Oranı (%)',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: LucideIcons.percent,
            onChanged: (_) => setState(() => _showResult = false),
          ),
          // Süre + birim toggle
          Row(
            children: [
              Expanded(
                child: CustomInput(
                  controller: _sureCtrl,
                  hintText: _yillikMi ? 'Süre (yıl)' : 'Süre (ay)',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  prefixIcon: LucideIcons.calendarDays,
                  onChanged: (_) => setState(() => _showResult = false),
                ),
              ),
              const SizedBox(width: 8),
              GlassButton(
                onTap: () => setState(() { _yillikMi = !_yillikMi; _showResult = false; }),
                height: 56,
                borderRadius: 16,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    _yillikMi ? 'Yıl' : 'Ay',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.emerald),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
