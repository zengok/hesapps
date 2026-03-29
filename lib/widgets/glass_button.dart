import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/utils/adaptive_blur.dart';

class GlassButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double? width;
  final double height;
  final double borderRadius;

  const GlassButton({
    super.key,
    required this.child,
    required this.onTap,
    this.width,
    this.height = 60.0,
    this.borderRadius = 20.0,
  });

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius > 20 ? widget.borderRadius : 100.0), // Pill-shaped by default
          color: isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFF1A1A2E).withValues(alpha: 0.1),
          border: Border.all(
            color: isDark ? const Color(0x4DFFFFFF) : const Color(0x1A000000),
            width: 1.2, // 1.2px crisp white border
          ),
          boxShadow: _isPressed 
            ? [
                BoxShadow(
                  color: isDark ? Colors.white.withValues(alpha: 0.4) : Colors.black.withValues(alpha: 0.1), // Soft white outer glow
                  blurRadius: 30,
                  spreadRadius: 2,
                )
              ] 
            : [
                BoxShadow(
                  color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.transparent, // Slight constant glow
                  blurRadius: 15,
                  spreadRadius: -2,
                )
              ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius > 20 ? widget.borderRadius : 100.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: AdaptiveBlur.sigma, sigmaY: AdaptiveBlur.sigma),
            child: Center(child: widget.child),
          ),
        ),
      ),
    );
  }
}
