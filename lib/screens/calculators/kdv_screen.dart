import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/calculator_layout.dart';
import '../../widgets/custom_input.dart';
import '../../core/theme.dart';
import '../../providers/usage_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';

class KdvScreen extends ConsumerStatefulWidget {
  const KdvScreen({super.key});

  @override
  ConsumerState<KdvScreen> createState() => _KdvScreenState();
}

class _KdvScreenState extends ConsumerState<KdvScreen> {
  final TextEditingController _amountController = TextEditingController();
  double _selectedRate = 20.0;
  bool _isKdvIncluded = false; // false = Hariç, true = Dahil
  String? _resultText;
  bool _showResult = false;

  void _calculate() {
    FocusScope.of(context).unfocus(); // Klavyeyi kapat
    
    double? amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    if (amount == null || amount <= 0) return;

    double kdvAmount = 0;
    double netAmount = 0;
    double totalAmount = 0;

    if (_isKdvIncluded) {
      totalAmount = amount;
      netAmount = amount / (1 + (_selectedRate / 100));
      kdvAmount = totalAmount - netAmount;
    } else {
      netAmount = amount;
      kdvAmount = amount * (_selectedRate / 100);
      totalAmount = amount + kdvAmount;
    }

    setState(() {
      _resultText = "Net: ${netAmount.toStringAsFixed(2)} ₺\nKDV: ${kdvAmount.toStringAsFixed(2)} ₺\nToplam: ${totalAmount.toStringAsFixed(2)} ₺";
      _showResult = true;
    });
    // B3: kullanım kaydı
    ref.read(usageProvider.notifier).recordUsage('kdv');
  }

  Widget _buildRateButton(double rate) {
    bool isSelected = _selectedRate == rate;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedRate = rate;
            _showResult = false;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.emerald.withValues(alpha: 0.8) : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppTheme.emerald : (isDark ? Colors.transparent : Colors.black.withValues(alpha: 0.05)),
            ),
            boxShadow: isSelected
                ? [BoxShadow(color: AppTheme.emerald.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))]
                : [],
          ),
          child: Center(
            child: Text(
              "%$rate",
              style: TextStyle(
                color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
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
        ],
      ),
    );
  }
}
