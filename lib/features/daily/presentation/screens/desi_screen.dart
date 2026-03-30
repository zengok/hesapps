import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import '../../../utility/data/models/calculation_history.dart';
import '../../../utility/presentation/providers/history_provider.dart';

class DesiScreen extends ConsumerStatefulWidget {
  const DesiScreen({super.key});

  @override
  ConsumerState<DesiScreen> createState() => _DesiScreenState();
}

class _DesiScreenState extends ConsumerState<DesiScreen> {
  final _enCtrl = TextEditingController();
  final _boyCtrl = TextEditingController();
  final _yukCtrl = TextEditingController();
  String? _resultText;
  bool _showResult = false;

  @override
  void dispose() {
    _enCtrl.dispose();
    _boyCtrl.dispose();
    _yukCtrl.dispose();
    super.dispose();
  }

  void _calculate() {
    FocusScope.of(context).unfocus();
    final en = double.tryParse(_enCtrl.text.replaceAll(',', '.'));
    final boy = double.tryParse(_boyCtrl.text.replaceAll(',', '.'));
    final yuk = double.tryParse(_yukCtrl.text.replaceAll(',', '.'));

    if (en == null || boy == null || yuk == null ||
        en <= 0 || boy <= 0 || yuk <= 0) { return; }

    final hacim = en * boy * yuk;
    final desi = hacim / 3000;

    ref.read(historyProvider.notifier).addHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Desi: ${en}x${boy}x$yuk cm',
      result: '${desi.toStringAsFixed(2)} desi',
      date: DateTime.now(),
    ));

    setState(() {
      _resultText =
          'Hacim: ${hacim.toStringAsFixed(0)} cm³\n'
          'Desi: ${desi.toStringAsFixed(2)} desi\n\n'
          'ℹ️ Desi = (En × Boy × Yükseklik) / 3000';
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorLayout(
      title: 'Desi Hesaplama',
      showResult: _showResult,
      resultText: _resultText,
      resultLabel: 'Desi Sonucu',
      onCalculate: _calculate,
      child: Column(
        children: [
          CustomInput(
            controller: _enCtrl,
            hintText: 'En (cm)',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: LucideIcons.arrowLeftRight,
            onChanged: (_) => setState(() => _showResult = false),
          ),
          CustomInput(
            controller: _boyCtrl,
            hintText: 'Boy (cm)',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: LucideIcons.arrowUpDown,
            onChanged: (_) => setState(() => _showResult = false),
          ),
          CustomInput(
            controller: _yukCtrl,
            hintText: 'Yükseklik (cm)',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: LucideIcons.package,
            onChanged: (_) => setState(() => _showResult = false),
          ),
        ],
      ),
    );
  }
}
