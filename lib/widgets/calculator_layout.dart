import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';

import '../theme/app_theme.dart';
import 'glass_card.dart';
import 'glass_button.dart';

class CalculatorLayout extends StatefulWidget {
  final String title;
  final Widget child; 
  final VoidCallback onCalculate;
  final String? resultText;
  final String resultLabel;
  final bool showResult;
  final String calculateButtonText;

  const CalculatorLayout({
    super.key,
    required this.title,
    required this.child,
    required this.onCalculate,
    this.resultText,
    this.resultLabel = "Sonuç",
    this.showResult = false,
    this.calculateButtonText = "Hesapla",
  });

  @override
  State<CalculatorLayout> createState() => _CalculatorLayoutState();
}

class _CalculatorLayoutState extends State<CalculatorLayout> {
  final GlobalKey _globalKey = GlobalKey();

  Future<void> _shareResult() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        
        // Memori tabanli XFile olusturma: Cross-platform web/windows/android uyumludur ve dart:io gerektirmez.
        final xfile = XFile.fromData(pngBytes, mimeType: 'image/png', name: 'hesapps_sonuc.png');
        await SharePlus.instance.share(
          ShareParams(
            text: '${widget.title} - HesApps Infografik',
            files: [xfile],
          ),
        );
      }
    } catch (e) {
      debugPrint('Share Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppTheme.darkBackgroundGradient : AppTheme.lightBackgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Üst Bölüm: Geri Butonu ve Araç Başlığı
              Semantics(
                header: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Row(
                    children: [
                      Semantics(
                        button: true,
                        label: 'Geri Dön',
                        child: IconButton(
                          icon: const Icon(LucideIcons.arrowLeft),
                          color: isDark ? Colors.white : Colors.black87,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Orta Bölüm: Form / Inputlar
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: widget.child, 
                ),
              ),

              // Alt Bölüm: Hesapla Butonu ve Animasyonlu Sonuç Alanı
              Container(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Semantics(
                      button: true,
                      label: widget.calculateButtonText,
                      child: GlassButton(
                        onTap: widget.onCalculate,
                        child: Text(
                          widget.calculateButtonText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                    
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutExpo,
                      margin: EdgeInsets.only(top: widget.showResult ? 24.0 : 0.0),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 400),
                        opacity: widget.showResult ? 1.0 : 0.0,
                        child: widget.showResult 
                            ? RepaintBoundary(
                                key: _globalKey,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    gradient: isDark ? AppTheme.darkBackgroundGradient : AppTheme.lightBackgroundGradient,
                                  ),
                                  child: GlassCard(
                                    padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
                                    borderRadius: 24,
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            widget.resultLabel,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: isDark ? Colors.white70 : Colors.black54,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          if (widget.resultText != null)
                                            Text(
                                              widget.resultText!,
                                              style: TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.w800,
                                                color: isDark ? Colors.white : AppTheme.indigo,
                                              ),
                                              textAlign: TextAlign.center,
                                            ).animate()
                                             .fadeIn(duration: const Duration(milliseconds: 120)),
                                          const SizedBox(height: 24),
                                          Semantics(
                                            button: true,
                                            label: 'Sonucu Paylaş',
                                            child: GestureDetector(
                                              onTap: _shareResult,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                decoration: BoxDecoration(
                                                  color: AppTheme.emerald.withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(16),
                                                ),
                                                child: const Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(LucideIcons.share2, color: AppTheme.emerald, size: 20),
                                                    SizedBox(width: 8),
                                                    Text("Sonucu Paylaş", style: TextStyle(color: AppTheme.emerald, fontWeight: FontWeight.bold)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
