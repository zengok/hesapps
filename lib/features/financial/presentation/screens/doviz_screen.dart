import 'package:flutter/material.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../theme/app_theme.dart';
import '../../domain/usecases/calculate_exchange.dart';
import '../../../utility/data/services/history_service.dart';
import '../../../utility/data/models/calculation_history.dart';

import '../../../utility/presentation/providers/exchange_rate_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DovizScreen extends ConsumerStatefulWidget {
  const DovizScreen({super.key});

  @override
  ConsumerState<DovizScreen> createState() => _DovizScreenState();
}

class _DovizScreenState extends ConsumerState<DovizScreen> {
  final TextEditingController _amountController = TextEditingController();
  
  String _fromCurrency = "USD";
  String _toCurrency = "TRY";
  
  Map<String, double> _rates = {};

  late CalculateExchangeUseCase _useCase;
  
  @override
  void initState() {
    super.initState();
  }

  String? _resultText;
  bool _showResult = false;

  void _calculate() {
    FocusScope.of(context).unfocus();
    
    double? amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    if (amount == null || amount <= 0) return;

    final result = _useCase.execute(amount, _fromCurrency, _toCurrency);

    final resultTextMsg = "${result.toStringAsFixed(2)} $_toCurrency";
    
    HistoryService.saveHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: "Döviz Çevrimi: $amount $_fromCurrency",
      result: resultTextMsg,
      date: DateTime.now(),
    ));

    setState(() {
      _resultText = resultTextMsg;
      _showResult = true;
    });
  }

  Widget _buildDropdown(String value, ValueChanged<String?> onChanged) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.transparent : Colors.black.withOpacity(0.05)),
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
    final ratesAsync = ref.watch(exchangeRateProvider);

    return ratesAsync.when(
      data: (rates) {
        _rates = rates;
        _useCase = CalculateExchangeUseCase(_rates);
        
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
      },
      loading: () => const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: CircularProgressIndicator(color: AppTheme.emerald)),
      ),
      error: (e, st) => const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: Text("Hata oluştu", style: TextStyle(color: Colors.red))),
      ),
    );
  }
}
