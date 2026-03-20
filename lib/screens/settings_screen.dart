import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../providers/theme_provider.dart';
import '../providers/lang_provider.dart';
import '../widgets/glass_card.dart';
import '../core/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Ayarlar',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Ayarlar Listesi
            Expanded(
              child: AnimationLimiter(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 120), // Yüzen menü boşluğu
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 500),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(child: widget),
                    ),
                    children: [
                      _buildThemeToggle(context, isDark),
                      const SizedBox(height: 16),
                      _buildLanguageSelector(context, isDark),
                      const SizedBox(height: 16),
                      _buildActionCard(context, "Hakkımızda", LucideIcons.info, () {}, isDark),
                      const SizedBox(height: 16),
                      _buildActionCard(context, "Uygulamayı Puanla", LucideIcons.star, () {}, isDark),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context, bool isDark) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(isDark ? LucideIcons.moon : LucideIcons.sun, color: isDark ? Colors.white : Colors.black87),
              const SizedBox(width: 16),
              Text(
                'Karanlık Mod',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          Switch(
            value: themeProvider.isDarkMode,
            activeColor: AppTheme.emerald,
            onChanged: (val) {
              themeProvider.toggleTheme(val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, bool isDark) {
    final langProvider = Provider.of<LanguageProvider>(context);
    
    final Map<String, String> languages = {
      'tr': 'Türkçe',
      'en': 'İngilizce',
      'de': 'Almanca',
      'ar': 'Arapça',
    };

    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(LucideIcons.globe, color: isDark ? Colors.white : Colors.black87),
              const SizedBox(width: 16),
              Text(
                'Dil Seçimi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: langProvider.currentLocale.languageCode,
              dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              icon: Icon(LucideIcons.chevronDown, color: isDark ? Colors.white : Colors.black87),
              items: languages.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(
                    entry.value,
                    style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  langProvider.changeLanguage(val);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        borderRadius: 20,
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: isDark ? Colors.white : Colors.black87),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            Icon(LucideIcons.chevronRight, color: isDark ? Colors.white54 : Colors.black45),
          ],
        ),
      ),
    );
  }
}
