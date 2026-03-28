class CalculateExchangeUseCase {
  final Map<String, double> rates;

  CalculateExchangeUseCase(this.rates);

  double execute(double amount, String fromCurrency, String toCurrency) {
    double fromRate = rates[fromCurrency] ?? 1.0;
    double toRate = rates[toCurrency] ?? 1.0;

    double inUsd = amount / fromRate;
    return inUsd * toRate;
  }
}
