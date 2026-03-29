import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/calculator_layout.dart';
import '../../widgets/custom_input.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme.dart';
import '../../providers/usage_provider.dart';

class DovizScreen extends ConsumerStatefulWidget {
  const DovizScreen({super.key});

  @override
  ConsumerState<DovizScreen> createState() => _DovizScreenState();
}

class _DovizScreenState extends ConsumerState<DovizScreen> {
  final TextEditingController _amountController = TextEditingController();
  
  String _fromCurrency = "USD";
  String _toCurrency = "TRY";
  
  // Mock veriler: USD ile çapraz kurlar hesaplanacak
  final Map<String, double> _rates = {
    "USD": 1.0,
    "TRY": 32.50,
    "EUR": 0.92,
    "GBP": 0.79,
    "JPY": 151.30,
    "GOLD (Gr)": 0.0135, // Örnek Altın
  };

  String? _resultText;
  bool _showResult = false;

  void _calculate() {
    FocusScope.of(context).unfocus();
    
    double? amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    if (amount == null || amount <= 0) return;

    // USD'ye bazlayıp, ardından hedefe çeviriyoruz
    double fromRate = _rates[_fromCurrency]!;
    double toRate = _rates[_toCurrency]!;

    double inUsd = amount / fromRate;
    double result = inUsd * toRate;

    setState(() {
      _resultText = "${result.toStringAsFixed(2)} $_toCurrency";
      _showResult = true;
    });
    // B3: kullanım kaydı
    ref.read(usageProvider.notifier).recordUsage('doviz');
  }

  Widget _buildDropdown(String value, ValueChanged<String?> onChanged) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.transparent : Colors.black.withValues(alpha: 0.05)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          isExpanded: true,
          items: _rates.keys.map((String c) {
            return DropdownMenuItem(
              value: c, 
              child: Text(
                c, 
                style: TextStyle(color: isDark ? Colors.white : Colors.black87)
              )
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorLayout(
      title: "Döviz Çevirici",
      showResult: _showResult,
      resultText: _resultText,
      resultLabel: "Çevrilen Tutar",
      onCalculate: _calculate,
      child: Column(
        children: [
          CustomInput(
            controller: _amountController,
            hintText: "Miktar",
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: LucideIcons.banknote,
            onChanged: (val) => setState(() => _showResult = false),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildDropdown(_fromCurrency, (v) {
                if (v != null) {
                  setState(() {
                    _fromCurrency = v;
                    _showResult = false;
                  });
                }
              })),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(LucideIcons.refreshCw, color: AppTheme.emerald),
              ),
              Expanded(child: _buildDropdown(_toCurrency, (v) {
                if (v != null) {
                   setState(() {
                     _toCurrency = v;
                     _showResult = false;
                   });
                }
              })),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "Uyarı: Gösterilen kurlar temsilidir ve gerçek piyasa koşullarını anlık yansıtmaz.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
