import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart' as legacy;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../theme/app_theme.dart';
import '../providers/app_data_provider.dart';
import '../widgets/glass_card.dart';
import '../core/localization/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeContent();
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);
    final Color textColor = isDark ? Colors.white : AppTheme.darkNavy;
    final Color subColor = isDark ? Colors.white70 : Colors.black54;
    
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(loc.hello, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300, color: subColor)),
                const SizedBox(height: 6),
                Text(loc.whatToCalculate, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor)),
              ],
            ),
          ),
        ),

        // Favoriler
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Text('Favoriler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: isDark ? Colors.white70 : Colors.black54)),
          ),
        ),
        
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
            child: Row(
              children: [
                Expanded(child: _buildFavoriteCard(context, 'Döviz', LucideIcons.banknote, AppTheme.emerald, '/doviz', isDark)),
                const SizedBox(width: 16),
                Expanded(child: _buildFavoriteCard(context, 'KDV', LucideIcons.coins, AppTheme.amber, '/kdv', isDark)),
              ],
            ),
          ),
        ),

        // Kategoriler (BENTO GRID STYLE)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Text('Tüm Araçlar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: isDark ? Colors.white70 : Colors.black54)),
          ),
        ),
        
        SliverPadding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 120),
          sliver: SliverToBoxAdapter(
            child: _buildBentoCategories(context, isDark),
          ),
        ),
      ],
    );
  }




  Widget _buildBentoCategories(BuildContext context, bool isDark) {
    final provider = legacy.Provider.of<AppDataProvider>(context, listen: false);
    final categories = provider.categories;

    // Mapping categories to prompt sizes
    // 0: Finansal (Large)
    // 1: Bankacılık (Medium)
    // 2: Sağlık (Medium)
    // 3: Teknik (Small)
    // 4: Eğitim (Small)
    // 5: Günlük (Small)

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return StaggeredGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: categories.asMap().entries.map((entry) {
              final index = entry.key;
              final category = entry.value;

              // Assign StaggeredGridTile based on index to implement Bento layout
              int crossAxisCellCount = 1;
              double mainAxisCellCount = 1;

              if (index == 0) { // Finansal (Large - full width)
                crossAxisCellCount = 2;
                mainAxisCellCount = 1.2;
              } else if (index == 1 || index == 2) { // Bankacılık & Sağlık (Medium)
                crossAxisCellCount = 1;
                mainAxisCellCount = 1.4;
              } else { // Others (Small)
                crossAxisCellCount = 1;
                mainAxisCellCount = 1;
              }

              // Get actual calculator count for this category
              final count = provider.getCalculatorsByCategory(category.id).length;

              return StaggeredGridTile.count(
                crossAxisCellCount: crossAxisCellCount,
                mainAxisCellCount: mainAxisCellCount,
                child: GestureDetector(
                  onTap: () => context.push('/category', extra: category),
                  child: GlassCard(
                    borderRadius: 24,
                    color: category.color.withOpacity(0.05), // Very subtle tint
                    child: Stack(
                      children: [
                        // Decorative glowing orb in the corner
                        Positioned(
                          right: -20,
                          top: -20,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: category.color.withOpacity(isDark ? 0.3 : 0.2), // Soft glow
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                                ),
                                child: Icon(category.icon, color: category.color, size: index == 0 ? 32 : 28),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      category.title.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: index == 0 ? 18 : 15, // Larger for Financial
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.2,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                  ),
                                  // Counter pill
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                                    ),
                                    child: Text(
                                      '$count ARAÇ',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.8)),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }


  Widget _buildFavoriteCard(BuildContext context, String title, IconData icon, Color color, String route, bool isDark) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: GlassCard(
        height: 100,
        borderRadius: 20,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 28),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.darkNavy)),
          ],
        ),
      ),
    );
  }
}
