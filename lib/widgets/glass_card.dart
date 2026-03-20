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
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 24.0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Hafif beyaz/siyah saydam (0.1 - 0.2 opacity)
    // Aydınlık modda şık durması için beyaz saydam, karanlık modda ise duruma göre beyaz veya siyah-beyaz karışımı
    final Color defaultColor = isDark ? Colors.white : Colors.white;
    final double opacity = isDark ? 0.1 : 0.25;
    final double borderOpacity = isDark ? 0.15 : 0.4;
    
    final backgroundColor = color ?? defaultColor.withOpacity(opacity);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        // Ekstra bir gölge eklenebilir, ancak genelde Glassmorphism filter kullanır
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Optimize edilmiş Gaussian blur radius (Performans için)
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Colors.white.withOpacity(borderOpacity),
                width: 1.0, // ince border
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
