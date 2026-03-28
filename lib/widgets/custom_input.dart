import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_theme.dart';
import 'glass_numeric_pad.dart';

class CustomInput extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;

  const CustomInput({
    super.key,
    this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (mounted) setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  bool get _isNumeric =>
      widget.keyboardType == TextInputType.number ||
      widget.keyboardType ==
          const TextInputType.numberWithOptions(decimal: true);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final Color hintColor = isDark ? Colors.white38 : Colors.black38;
    final Color iconColor =
        _isFocused ? AppTheme.emerald : (isDark ? Colors.white38 : Colors.black38);

    // Frosted glass border — odaklanınca emerald parlaması
    final Color borderColor = _isFocused
        ? AppTheme.emerald.withAlpha(200)
        : (isDark
            ? Colors.white.withAlpha(30)
            : Colors.black.withAlpha(20));

    return Semantics(
      label: widget.hintText,
      textField: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: AppTheme.emerald.withAlpha(60),
                    blurRadius: 16,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        // Frosted glass input alanı
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              decoration: BoxDecoration(
                // Dark: %5 white frosted. Light: %25 white frosted
                color: isDark
                    ? Colors.white.withAlpha(13)
                    : Colors.white.withAlpha(64),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor, width: 1.2),
              ),
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                keyboardType: widget.keyboardType,
                onChanged: widget.onChanged,
                readOnly: _isNumeric,
                onTap: () {
                  if (_isNumeric && widget.controller != null) {
                    showGlassNumericPad(
                      context: context,
                      controller: widget.controller!,
                      onChanged: widget.onChanged,
                    );
                  }
                },
                style: TextStyle(color: textColor, fontSize: 16),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(color: hintColor),
                  prefixIcon: widget.prefixIcon != null
                      ? Icon(widget.prefixIcon, color: iconColor)
                      : null,
                  suffixIcon: widget.suffixIcon,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

