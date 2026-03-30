import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart' as legacy;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../providers/app_data_provider.dart';
import '../providers/usage_provider.dart';
import '../widgets/glass_card.dart';
import '../core/localization/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeContent();
  }
}

// B4: ConsumerWidget — favoritesProvider izleniyor
class _HomeContent extends ConsumerWidget {
  const _HomeContent();

  // Araç ID → (başlık, ikon, route) haritası
  static const Map<String, (String, IconData, String)> _toolMeta = {
    'kdv':              ('KDV',             LucideIcons.percent,      '/kdv'),
    'maasvergi':        ('Maaş Vergisi',    LucideIcons.fileText,     '/maasvergi'),
    'iskonto':          ('İskonto',         LucideIcons.tags,         '/iskonto'),
    'karmarji':         ('Kar Marjı',       LucideIcons.trendingUp,   '/karmarji'),
    'enflasyon':        ('Enflasyon',       LucideIcons.barChart,     '/enflasyon'),
    'faiz':             ('Faiz',            LucideIcons.percent,      '/faiz'),
    'kidemtazminati':   ('Kıdem Taz.',      LucideIcons.briefcase,    '/kidemtazminati'),
    'kreditaksit':      ('Kredi Taksit',    LucideIcons.home,         '/kredi'),
    'mevduatgetirisi':  ('Mevduat',         LucideIcons.piggyBank,    '/mevduat'),
    'kredikartiasgari': ('Kredi Kartı',     LucideIcons.creditCard,   '/kredikartiasgari'),
    'doviz':            ('Döviz',           LucideIcons.dollarSign,   '/doviz'),
    'bmi':              ('BMI (VKE)',       LucideIcons.activity,     '/bmi'),
    'idealkilo':        ('İdeal Kilo',      LucideIcons.scale,        '/idealkilo'),
    'bmr':              ('Kalori (BMR)',    LucideIcons.flame,        '/bmr'),
    'sutuketimi':       ('Su Tüketimi',     LucideIcons.droplet,      '/sutuketimi'),
    'hamilelik':        ('Hamilelik',       LucideIcons.baby,         '/hamilelik'),
    'birim':            ('Birim Dön',       LucideIcons.refreshCw,    '/birim'),
    'sicaklik':         ('Sıcaklık',       LucideIcons.thermometer,  '/sicaklik'),
    'yakit':            ('Yakıt',           LucideIcons.fuel,         '/yakit'),
    'internet':         ('İnternet Hız',   LucideIcons.wifi,         '/internet'),
    'lgsyks':           ('LGS/YKS',        LucideIcons.calculator,   '/lgsyks'),
    'gno':              ('GNO',             LucideIcons.bookOpen,     '/gno'),
    'yas':              ('Yaş',             LucideIcons.calendarDays, '/yas'),
    'kpss':             ('KPSS',            LucideIcons.pencil,       '/kpss'),
    'bahsis':           ('Bahşiş',          LucideIcons.coins,        '/bahsis'),
    'indirimlifiyat':   ('İndirimli Fiyat', LucideIcons.tag,          '/indirimlifiyat'),
    'tarihfarki':       ('Tarih Farkı',     LucideIcons.calendarClock,'/tarihfarki'),
    'yuzde':            ('Yüzde',           LucideIcons.percent,      '/yuzde'),
    'desi':             ('Desi',            LucideIcons.package,      '/desi'),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);
    final Color textColor = isDark ? Colors.white : AppTheme.darkNavy;
    final Color subColor = isDark ? Colors.white70 : Colors.black54;
    // B4: kullanım verisine dayalı favoriler
    final favorites = ref.watch(favoritesProvider);
    
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
        
        // B5: AnimatedSwitcher — favoriler bos/dolu geçişi
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
            child: RepaintBoundary(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: favorites.isEmpty
                    ? const _EmptyFavoritesPlaceholder(key: ValueKey('empty'))
                    : _FavoritesList(
                        key: ValueKey(favorites.join(',')),
                        favorites: favorites,
                        toolMeta: _toolMeta,
                        isDark: isDark,
                      ),
              ),
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
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive aspect ratio: küçük ekranlarda biraz daha uzun kart
    final double aspectRatio = screenWidth < 360 ? 0.90 : 1.00;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: aspectRatio,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final count = provider.getCalculatorsByCategory(category.id).length;

          return GestureDetector(
            onTap: () => context.push('/category', extra: category),
            child: GlassCard(
              borderRadius: 24,
              color: category.color.withValues(alpha: 0.05),
              child: Stack(
                children: [
                  // Dekoratif parlayan orb (değiştirilmedi)
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
                            color: category.color.withValues(alpha: isDark ? 0.3 : 0.2),
                            blurRadius: 40,
                            spreadRadius: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. İkon — üstte sabit (değiştirilmedi)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: Icon(category.icon, color: category.color, size: 28),
                        ),

                        // 2. Boşluk — ismi alta iter
                        const Spacer(),

                        // 3. Kategori ismi — TEK SATIRDA, bölünmez
                        Text(
                          category.title.toUpperCase(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: isDark ? Colors.white : Colors.black87,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),

                        const SizedBox(height: 6),

                        // 4. Araç sayısı badge — ismin hemen altında
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: Text(
                            '$count ARAÇ',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── B5: Boş durum placeholder ────────────────────────────
class _EmptyFavoritesPlaceholder extends StatelessWidget {
  const _EmptyFavoritesPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        'Sık kullandığın araçlar burada görünecek',
        style: TextStyle(
          fontSize: 13,
          color: isDark ? Colors.white38 : Colors.black38,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

// ── B5: Dolu favori satırı ───────────────────────────────
class _FavoritesList extends StatelessWidget {
  final List<String> favorites;
  final Map<String, (String, IconData, String)> toolMeta;
  final bool isDark;

  const _FavoritesList({
    super.key,
    required this.favorites,
    required this.toolMeta,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < favorites.length; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          Expanded(
            child: _buildCard(context, favorites[i]),
          ),
        ],
      ],
    );
  }

  Widget _buildCard(BuildContext context, String toolId) {
    final meta = toolMeta[toolId];
    if (meta == null) return const SizedBox.shrink();
    final (title, icon, route) = meta;

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
            Icon(icon, color: AppTheme.emerald, size: 28),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppTheme.darkNavy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
