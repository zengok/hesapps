import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';

import '../../features/utility/presentation/providers/history_provider.dart';
import '../../features/utility/data/models/calculation_history.dart';
import '../../widgets/glass_card.dart';
import '../../theme/app_theme.dart';
import '../../core/localization/app_localizations.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);
    final Color textColor = isDark ? Colors.white : AppTheme.darkNavy;
    final Color subColor = isDark ? Colors.white60 : Colors.black54;

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  loc.navHistory,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                // Geçmişi temizle butonu
                historyAsync.maybeWhen(
                  data: (list) => list.isEmpty
                      ? const SizedBox.shrink()
                      : GestureDetector(
                          onTap: () => _confirmClear(context, ref, isDark),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.rose.withAlpha(30),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppTheme.rose.withAlpha(80)),
                            ),
                            child: Row(
                              children: [
                                Icon(LucideIcons.trash2, color: AppTheme.rose, size: 14),
                                const SizedBox(width: 4),
                                Text('Temizle', style: TextStyle(color: AppTheme.rose, fontSize: 12, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                  orElse: () => const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          // İçerik
          Expanded(
            child: historyAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (e, st) => Center(
                child: Text('Bir hata oluştu', style: TextStyle(color: subColor)),
              ),
              data: (history) {
                if (history.isEmpty) {
                  return _EmptyState(isDark: isDark);
                }

                // Tarihe göre sırala (en yeni üstte)
                final sorted = [...history]..sort((a, b) => b.date.compareTo(a.date));

                // ListView.builder → Lazy Loading: 100+ kayıtta RAM şişmez
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
                  itemCount: sorted.length,
                  itemBuilder: (context, index) {
                    return _HistoryCard(
                      item: sorted[index],
                      isDark: isDark,
                      textColor: textColor,
                      subColor: subColor,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _confirmClear(BuildContext context, WidgetRef ref, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Geçmişi Temizle', style: TextStyle(color: isDark ? Colors.white : AppTheme.darkNavy, fontWeight: FontWeight.bold)),
        content: Text('Tüm hesaplama geçmişi silinecek. Emin misiniz?', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(historyProvider.notifier).clearHistory();
            },
            child: Text('Temizle', style: TextStyle(color: AppTheme.rose, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

/// Boş durum (empty state) widget'ı
class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.indigo.withAlpha(30),
                border: Border.all(color: AppTheme.indigo.withAlpha(60), width: 1.2),
              ),
              child: Icon(LucideIcons.clock, color: AppTheme.indigo.withAlpha(180), size: 44),
            ),
            const SizedBox(height: 24),
            Text(
              'Henüz işlem yapılmadı',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppTheme.darkNavy,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Bir hesaplama yaptığınızda\nsonuçlar burada görünecek.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white54 : Colors.black38,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Geçmiş kartı — ayrı widget → lazy list'te rebuild minimize edilir
class _HistoryCard extends StatelessWidget {
  final CalculationHistory item;
  final bool isDark;
  final Color textColor;
  final Color subColor;

  const _HistoryCard({
    required this.item,
    required this.isDark,
    required this.textColor,
    required this.subColor,
  });

  // Hesaplama başlığına göre ikon rengi
  Color _accentColor() {
    final t = item.title.toLowerCase();
    if (t.contains('kredi') || t.contains('mevduat') || t.contains('kart')) {
      return AppTheme.indigo;
    } else if (t.contains('bmi') || t.contains('kilo') || t.contains('kalori') || t.contains('su')) {
      return AppTheme.emerald;
    } else if (t.contains('kdv') || t.contains('maaş') || t.contains('vergi') || t.contains('kar')) {
      return AppTheme.amber;
    } else if (t.contains('birim') || t.contains('sıcaklık') || t.contains('yakıt')) {
      return Colors.blueGrey;
    } else if (t.contains('gno') || t.contains('lgs') || t.contains('yks') || t.contains('yaş')) {
      return AppTheme.purple;
    }
    return AppTheme.indigo;
  }

  @override
  Widget build(BuildContext context) {
    final color = _accentColor();
    final dateStr = DateFormat('dd MMM yyyy • HH:mm', 'tr_TR').format(item.date);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        borderRadius: 18,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Renk göstergesi
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withAlpha(35),
                border: Border.all(color: color.withAlpha(80), width: 1),
              ),
              child: Icon(LucideIcons.calculator, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            // Başlık + Sonuç
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.result,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateStr,
                    style: TextStyle(fontSize: 11, color: subColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
