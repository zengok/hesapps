import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
// flutter_staggered_animations — import kaldırıldı (A3)
import 'package:go_router/go_router.dart';

import '../providers/theme_provider.dart';
import '../providers/lang_provider.dart';
import '../widgets/glass_card.dart';
import '../theme/app_theme.dart';
import '../core/localization/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);

    // textColor: dark→beyaz, light→koyu lacivert
    final Color textColor = isDark ? Colors.white : AppTheme.darkNavy;
    final Color subColor = isDark ? Colors.white70 : Colors.black54;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                loc.settings,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 120),
                children: [
                  _ThemeToggleCard(isDark: isDark, textColor: textColor),
                  const SizedBox(height: 16),
                  _LanguageSelectorCard(isDark: isDark, textColor: textColor),
                  const SizedBox(height: 16),
                  _ActionCard(
                    title: loc.about,
                    icon: LucideIcons.info,
                    onTap: () => context.push('/about'),
                    isDark: isDark,
                    textColor: textColor,
                    subColor: subColor,
                  ),
                  const SizedBox(height: 16),
                  _ActionCard(
                    title: loc.rateApp,
                    icon: LucideIcons.star,
                    onTap: () {},
                    isDark: isDark,
                    textColor: textColor,
                    subColor: subColor,
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

/// Ayrı widget → sadece tema değişince rebuild olur
class _ThemeToggleCard extends StatelessWidget {
  final bool isDark;
  final Color textColor;

  const _ThemeToggleCard({required this.isDark, required this.textColor});

  @override
  Widget build(BuildContext context) {
    // *** Provider.of ile dinle, sadece bu küçük widget rebuild olur ***
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  themeProvider.isDarkMode ? LucideIcons.moon : LucideIcons.sun,
                  key: ValueKey(themeProvider.isDarkMode),
                  color: themeProvider.isDarkMode ? AppTheme.indigo : Colors.amber,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                AppLocalizations.of(context).darkMode,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
          Switch(
            value: themeProvider.isDarkMode,
            onChanged: themeProvider.toggleTheme,
          ),
        ],
      ),
    );
  }
}

/// Ayrı widget → sadece dil değişince rebuild olur
class _LanguageSelectorCard extends StatelessWidget {
  final bool isDark;
  final Color textColor;

  const _LanguageSelectorCard({required this.isDark, required this.textColor});

  static const Map<String, String> _languages = {
    'tr': '🇹🇷 Türkçe',
    'en': '🇬🇧 English',
    'de': '🇩🇪 Deutsch',
    'ar': '🇸🇦 العربية',
  };

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);
    final loc = AppLocalizations.of(context);

    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(LucideIcons.globe, color: textColor, size: 22),
              const SizedBox(width: 16),
              Text(
                loc.language,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: langProvider.currentLocale.languageCode,
              dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              icon: Icon(LucideIcons.chevronDown, color: textColor, size: 18),
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
              items: _languages.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value, style: TextStyle(color: textColor)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) langProvider.changeLanguage(val);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;
  final Color textColor;
  final Color subColor;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.isDark,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        borderRadius: 20,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: textColor, size: 22),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
            Icon(LucideIcons.chevronRight, color: subColor, size: 18),
          ],
        ),
      ),
    );
  }
}
