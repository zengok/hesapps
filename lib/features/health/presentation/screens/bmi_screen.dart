import 'package:flutter/material.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../theme/app_theme.dart';
import '../../domain/usecases/calculate_bmi.dart';
import '../../../utility/data/services/history_service.dart';
import '../../../utility/data/models/calculation_history.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  
  String? _resultText;
  String _bmiCategory = "";
  Color _bmiColor = Colors.transparent;
  double _bmiValue = 0;
  bool _showResult = false;

  void _calculate() {
    FocusScope.of(context).unfocus();
    
    double? height = double.tryParse(_heightController.text.replaceAll(',', '.'));
    double? weight = double.tryParse(_weightController.text.replaceAll(',', '.'));

    if (height == null || weight == null || height <= 0 || weight <= 0) return;

    final useCase = CalculateBmiUseCase();
    final result = useCase.execute(
      heightCm: height, 
      weightKg: weight,
      age: 25, // Varsayılan değerler
      gender: Gender.male,
      activityLevel: ActivityLevel.moderate,
    );

    Color color;
    switch(result.category) {
      case BmiCategory.underweight: color = Colors.lightBlue; break;
      case BmiCategory.normal: color = AppTheme.emerald; break;
      case BmiCategory.overweight: color = AppTheme.amber; break;
      case BmiCategory.obese: color = AppTheme.rose; break;
    }

    final resultStr = "${result.bmi.toStringAsFixed(1)}\n(${result.categoryText})";

    HistoryService.saveHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: "BMI: $weight kg, $height cm",
      result: resultStr.replaceAll('\n', ' '),
      date: DateTime.now(),
    ));

    setState(() {
      _bmiValue = result.bmi;
      _resultText = resultStr;
      _bmiCategory = result.categoryText;
      _bmiColor = color;
      _showResult = true;
    });
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
