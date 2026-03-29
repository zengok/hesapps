import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? color;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Cam efekti rengi:
    final glassColor = isDark
        ? Colors.white.withValues(alpha: 0.08)   // koyu: beyaz cam
        : Colors.black.withValues(alpha: 0.06);  // açık: siyah cam

    // Kenarlık rengi:
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.15)
        : Colors.black.withValues(alpha: 0.10);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: glassColor,
        borderRadius: BorderRadius.circular(borderRadius),
        // Light mode: subtle drop shadow for depth
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withAlpha(15), // 6% shadow
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                )
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: RepaintBoundary(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: _adaptiveSigma(context), sigmaY: _adaptiveSigma(context)),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: color ?? borderColor,
                  width: 1.2, // 1.2px crisp border
                ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  /// A6: Düşük segment cihazlarda blur'u azalt
  static double _adaptiveSigma(BuildContext context) {
    final ratio = MediaQuery.of(context).devicePixelRatio;
    if (ratio >= 3.0) return 12.0; // yüksek end
    if (ratio >= 2.0) return 8.0;  // orta segment
    return 4.0;                    // düşük segment
  }
}
