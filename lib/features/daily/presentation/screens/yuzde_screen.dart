import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import '../../../../widgets/glass_button.dart';
import '../../../../theme/app_theme.dart';
import '../../../utility/data/models/calculation_history.dart';
import '../../../utility/presentation/providers/history_provider.dart';

enum _YuzdeMode { ofWhat, whatPercent, increase, decrease }

class YuzdeScreen extends ConsumerStatefulWidget {
  const YuzdeScreen({super.key});

  @override
  ConsumerState<YuzdeScreen> createState() => _YuzdeScreenState();
}

class _YuzdeScreenState extends ConsumerState<YuzdeScreen> {
  final _ctrl1 = TextEditingController();
  final _ctrl2 = TextEditingController();
  _YuzdeMode _mode = _YuzdeMode.ofWhat;
  String? _resultText;
  bool _showResult = false;

  @override
  void dispose() {
    _ctrl1.dispose();
    _ctrl2.dispose();
    super.dispose();
  }

  void _calculate() {
    FocusScope.of(context).unfocus();
    final v1 = double.tryParse(_ctrl1.text.replaceAll(',', '.'));
    final v2 = double.tryParse(_ctrl2.text.replaceAll(',', '.'));
    if (v1 == null || v2 == null) return;

    double result;
    String title;
    String detail;

    switch (_mode) {
      case _YuzdeMode.ofWhat:
        // v1% of v2 = ?
        result = v1 * v2 / 100;
        title = '$v1% of $v2';
        detail = '$v1% × $v2 = ${result.toStringAsFixed(4)}';
      case _YuzdeMode.whatPercent:
        // v1 is what % of v2?
        if (v2 == 0) return;
        result = v1 / v2 * 100;
        title = '$v1 is ?% of $v2';
        detail = '$v1 ÷ $v2 × 100 = %${result.toStringAsFixed(4)}';
      case _YuzdeMode.increase:
        // Increase v1 by v2%
        result = v1 * (1 + v2 / 100);
        title = '$v1 + %$v2 artış';
        detail = 'Artış miktarı: ${(v1 * v2 / 100).toStringAsFixed(2)}\nSonuç: ${result.toStringAsFixed(2)}';
      case _YuzdeMode.decrease:
        // Decrease v1 by v2%
        result = v1 * (1 - v2 / 100);
        title = '$v1 - %$v2 azalma';
        detail = 'Azalma miktarı: ${(v1 * v2 / 100).toStringAsFixed(2)}\nSonuç: ${result.toStringAsFixed(2)}';
    }

    ref.read(historyProvider.notifier).addHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Yüzde: $title',
      result: result.toStringAsFixed(4),
      date: DateTime.now(),
    ));

    setState(() {
      _resultText = detail;
      _showResult = true;
    });
  }

  Widget _modeBtn(_YuzdeMode mode, String label) {
    final selected = _mode == mode;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: GlassButton(
          onTap: () => setState(() {
            _mode = mode;
            _showResult = false;
          }),
          height: 44,
          borderRadius: 14,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: selected ? AppTheme.emerald : Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  ({String h1, String h2}) get _hints => switch (_mode) {
    _YuzdeMode.ofWhat     => (h1: 'Yüzde (%)', h2: 'Değer'),
    _YuzdeMode.whatPercent=> (h1: 'Değer', h2: 'Toplam Değer'),
    _YuzdeMode.increase   => (h1: 'Başlangıç Değeri', h2: 'Artış Oranı (%)'),
    _YuzdeMode.decrease   => (h1: 'Başlangıç Değeri', h2: 'Azalma Oranı (%)'),
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hints = _hints;

    return CalculatorLayout(
      title: 'Yüzde Hesaplama',
      showResult: _showResult,
      resultText: _resultText,
      resultLabel: 'Sonuç',
      onCalculate: _calculate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'İşlem Türü',
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _modeBtn(_YuzdeMode.ofWhat,      'X%\nnedir?'),
              _modeBtn(_YuzdeMode.whatPercent, 'Kaçta\nkaçı?'),
              _modeBtn(_YuzdeMode.increase,    'Artış\n(+%)'),
              _modeBtn(_YuzdeMode.decrease,    'Azalma\n(-%)'),
            ],
          ),
          const SizedBox(height: 8),
          CustomInput(
            controller: _ctrl1,
            hintText: hints.h1,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: LucideIcons.percent,
            onChanged: (_) => setState(() => _showResult = false),
          ),
          CustomInput(
            controller: _ctrl2,
            hintText: hints.h2,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: LucideIcons.hash,
            onChanged: (_) => setState(() => _showResult = false),
          ),
        ],
      ),
    );
  }
}
