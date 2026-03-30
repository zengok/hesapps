import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
// flutter_staggered_animations — import kaldırıldı (A3)
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../models/category_model.dart';
import '../providers/app_data_provider.dart';
import '../widgets/glass_card.dart';

class CategoryScreen extends StatelessWidget {
  final Category category;

  const CategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Provider'dan bu kategoriye spesifik (örneğin Finans altındaki KDV, İskonto vb.) hesaplama araçlarını listeleyelim
    final provider = Provider.of<AppDataProvider>(context, listen: false);
    final tools = provider.getCalculatorsByCategory(category.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent, // Arkaplanı yine Container hallediyor
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppTheme.darkBackgroundGradient : AppTheme.lightBackgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst Kısım: Geri dönüş butonu ve Kategori Başlığı
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(LucideIcons.arrowLeft),
                      color: isDark ? Colors.white : Colors.black87,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    Icon(category.icon, color: category.color, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        category.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Text(
                  'Hesaplama Araçları',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),

              // Alt Kısım: Araçların Gözüktüğü Grid (animasyon kaldırıldı — A3)
              Expanded(
                child: RepaintBoundary(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(24.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: tools.length,
                    itemBuilder: (context, index) {
                      final tool = tools[index];
                      return GestureDetector(
                        onTap: () => context.push(tool.route),
                        child: GlassCard(
                          borderRadius: 20,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: category.color.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    tool.icon,
                                    color: category.color,
                                    size: 26,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  tool.title,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white : Colors.black87,
                                    height: 1.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
