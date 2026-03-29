import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hesapps/features/financial/domain/usecases/calculate_salary.dart';

void main() {
  group('2026 Salary Progressive Transition Simulation (End-to-End)', () {
    late CalculateSalaryUseCase salaryCalculator;

    setUp(() {
      salaryCalculator = CalculateSalaryUseCase();
    });

    test('should simulate full 12-month net salary progression with accurate cumulative brackets for 2026', () {
      const grossMonthly = 160000.0; // Mid-high tier to demonstrate bracket transitions
      debugPrint('\n=== 2026 E2E SALARY SIMULATION START ===');
      debugPrint('Aylık Brüt Maaş: 160,000 TRY');
      
      final result = salaryCalculator.execute(grossMonthly);

      double totalNet = 0;
      for (int i = 0; i < 12; i++) {
        totalNet += result[i];
        debugPrint('Ay ${i + 1} Net Maaş: ${result[i]} TRY');
      }

      debugPrint('Yıllık Toplam Net Gelir: $totalNet TRY');
      debugPrint('=== 2026 E2E SALARY SIMULATION END ===\n');
      
      // The net income MUST decrease over time organically due to cumulative tax brackets.
      expect(result.first > result.last, isTrue, reason: 'December net should strictly be less than January net because of tax.');
      expect(totalNet > 0, isTrue);
    });
  });
}
