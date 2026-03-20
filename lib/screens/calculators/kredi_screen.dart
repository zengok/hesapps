import 'package:flutter/material.dart';
import 'dart:math';
import '../../widgets/calculator_layout.dart';
import '../../widgets/custom_input.dart';
import 'package:lucide_icons/lucide_icons.dart';

class KrediScreen extends StatefulWidget {
  const KrediScreen({Key? key}) : super(key: key);

  @override
  State<KrediScreen> createState() => _KrediScreenState();
}

class _KrediScreenState extends State<KrediScreen> {
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();
  
  String? _resultText;
  bool _showResult = false;

  void _calculate() {
    FocusScope.of(context).unfocus();
    
    double? p = double.tryParse(_principalController.text.replaceAll(',', '.'));
    double? rate = double.tryParse(_rateController.text.replaceAll(',', '.'));
    int? n = int.tryParse(_monthsController.text);

    if (p == null || rate == null || n == null || p <= 0 || rate <= 0 || n <= 0) return;

    // PMT Formula: P * r * (1 + r)^n / ((1 + r)^n - 1)
    double r = (rate / 100); 
    double pmt = p * r * pow(1 + r, n) / (pow(1 + r, n) - 1);
    double totalPaid = pmt * n;

    setState(() {
      _resultText = "Taksit: ${pmt.toStringAsFixed(2)} ₺\nToplam: ${totalPaid.toStringAsFixed(2)} ₺";
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
        ],
      ),
    );
  }
}
