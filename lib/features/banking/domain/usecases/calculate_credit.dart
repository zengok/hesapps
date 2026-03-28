import 'package:decimal/decimal.dart';

class CalculateCreditResult {
  final Decimal installment;
  final Decimal totalPaid;

  CalculateCreditResult({required this.installment, required this.totalPaid});
}

class CalculateCreditUseCase {
  CalculateCreditResult execute(Decimal principal, Decimal monthlyRatePercent, int months) {
    if (months <= 0) return CalculateCreditResult(installment: Decimal.zero, totalPaid: Decimal.zero);

    // BSMV = 15%, KKDF = 15% (for consumer loans)
    final hundred = Decimal.fromInt(100);
    // Effective Rate = Rate% * (1 + 0.15 + 0.15) = Rate% * 1.30
    final bsmvKkdfFactor = Decimal.parse('1.30');
    final rateRational = monthlyRatePercent / hundred;
    final r = (rateRational * bsmvKkdfFactor.toRational()).toDecimal(scaleOnInfinitePrecision: 10);

    if (r == Decimal.zero) {
       final installment = principal / Decimal.fromInt(months);
       return CalculateCreditResult(
         installment: installment.toDecimal(scaleOnInfinitePrecision: 2), 
         totalPaid: principal
       );
    }

    // PMT = P * r * (1 + r)^n / ((1 + r)^n - 1)
    final onePlusR = Decimal.one + r;
    Decimal onePlusRPowN = Decimal.one;
    for (int i = 0; i < months; i++) {
        onePlusRPowN = onePlusRPowN * onePlusR;
    }
    
    final numerator = principal * r * onePlusRPowN;
    final denominator = onePlusRPowN - Decimal.one;
    
    final pmt = (numerator / denominator).toDecimal(scaleOnInfinitePrecision: 2);
    final totalPaid = pmt * Decimal.fromInt(months);

    return CalculateCreditResult(installment: pmt, totalPaid: totalPaid);
  }
}
