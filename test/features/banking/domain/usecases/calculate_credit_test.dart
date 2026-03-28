import 'package:flutter_test/flutter_test.dart';
import 'package:decimal/decimal.dart';
import 'package:hesapps/features/banking/domain/usecases/calculate_credit.dart';

void main() {
  group('CalculateCreditUseCase', () {
    late CalculateCreditUseCase useCase;

    setUp(() {
      useCase = CalculateCreditUseCase();
    });

    test('should calculate correct PMT with BSMV and KKDF factored effectively', () {
      final principal = Decimal.parse('10000');
      final rate = Decimal.parse('3.5'); // 3.5% nominal, 4.55% effective
      const months = 12;

      final result = useCase.execute(principal, rate, months);

      // (10000 * 0.0455 * 1.0455^12) / (1.0455^12 - 1) 
      expect(result.installment.toDouble(), closeTo(1099.31, 1.0));
      
      final expectedTotal = result.installment.toDouble() * 12;
      expect(result.totalPaid.toDouble(), closeTo(expectedTotal, 0.1));
    });

    test('should handle 0% loan perfectly', () {
      final principal = Decimal.parse('12000');
      final rate = Decimal.parse('0'); 
      const months = 12;

      final result = useCase.execute(principal, rate, months);

      expect(result.installment.toDouble(), 1000.0);
      expect(result.totalPaid.toDouble(), 12000.0);
    });
  });
}
