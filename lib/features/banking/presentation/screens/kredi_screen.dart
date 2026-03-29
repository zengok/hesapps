import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../utility/data/models/calculation_history.dart';
import 'package:decimal/decimal.dart';
import '../../domain/usecases/calculate_credit.dart';
import '../../../utility/presentation/providers/history_provider.dart';

class KrediScreen extends ConsumerStatefulWidget {
  const KrediScreen({super.key});

  @override
  ConsumerState<KrediScreen> createState() => _KrediScreenState();
}

class _KrediScreenState extends ConsumerState<KrediScreen> {
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();
  
  String? _resultText;
  bool _showResult = false;

  String _krediYorumu(double aylikTaksit, double anaparaTL, int vadeAy) {
    final toplamOdeme = aylikTaksit * vadeAy;
    final toplamFaiz = toplamOdeme - anaparaTL;
    final faizOrani = (toplamFaiz / anaparaTL) * 100;

    if (faizOrani < 20) {
      return 'Toplam faiz yükü düşük — avantajlı bir kredi.';
    }
    if (faizOrani < 50) {
      return 'Toplam ${toplamFaiz.toStringAsFixed(0)} ₺ faiz ödenecek.';
    }
    return 'Dikkat: Anapara\'nın %${faizOrani.toStringAsFixed(0)}\'i kadar faiz ödeniyor.';
  }

  void _calculate() {
    FocusScope.of(context).unfocus();
    
    double? p = double.tryParse(_principalController.text.replaceAll(',', '.'));
    double? rate = double.tryParse(_rateController.text.replaceAll(',', '.'));
    int? n = int.tryParse(_monthsController.text);

    if (p == null || rate == null || n == null || p <= 0 || rate <= 0 || n <= 0) return;

    final useCase = CalculateCreditUseCase();
    final result = useCase.execute(Decimal.parse(p.toString()), Decimal.parse(rate.toString()), n);
    final resultMsg = "Taksit: ${result.installment.toStringAsFixed(2)} ₺\nToplam: ${result.totalPaid.toStringAsFixed(2)} ₺";

    ref.read(historyProvider.notifier).addHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: "Kredi: $p ₺ ($n Ay)",
      result: "Taksit: ${result.installment.toStringAsFixed(2)} ₺",
      date: DateTime.now(),
    ));

    setState(() {
      _resultText = resultMsg;
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorLayout(
      title: "Kredi Taksit Hesaplama",
      showResult: _showResult,
      resultText: _resultText,
      resultLabel: "Geri Ödeme Planı",
      onCalculate: _calculate,
      child: Column(
        children: [
          CustomInput(
            controller: _principalController,
            hintText: "Ana Para (₺)",
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: LucideIcons.banknote,
            onChanged: (val) => setState(() => _showResult = false),
          ),
          CustomInput(
            controller: _rateController,
            hintText: "Aylık Faiz Oranı (%)",
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: LucideIcons.percent,
            onChanged: (val) => setState(() => _showResult = false),
          ),
          CustomInput(
            controller: _monthsController,
            hintText: "Vade (Ay)",
            keyboardType: TextInputType.number,
            prefixIcon: LucideIcons.calendar,
            onChanged: (val) => setState(() => _showResult = false),
          ),
          if (_showResult)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _krediYorumu(
                  double.tryParse(_resultText?.split('Taksit: ').last.split(' ').first.replaceAll(',', '.') ?? '0') ?? 0,
                  double.tryParse(_principalController.text.replaceAll(',', '.')) ?? 0,
                  int.tryParse(_monthsController.text) ?? 1,
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
