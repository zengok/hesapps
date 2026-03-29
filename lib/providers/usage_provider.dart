import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────
// B1 — Kullanım verisi modeli (sade class, Freezed değil)
// ─────────────────────────────────────────────

class ToolUsage {
  final String toolId;
  final int count;
  final DateTime lastUsed;
  final DateTime? addedToFavoritesAt;

  const ToolUsage({
    required this.toolId,
    required this.count,
    required this.lastUsed,
    this.addedToFavoritesAt,
  });

  Map<String, dynamic> toJson() => {
        'toolId': toolId,
        'count': count,
        'lastUsed': lastUsed.toIso8601String(),
        'addedToFavoritesAt': addedToFavoritesAt?.toIso8601String(),
      };

  factory ToolUsage.fromJson(Map<String, dynamic> json) => ToolUsage(
        toolId: json['toolId'] as String,
        count: json['count'] as int,
        lastUsed: DateTime.parse(json['lastUsed'] as String),
        addedToFavoritesAt: json['addedToFavoritesAt'] != null
            ? DateTime.parse(json['addedToFavoritesAt'] as String)
            : null,
      );

  ToolUsage copyWith({
    int? count,
    DateTime? lastUsed,
    DateTime? addedToFavoritesAt,
  }) =>
      ToolUsage(
        toolId: toolId,
        count: count ?? this.count,
        lastUsed: lastUsed ?? this.lastUsed,
        addedToFavoritesAt: addedToFavoritesAt ?? this.addedToFavoritesAt,
      );
}

// ─────────────────────────────────────────────
// B1 — UsageNotifier: kullanım kaydeder, favorilere ekler
// ─────────────────────────────────────────────

final usageProvider = NotifierProvider<UsageNotifier, Map<String, ToolUsage>>(
  () => UsageNotifier(),
);

class UsageNotifier extends Notifier<Map<String, ToolUsage>> {
  @override
  Map<String, ToolUsage> build() {
    _load();
    return {};
  }

  static const _key = 'tool_usage_v1';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return;
    final list = jsonDecode(raw) as List<dynamic>;
    state = {
      for (final item in list)
        (item['toolId'] as String): ToolUsage.fromJson(
            item as Map<String, dynamic>)
    };
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(state.values.map((e) => e.toJson()).toList()),
    );
  }

  /// Bir araç kullanıldığında çağır.
  /// 2. kullanımda otomatik olarak favorilere ekler.
  Future<void> recordUsage(String toolId) async {
    final existing = state[toolId];
    final now = DateTime.now();

    if (existing == null) {
      state = {
        ...state,
        toolId: ToolUsage(toolId: toolId, count: 1, lastUsed: now),
      };
    } else {
      final newCount = existing.count + 1;
      DateTime? favoritesAt = existing.addedToFavoritesAt;

      // 2. kullanımda favoriye ekle
      if (newCount == 2 && favoritesAt == null) {
        favoritesAt = now;
      }

      state = {
        ...state,
        toolId: existing.copyWith(
          count: newCount,
          lastUsed: now,
          addedToFavoritesAt: favoritesAt,
        ),
      };
    }
    await _save();
  }
}

// ─────────────────────────────────────────────
// B2 — favoritesProvider: en fazla 3, en yeni önce
// ─────────────────────────────────────────────

final favoritesProvider = Provider<List<String>>((ref) {
  final usage = ref.watch(usageProvider);

  // Favoriye eklenmiş araçları filtrele
  final favorites = usage.values
      .where((u) => u.addedToFavoritesAt != null)
      .toList();

  // En yeni favoriye eklenme önce
  favorites.sort(
      (a, b) => b.addedToFavoritesAt!.compareTo(a.addedToFavoritesAt!));

  // Maks 3 favori göster; 3'ten fazlaysa en eskiyi alma
  return favorites.take(3).map((u) => u.toolId).toList();
});
