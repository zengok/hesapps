import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import '../../../../theme/app_theme.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../widgets/glass_button.dart';
import '../../domain/usecases/calculate_kdv.dart';
import '../../../utility/data/models/calculation_history.dart';
import '../../../utility/presentation/providers/history_provider.dart';

class KdvScreen extends ConsumerStatefulWidget {
  const KdvScreen({super.key});

  @override
  ConsumerState<KdvScreen> createState() => _KdvScreenState();
}

class _KdvScreenState extends ConsumerState<KdvScreen> {
  final TextEditingController _amountController = TextEditingController();
  double _selectedRate = 20.0;
  bool _isKdvIncluded = false; 
  String? _resultText;
  bool _showResult = false;
  double _lastKdvAmount = 0.0;

  String _kdvYorumu(double kdvTutar, double kdvOrani) {
    return 'Bu faturanın %${kdvOrani.toStringAsFixed(0)}\'i olan '
           '${kdvTutar.toStringAsFixed(2)} ₺ devlete gidiyor.';
  }

  void _calculate() {
    FocusScope.of(context).unfocus(); 
    
    double? amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    if (amount == null || amount <= 0) return;

    final useCase = CalculateKdvUseCase();
    final result = useCase.execute(amount, _selectedRate, _isKdvIncluded);
    final resultMsg = "Net: ${result.netAmount.toStringAsFixed(2)} ₺\nKDV: ${result.kdvAmount.toStringAsFixed(2)} ₺\nToplam: ${result.totalAmount.toStringAsFixed(2)} ₺";

    ref.read(historyProvider.notifier).addHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: "KDV: $amount ₺ (%$_selectedRate)",
      result: "Toplam: ${result.totalAmount.toStringAsFixed(2)} ₺",
      date: DateTime.now(),
    ));

    setState(() {
      _resultText = resultMsg;
      _lastKdvAmount = result.kdvAmount;
      _showResult = true;
    });
  }

  Widget _buildRateButton(double rate) {
    bool isSelected = _selectedRate == rate;
    
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: GlassButton(
          onTap: () {
            setState(() {
              _selectedRate = rate;
              _showResult = false;
            });
          },
          height: 50,
          borderRadius: 16,
          child: Text(
            "%$rate",
            style: TextStyle(
              color: isSelected ? AppTheme.emerald : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CalculatorLayout(
      title: "KDV Hesaplayıcı",
      showResult: _showResult,
      resultText: _resultText,
      resultLabel: "Hesaplama Sonucu",
      onCalculate: _calculate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomInput(
            controller: _amountController,
            hintText: "Tutar girin (₺)",
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: LucideIcons.coins,
          ),
          const SizedBox(height: 24),
          Text(
            "KDV Oranı Seçimi",
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildRateButton(1),
              _buildRateButton(10),
              _buildRateButton(20),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "KDV Dahil / Hariç",
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      _isKdvIncluded ? "Dahil" : "Hariç",
                      style: const TextStyle(color: AppTheme.emerald, fontWeight: FontWeight.bold),
                    ),
                    Switch(
                      value: _isKdvIncluded,
                      activeThumbColor: AppTheme.emerald,
                      onChanged: (val) {
                        setState(() {
                          _isKdvIncluded = val;
                          _showResult = false;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_showResult)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Center(
                child: Text(
                  _kdvYorumu(_lastKdvAmount, _selectedRate),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
