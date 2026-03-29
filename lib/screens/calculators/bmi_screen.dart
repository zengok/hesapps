import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/calculator_layout.dart';
import '../../widgets/custom_input.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme.dart';
import '../../providers/usage_provider.dart';

class BmiScreen extends ConsumerStatefulWidget {
  const BmiScreen({super.key});

  @override
  ConsumerState<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends ConsumerState<BmiScreen> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  
  String? _resultText;
  bool _showResult = false;

  void _calculate() {
    FocusScope.of(context).unfocus();
    
    double? height = double.tryParse(_heightController.text.replaceAll(',', '.'));
    double? weight = double.tryParse(_weightController.text.replaceAll(',', '.'));

    if (height == null || weight == null || height <= 0 || weight <= 0) return;

    if (height > 3) {
      height = height / 100; // cm'yi metreye çevir
    }

    double bmi = weight / (height * height);
    String category;
    Color color;

    if (bmi < 18.5) {
      category = "Zayıf";
      color = Colors.lightBlue;
    } else if (bmi < 25) {
      category = "Normal";
      color = AppTheme.emerald;
    } else if (bmi < 30) {
      category = "Fazla Kilolu";
      color = AppTheme.amber;
    } else {
      category = "Obez";
      color = AppTheme.rose;
    }

    setState(() {
      _resultText = "${bmi.toStringAsFixed(1)}\n($category)";
      _showResult = true;
    });
    // B3: kullanım kaydı
    ref.read(usageProvider.notifier).recordUsage('bmi');
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorLayout(
      title: "Vücut Kitle Endeksi (BMI)",
      showResult: _showResult,
      resultText: _resultText,
      resultLabel: "VKE Skoru",
      onCalculate: _calculate,
      child: Column(
        children: [
          CustomInput(
            controller: _heightController,
            hintText: "Boy (cm veya m)",
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: LucideIcons.arrowUpDown,
            onChanged: (val) => setState(() => _showResult = false),
          ),
          CustomInput(
            controller: _weightController,
            hintText: "Kilo (kg)",
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: LucideIcons.scale,
            onChanged: (val) => setState(() => _showResult = false),
          ),
          const SizedBox(height: 32),
          
          // Show the gauge bar dynamically within the inner input layout when result is available
          AnimatedOpacity(
            duration: const Duration(milliseconds: 400),
            opacity: _showResult ? 1.0 : 0.0,
            child: _showResult ? Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Zayıf (18.5 ↓)", style: TextStyle(color: Colors.lightBlue, fontSize: 11)),
                    Text("Normal", style: TextStyle(color: AppTheme.emerald, fontSize: 11)),
                    Text("Fazla", style: TextStyle(color: AppTheme.amber, fontSize: 11)),
                    Text("Obez (30 ↑)", style: TextStyle(color: AppTheme.rose, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 14,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    gradient: const LinearGradient(
                      colors: [Colors.lightBlue, AppTheme.emerald, AppTheme.amber, AppTheme.rose],
                    ),
                    border: Border.all(color: Colors.white24),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ) : const SizedBox(height: 50),
          )
        ],
      ),
    );
  }
}
