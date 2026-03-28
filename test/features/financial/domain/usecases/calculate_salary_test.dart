import 'package:flutter_test/flutter_test.dart';
import 'package:hesapps/features/financial/domain/usecases/calculate_salary.dart';

void main() {
  group('CalculateSalaryUseCase', () {
    late CalculateSalaryUseCase useCase;

    setUp(() {
      useCase = CalculateSalaryUseCase();
    });

    test('should calculate progressive tax transitions for 2026', () {
      // 100k Gross per month
      const gross = 100000.0;
      final result = useCase.execute(gross);

      expect(result.length, 12);
      
      // M1: Cumul=0, TaxBase=85000 => 15% Bracket. Tax = 12750. 
      // SGK = 15000. Stamp = 759.
      // Net = 100000 - 15000 - 12750 - 759 = 71491
      expect(result.first, closeTo(71491.0, 0.1));
      
      // M2: Cumul=85000. TaxBase=85000 => crosses into 20% Bracket at cumulative 150k.
      // 65000 allowed in 15% (9750), 20000 forced into 20% (4000). Tax = 13750.
      // Net = 100000 - 15000 - 13750 - 759 = 70491
      expect(result[1], closeTo(70491.0, 0.1));
    });
  });
}
