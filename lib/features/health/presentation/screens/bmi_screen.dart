import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../theme/app_theme.dart';
import '../../domain/usecases/calculate_bmi.dart';
import '../../../utility/data/models/calculation_history.dart';
import '../../../utility/presentation/providers/history_provider.dart';

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
  double _lastBmi = 0.0;

  String _bmiYorumu(double bmi) {
    if (bmi == 0.0) return '';
    if (bmi < 18.5) return 'Zayıf — ideal aralığın altındasınız.';
    if (bmi < 25.0) return 'Normal kiloda — sağlıklı aralıktasınız.';
    if (bmi < 30.0) return 'Fazla kilolu — dikkat etmeniz önerilir.';
    return 'Obezite sınırı aşılmış — bir uzmana danışın.';
  }

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


    final resultStr = "${result.bmi.toStringAsFixed(1)}\n(${result.categoryText})";

    ref.read(historyProvider.notifier).addHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: "BMI: $weight kg, $height cm",
      result: resultStr.replaceAll('\n', ' '),
      date: DateTime.now(),
    ));

    setState(() {
      _resultText = resultStr;
      _lastBmi = result.bmi;
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
                Center(
                  child: Text(
                    _bmiYorumu(_lastBmi),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
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
