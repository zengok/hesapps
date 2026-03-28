class CalculateKdvResult {
  final double netAmount;
  final double kdvAmount;
  final double totalAmount;

  CalculateKdvResult({required this.netAmount, required this.kdvAmount, required this.totalAmount});
}

class CalculateKdvUseCase {
  CalculateKdvResult execute(double amount, double rate, bool isKdvIncluded) {
    double kdvAmount = 0;
    double netAmount = 0;
    double totalAmount = 0;

    if (isKdvIncluded) {
      totalAmount = amount;
      netAmount = amount / (1 + (rate / 100));
      kdvAmount = totalAmount - netAmount;
    } else {
      netAmount = amount;
      kdvAmount = amount * (rate / 100);
      totalAmount = amount + kdvAmount;
    }

    return CalculateKdvResult(netAmount: netAmount, kdvAmount: kdvAmount, totalAmount: totalAmount);
  }
}
