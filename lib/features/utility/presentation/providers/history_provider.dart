import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/calculation_history.dart';
import '../../data/services/history_service.dart';

class HistoryNotifier extends AsyncNotifier<List<CalculationHistory>> {
  @override
  FutureOr<List<CalculationHistory>> build() async {
    return HistoryService.getHistory();
  }

  Future<void> addHistory(CalculationHistory item) async {
    await HistoryService.saveHistory(item);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => HistoryService.getHistory());
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => HistoryService.getHistory());
  }

  Future<void> clearHistory() async {
    await HistoryService.clearHistory();
    state = const AsyncValue.data([]);
  }
}

final historyProvider = AsyncNotifierProvider<HistoryNotifier, List<CalculationHistory>>(() {
  return HistoryNotifier();
});
