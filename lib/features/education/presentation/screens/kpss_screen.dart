import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import '../../../../widgets/glass_button.dart';
import '../../../../theme/app_theme.dart';
import '../../../utility/data/models/calculation_history.dart';
import '../../../utility/presentation/providers/history_provider.dart';

enum _KpssType { genel, egitim, alan }

class KpssScreen extends ConsumerStatefulWidget {
  const KpssScreen({super.key});

  @override
  ConsumerState<KpssScreen> createState() => _KpssScreenState();
}

class _KpssScreenState extends ConsumerState<KpssScreen> {
  _KpssType _type = _KpssType.genel;

  // KPSS Genel Yetenek / Genel Kültür
  final _gyDogruCtrl  = TextEditingController(); // GY doğru
  final _gyYanlisCtrl = TextEditingController(); // GY yanlış
  final _gkDogruCtrl  = TextEditingController(); // GK doğru
  final _gkYanlisCtrl = TextEditingController(); // GK yanlış

  // KPSS Eğitim Bilimleri
  final _ebDogruCtrl  = TextEditingController();
  final _ebYanlisCtrl = TextEditingController();

  // Alan sınavı
  final _alanDogruCtrl  = TextEditingController();
  final _alanYanlisCtrl = TextEditingController();

  String? _resultText;
  bool _showResult = false;

  @override
  void dispose() {
    _gyDogruCtrl.dispose(); _gyYanlisCtrl.dispose();
    _gkDogruCtrl.dispose(); _gkYanlisCtrl.dispose();
    _ebDogruCtrl.dispose(); _ebYanlisCtrl.dispose();
    _alanDogruCtrl.dispose(); _alanYanlisCtrl.dispose();
    super.dispose();
  }

  double _net(double dogru, double yanlis) => dogru - yanlis / 4;

  void _calculate() {
    FocusScope.of(context).unfocus();

    if (_type == _KpssType.genel) {
      final gyD  = double.tryParse(_gyDogruCtrl.text)  ?? 0;
      final gyY  = double.tryParse(_gyYanlisCtrl.text) ?? 0;
      final gkD  = double.tryParse(_gkDogruCtrl.text)  ?? 0;
      final gkY  = double.tryParse(_gkYanlisCtrl.text) ?? 0;

      final gyNet = _net(gyD, gyY).clamp(0, 60.0);
      final gkNet = _net(gkD, gkY).clamp(0, 60.0);

      // KPSS-P1 formülü
      // GY standart puan + GK standart puan → ham puan
      // Basit yaklaşım: (GY net * 1.5 + GK net * 1.5) + 50
      // Gerçekte ÖSYM standardizasyon yapıyor, bu yaklaşık bir hesap
      final p1 = (gyNet * 1.333 + gkNet * 1.333).clamp(0, 200.0);

      ref.read(historyProvider.notifier).addHistory(CalculationHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'KPSS Genel: GY $gyD/$gyY GK $gkD/$gkY',
        result: 'P1: ~${p1.toStringAsFixed(2)}',
        date: DateTime.now(),
      ));

      setState(() {
        _resultText =
            'GY Net: ${gyNet.toStringAsFixed(2)} / 60\n'
            'GK Net: ${gkNet.toStringAsFixed(2)} / 60\n\n'
            'Tahmini P1 Puanı: ~${p1.toStringAsFixed(2)}\n\n'
            'ℹ️ Gerçek puan ÖSYM standardizasyonuna göre değişir.';
        _showResult = true;
      });
    } else if (_type == _KpssType.egitim) {
      final gyD  = double.tryParse(_gyDogruCtrl.text)  ?? 0;
      final gyY  = double.tryParse(_gyYanlisCtrl.text) ?? 0;
      final gkD  = double.tryParse(_gkDogruCtrl.text)  ?? 0;
      final gkY  = double.tryParse(_gkYanlisCtrl.text) ?? 0;
      final ebD  = double.tryParse(_ebDogruCtrl.text)  ?? 0;
      final ebY  = double.tryParse(_ebYanlisCtrl.text) ?? 0;

      final gyNet = _net(gyD, gyY).clamp(0, 60.0);
      final gkNet = _net(gkD, gkY).clamp(0, 60.0);
      final ebNet = _net(ebD, ebY).clamp(0, 80.0);

      // P10 (Öğretmenlik): GY%15 + GK%15 + EB%70
      final p10 = gyNet * 0.15 / 60 * 100 +
                  gkNet * 0.15 / 60 * 100 +
                  ebNet * 0.70 / 80 * 100;

      ref.read(historyProvider.notifier).addHistory(CalculationHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'KPSS Eğitim: EB $ebD/$ebY',
        result: 'P10: ~${p10.toStringAsFixed(2)}',
        date: DateTime.now(),
      ));

      setState(() {
        _resultText =
            'GY Net: ${gyNet.toStringAsFixed(2)} / 60\n'
            'GK Net: ${gkNet.toStringAsFixed(2)} / 60\n'
            'EB Net: ${ebNet.toStringAsFixed(2)} / 80\n\n'
            'Tahmini P10 (Öğretmenlik): ~${p10.toStringAsFixed(2)}\n\n'
            'ℹ️ Gerçek puan ÖSYM standardizasyonuna göre değişir.';
        _showResult = true;
      });
    } else {
      // Alan sınavı — basit ham puan
      final alanD = double.tryParse(_alanDogruCtrl.text)  ?? 0;
      final alanY = double.tryParse(_alanYanlisCtrl.text) ?? 0;
      final alanNet = _net(alanD, alanY).clamp(0, 50.0);

      ref.read(historyProvider.notifier).addHistory(CalculationHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'KPSS Alan: $alanD doğru $alanY yanlış',
        result: 'Net: ${alanNet.toStringAsFixed(2)}',
        date: DateTime.now(),
      ));

      setState(() {
        _resultText = 'Alan Net: ${alanNet.toStringAsFixed(2)} / 50';
        _showResult = true;
      });
    }
  }

  Widget _typeBtn(_KpssType t, String label) {
    final sel = _type == t;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: GlassButton(
          onTap: () => setState(() { _type = t; _showResult = false; }),
          height: 44,
          borderRadius: 14,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: sel ? AppTheme.emerald : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputRow(String label, TextEditingController d, TextEditingController y) {
    return Row(
      children: [
        Expanded(
          child: CustomInput(
            controller: d,
            hintText: '$label Doğru',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: LucideIcons.checkCircle,
            onChanged: (_) => setState(() => _showResult = false),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CustomInput(
            controller: y,
            hintText: '$label Yanlış',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: LucideIcons.xCircle,
            onChanged: (_) => setState(() => _showResult = false),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CalculatorLayout(
      title: 'KPSS Puan Hesaplama',
      showResult: _showResult,
      resultText: _resultText,
      resultLabel: 'KPSS Sonucu',
      onCalculate: _calculate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sınav Türü',
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _typeBtn(_KpssType.genel,  'Genel\n(P1-P4)'),
              _typeBtn(_KpssType.egitim, 'Eğitim\n(P10)'),
              _typeBtn(_KpssType.alan,   'Alan\nSınavı'),
            ],
          ),
          const SizedBox(height: 8),

          if (_type != _KpssType.alan) ...[
            Text('GY (60 Soru)', style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 13)),
            _inputRow('GY', _gyDogruCtrl, _gyYanlisCtrl),
            Text('GK (60 Soru)', style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 13)),
            _inputRow('GK', _gkDogruCtrl, _gkYanlisCtrl),
          ],

          if (_type == _KpssType.egitim) ...[
            Text('EB - Eğitim Bilimleri (80 Soru)', style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 13)),
            _inputRow('EB', _ebDogruCtrl, _ebYanlisCtrl),
          ],

          if (_type == _KpssType.alan) ...[
            Text('Alan Sınavı (50 Soru)', style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 13)),
            _inputRow('Alan', _alanDogruCtrl, _alanYanlisCtrl),
          ],
        ],
      ),
    );
  }
}
