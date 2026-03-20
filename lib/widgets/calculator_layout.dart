import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme.dart';
import 'glass_card.dart';

class CalculatorLayout extends StatelessWidget {
  final String title;
  final Widget child; // Giriş parametreleri (inputlar) buraya aktarılır.
  final VoidCallback onCalculate;
  final String? resultText;
  final String resultLabel;
  final bool showResult;
  final String calculateButtonText;

  const CalculatorLayout({
    Key? key,
    required this.title,
    required this.child,
    required this.onCalculate,
    this.resultText,
    this.resultLabel = "Sonuç",
    this.showResult = false,
    this.calculateButtonText = "Hesapla",
  }) : super(key: key);

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(LucideIcons.arrowLeft),
                      color: isDark ? Colors.white : Colors.black87,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
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

              // Orta Bölüm: Form / Inputlar
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: child, // İçerik, giriş alanı olarak gelen Widget olacak.
                ),
              ),

              // Alt Bölüm: Hesapla Butonu ve Animasyonlu Sonuç Alanı
              Container(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Hesapla Butonu: Gradient ve hafif Glass saydam efekti
                    GestureDetector(
                      onTap: onCalculate,
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.emerald.withOpacity(0.7),
                              AppTheme.indigo.withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.emerald.withOpacity(0.25),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            calculateButtonText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Sonuç Alanı (Aşağıdan yukarı Slide ve Fade-in animasyonlu)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutExpo,
                      margin: EdgeInsets.only(top: showResult ? 24.0 : 0.0),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 400),
                        opacity: showResult ? 1.0 : 0.0,
                        child: showResult 
                            ? GlassCard(
                                padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
                                borderRadius: 24,
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        resultLabel,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: isDark ? Colors.white70 : Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      if (resultText != null)
                                        Text(
                                          resultText!,
                                          style: TextStyle(
                                            fontSize: 40, // Büyük puntolu sonuç
                                            fontWeight: FontWeight.w800,
                                            color: isDark ? Colors.white : AppTheme.indigo,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                    ],
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
