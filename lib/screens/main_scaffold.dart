import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  // GoRouter URI'den aktif sekme index'ini doğru hesapla
  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location == '/' || location.isEmpty) return 0;
    if (location.startsWith('/history')) return 1;
    if (location.startsWith('/search')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  void _onTap(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/history');
        break;
      case 2:
        context.go('/search');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedIndex = _selectedIndex(context);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0E11) : const Color(0xFFF8FAFC),
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppTheme.darkBackgroundGradient
              : AppTheme.lightBackgroundGradient,
        ),
        child: SafeArea(bottom: false, child: child),
      ),
      bottomNavigationBar: _FloatingNavBar(
        selectedIndex: selectedIndex,
        isDark: isDark,
        onTap: (i) => _onTap(i, context),
      ),
    );
  }
}

/// Ayrı StatelessWidget — sadece nav değişince rebuild olur
class _FloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final bool isDark;
  final ValueChanged<int> onTap;

  const _FloatingNavBar({
    required this.selectedIndex,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              // Dark: deep-black glass. Light: frosted white glass
              color: isDark
                  ? Colors.black.withAlpha(153)  // 60% black
                  : Colors.white.withAlpha(204), // 80% white
              borderRadius: BorderRadius.circular(36),
              border: Border.all(
                color: isDark
                    ? Colors.white.withAlpha(26)  // 10% white in dark
                    : Colors.black.withAlpha(15), // 6% black in light
                width: 1.2,
              ),
              boxShadow: isDark
                  ? [BoxShadow(color: Colors.black.withAlpha(128), blurRadius: 30, offset: const Offset(0, 10))]
                  : [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 20, offset: const Offset(0, 4))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavItem(icon: LucideIcons.home, index: 0, selected: selectedIndex, isDark: isDark, onTap: onTap),
                _NavItem(icon: LucideIcons.clock, index: 1, selected: selectedIndex, isDark: isDark, onTap: onTap),
                _NavItem(icon: LucideIcons.search, index: 2, selected: selectedIndex, isDark: isDark, onTap: onTap),
                _NavItem(icon: LucideIcons.settings, index: 3, selected: selectedIndex, isDark: isDark, onTap: onTap),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final int index;
  final int selected;
  final bool isDark;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.index,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = index == selected;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        height: 60,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? AppTheme.indigo.withAlpha(51) // 20% indigo highlight
                : Colors.transparent,
            boxShadow: isActive
                ? [BoxShadow(color: AppTheme.indigo.withAlpha(128), blurRadius: 12, spreadRadius: 1)]
                : [],
          ),
          child: Icon(
            icon,
            size: 22,
            color: isActive
                ? AppTheme.indigo
                : (isDark ? Colors.white54 : Colors.black38),
          ),
        ),
      ),
    );
  }
}
