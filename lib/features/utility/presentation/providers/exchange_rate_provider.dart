import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/currency_repository.dart';

class ExchangeRateNotifier extends AsyncNotifier<Map<String, double>> {
  @override
  FutureOr<Map<String, double>> build() async {
    final repo = CurrencyRepository();
    return repo.fetchRates();
  }

  Future<void> refreshRates() async {
    state = const AsyncValue.loading();
    final repo = CurrencyRepository();
    state = await AsyncValue.guard(() => repo.fetchRates());
  }
}

final exchangeRateProvider = AsyncNotifierProvider<ExchangeRateNotifier, Map<String, double>>(() {
  return ExchangeRateNotifier();
});
