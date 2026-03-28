import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import '../../../../widgets/glass_card.dart';
import '../../../../theme/app_theme.dart';
import '../../domain/usecases/calculate_salary.dart';
import '../../../utility/data/services/history_service.dart';
import '../../../utility/data/models/calculation_history.dart';

class MaasVergiScreen extends StatefulWidget {
  const MaasVergiScreen({super.key});

  @override
  State<MaasVergiScreen> createState() => _MaasVergiScreenState();
}

class _MaasVergiScreenState extends State<MaasVergiScreen> {
  final TextEditingController _grossController = TextEditingController();
  final TextEditingController _cumController = TextEditingController(); // Kümülatif matrah

  String? _resultText;
  bool _showResult = false;
  List<double> _netSalaries = [];
  double _currentTaxRate = 0.15;

  // 2026 vergi dilim limitleri: kümülatiften mevcut dilimine göre renk hesabı
  static const List<Map<String, dynamic>> _taxBrackets = [
    {'limit': 150000.0, 'rate': 0.15, 'label': '%15', 'color': Color(0xFF3B82F6)},
    {'limit': 350000.0, 'rate': 0.20, 'label': '%20', 'color': Color(0xFF8B5CF6)},
    {'limit': 800000.0, 'rate': 0.27, 'label': '%27', 'color': Color(0xFFF59E0B)},
    {'limit': 4000000.0, 'rate': 0.35, 'label': '%35', 'color': Color(0xFFEF4444)},
    {'limit': double.infinity, 'rate': 0.40, 'label': '%40', 'color': Color(0xFF7F1D1D)},
  ];

  void _calculate() {
    FocusScope.of(context).unfocus();

    final double? gross = double.tryParse(_grossController.text.replaceAll(',', '.'));
    final double cumBase = double.tryParse(_cumController.text.replaceAll(',', '.')) ?? 0.0;

    if (gross == null || gross <= 0) return;

    final useCase = CalculateSalaryUseCase();
    final salaries = useCase.execute(gross);

    // SGK + damga
    double sgk = gross * 0.15;
    double damga = gross * 0.00759;
    // Net bu aydaki vergi
    double vergi = gross - sgk - damga - salaries[0];

    // Mevcut dilimi tespit et (kümülatif + taxBase'e göre)
    double activeRate = 0.15;
    double checkCum = cumBase;
    for (final b in _taxBrackets) {
      if (checkCum < (b['limit'] as double)) {
        activeRate = b['rate'] as double;
        break;
      }
    }

    setState(() {
      _netSalaries = salaries;
      _currentTaxRate = activeRate;
      _resultText =
          'Net Maaş: ${salaries[0].toStringAsFixed(2)} ₺\n'
          'SGK Keintisi: ${sgk.toStringAsFixed(2)} ₺\n'
          'Vergi: ${vergi.toStringAsFixed(2)} ₺\n'
          'Damga: ${damga.toStringAsFixed(2)} ₺';
      _showResult = true;
    });

    HistoryService.saveHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Maaş & Vergi: $gross ₺',
      result: 'Net: ${salaries[0].toStringAsFixed(2)} ₺',
      date: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _grossController.dispose();
    _cumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CalculatorLayout(
      title: 'Maaş & Gelir Vergisi',
      showResult: _showResult,
      resultText: _resultText,
      resultLabel: 'Net Maaş Hesabı',
      onCalculate: _calculate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomInput(
            controller: _grossController,
            hintText: 'Brüt Maaş (₺)',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: LucideIcons.banknote,
            onChanged: (_) => setState(() => _showResult = false),
          ),
          CustomInput(
            controller: _cumController,
            hintText: 'Kümülatif Matrah (₺) — İlk ayda 0',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: LucideIcons.barChart2,
            onChanged: (_) => setState(() => _showResult = false),
          ),
          const SizedBox(height: 24),

          // 2026 Vergi Dilim Gösterge Paneli
          GlassCard(
            borderRadius: 20,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(LucideIcons.barChart2, color: AppTheme.indigo, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      '2026 Vergi Dilimleri',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Vergi progression bar
                Row(
                  children: _taxBrackets.map((b) {
                    final bool isActive = _currentTaxRate == (b['rate'] as double) && _showResult;
                    return Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        height: isActive ? 10 : 6,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: isActive
                              ? (b['color'] as Color)
                              : (b['color'] as Color).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: isActive
                              ? [BoxShadow(color: (b['color'] as Color).withOpacity(0.7), blurRadius: 8, spreadRadius: 1)]
                              : [],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                // Dilim etiketleri
                Row(
                  children: _taxBrackets.map((b) {
                    final bool isActive = _currentTaxRate == (b['rate'] as double) && _showResult;
                    return Expanded(
                      child: Text(
                        b['label'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                          color: isActive ? (b['color'] as Color) : Colors.white38,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                if (_showResult) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Aktif Dilim: ',
                          style: TextStyle(color: Colors.white54, fontSize: 13),
                        ),
                        Text(
                          '${(_currentTaxRate * 100).toInt()}\'lık Vergi Dilimi',
                          style: TextStyle(
                            color: _taxBrackets.firstWhere(
                              (b) => b['rate'] == _currentTaxRate,
                              orElse: () => _taxBrackets[0],
                            )['color'] as Color,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Yıllık Net Maaş Dağılımı (sadece sonuç gösteriliyorsa)
          if (_showResult && _netSalaries.isNotEmpty) ...[
            Text(
              '12 Aylık Net Maaş Dağılımı',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 12,
              itemBuilder: (context, i) {
                final monthNames = ['Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'];
                return GlassCard(
                  borderRadius: 12,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(monthNames[i], style: const TextStyle(fontSize: 10, color: Colors.white54)),
                      Text(
                        '${_netSalaries[i].toStringAsFixed(0)}₺',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: i == 0 ? AppTheme.emerald : Colors.white70,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }
}
