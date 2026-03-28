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

    // Dark: 10% white fill. Light: near-white fill with slight dark shadow for contrast
    final Color backgroundColor = color ??
        (isDark
            ? Colors.white.withAlpha(26)   // 10% white — Cosmic void glass
            : Colors.white.withAlpha(179)); // 70% white — Bright frosted glass

    final Color borderColor = isDark
        ? Colors.white.withAlpha(38)  // 15% white border in dark
        : Colors.black.withAlpha(20); // 8% black border in light for definition

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
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
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor,
                width: 1.2, // 1.2px crisp border
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
