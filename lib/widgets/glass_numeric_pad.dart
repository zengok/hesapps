import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // HapticFeedback
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────────
//  GLASS NUMERIC PAD — Glassmorphism 2.0
//  4×3 grid: 1-9 | C / 0 / DEL | DONE bar
// ─────────────────────────────────────────────
class GlassNumericPad extends StatelessWidget {
  final Function(String) onKeyPress;
  final VoidCallback onBackspace;
  final VoidCallback onClear;
  final VoidCallback onDone;

  const GlassNumericPad({
    super.key,
    required this.onKeyPress,
    required this.onBackspace,
    required this.onClear,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Panel arka planı: dark→siyah cam, light→beyaz cam
    final panelColor = isDark
        ? const Color(0xFF0B0E11).withAlpha(230)
        : Colors.white.withAlpha(230);

    return Semantics(
      label: 'Sayısal Klavye',
      container: true,
      // RepaintBoundary → klavye, app widget tree'sinden izole edilir;
      // üst katmanın rebuild'i klavyeyi yeniden çizmez
      child: RepaintBoundary(
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: BackdropFilter(
            // Arkadaki form içeriği bulanıklaşır
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              decoration: BoxDecoration(
                color: panelColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withAlpha(40),
                    width: 1.2,
                  ),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(70),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // ── ROW 1 : 1 2 3
                  _KeyRow(
                    keys: const [
                      _KeySpec('1'),
                      _KeySpec('2'),
                      _KeySpec('3'),
                    ],
                    onKeyPress: onKeyPress,
                    onBackspace: onBackspace,
                    onClear: onClear,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),

                  // ── ROW 2 : 4 5 6
                  _KeyRow(
                    keys: const [
                      _KeySpec('4'),
                      _KeySpec('5'),
                      _KeySpec('6'),
                    ],
                    onKeyPress: onKeyPress,
                    onBackspace: onBackspace,
                    onClear: onClear,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),

                  // ── ROW 3 : 7 8 9
                  _KeyRow(
                    keys: const [
                      _KeySpec('7'),
                      _KeySpec('8'),
                      _KeySpec('9'),
                    ],
                    onKeyPress: onKeyPress,
                    onBackspace: onBackspace,
                    onClear: onClear,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),

                  // ── ROW 4 : C  0  ⌫
                  _KeyRow(
                    keys: const [
                      _KeySpec('C', isAction: true),
                      _KeySpec('0'),
                      _KeySpec('DEL', isAction: true),
                    ],
                    onKeyPress: onKeyPress,
                    onBackspace: onBackspace,
                    onClear: onClear,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),

                  // ── DONE pill button (full width, prominent glow)
                  Semantics(
                    button: true,
                    label: 'Tamam',
                    child: _DoneButton(onDone: onDone, isDark: isDark),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  KeySpec: sadece veri taşıyan immutable obje
// ─────────────────────────────────────────────
@immutable
class _KeySpec {
  final String value;
  final bool isAction;
  const _KeySpec(this.value, {this.isAction = false});
}

// ─────────────────────────────────────────────
//  KeyRow: tek satır → her satır kendi RepaintBoundary'si
// ─────────────────────────────────────────────
class _KeyRow extends StatelessWidget {
  final List<_KeySpec> keys;
  final Function(String) onKeyPress;
  final VoidCallback onBackspace;
  final VoidCallback onClear;
  final bool isDark;

  const _KeyRow({
    required this.keys,
    required this.onKeyPress,
    required this.onBackspace,
    required this.onClear,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Row(
        children: keys.map((spec) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: _GlassKey(
                spec: spec,
                isDark: isDark,
                onTap: () {
                  if (spec.value == 'DEL') {
                    onBackspace();
                  } else if (spec.value == 'C') {
                    onClear();
                  } else {
                    onKeyPress(spec.value);
                  }
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  GlassKey: referans görsel özelliklerine tam uyumlu
//  • %10 opak beyaz fill
//  • 1.2px net beyaz border
//  • Basma: içe sink + koyu fill (dokunsal hisi)
//  • Bırakma: cam formuna smooth dönüş
// ─────────────────────────────────────────────
class _GlassKey extends StatefulWidget {
  final _KeySpec spec;
  final VoidCallback onTap;
  final bool isDark;

  const _GlassKey({
    required this.spec,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<_GlassKey> createState() => _GlassKeyState();
}

class _GlassKeyState extends State<_GlassKey>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _pressAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 160),
    );
    _pressAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onDown(TapDownDetails _) {
    _ctrl.forward();
    // Dokunsal geri bildirim
    HapticFeedback.lightImpact();
  }

  void _onUp(TapUpDetails _) {
    _ctrl.reverse();
    widget.onTap();
  }

  void _onCancel() => _ctrl.reverse();

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final isAction = widget.spec.isAction; // C ve DEL tuşları
    final isDel = widget.spec.value == 'DEL';
    final isC = widget.spec.value == 'C';

    // Renk: action tuşları hafifçe farklı tint alır
    final baseColor = isAction
        ? Colors.white.withAlpha(18)  // %7 white — daha soluk
        : Colors.white.withAlpha(26); // %10 white — standart

    final pressedColor = isDark
        ? Colors.white.withAlpha(55)  // %22 white — basma koyulaşma efekti
        : Colors.black.withAlpha(30); // light modda hafif koyulaşma

    final textColor = isC
        ? AppTheme.rose         // Clear → kırmızı vurgu
        : Theme.of(context).colorScheme.onSurface;

    return Semantics(
      button: true,
      label: isDel ? 'Sil' : (isC ? 'Temizle' : 'Tuş ${widget.spec.value}'),
      child: GestureDetector(
        onTapDown: _onDown,
        onTapUp: _onUp,
        onTapCancel: _onCancel,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _pressAnim,
          builder: (context, _) {
            final p = _pressAnim.value; // 0.0 → 1.0

            return Container(
              height: 62,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Color.lerp(baseColor, pressedColor, p),
                border: Border.all(
                  // Basınca border biraz solar
                  color: Colors.white.withAlpha((30 - p * 15).toInt().clamp(0, 255)),
                  width: 1.2,
                ),
                boxShadow: [
                  // Dış parlaması — basınca söner
                  BoxShadow(
                    color: Colors.white.withAlpha(((1 - p) * 18).toInt()),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                  // İç gölge illüzyonu (basınca belirir)
                  BoxShadow(
                    color: Colors.black.withAlpha((p * 60).toInt()),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Center(
                    child: isDel
                        ? Icon(LucideIcons.delete, color: textColor, size: 24)
                        : isC
                            ? Text(
                                'C',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                              )
                            : Text(
                                widget.spec.value,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w400,
                                  color: textColor,
                                  letterSpacing: 0,
                                ),
                              ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  DONE Button — pill shape, prominent outer glow
// ─────────────────────────────────────────────
class _DoneButton extends StatefulWidget {
  final VoidCallback onDone;
  final bool isDark;
  const _DoneButton({required this.onDone, required this.isDark});

  @override
  State<_DoneButton> createState() => _DoneButtonState();
}

class _DoneButtonState extends State<_DoneButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _ctrl.forward();
        HapticFeedback.mediumImpact();
      },
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onDone();
      },
      onTapCancel: () => _ctrl.reverse(),
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (context, _) {
          final p = _anim.value;
          return Container(
            height: 62,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100), // Tam pill
              color: Colors.white.withAlpha((26 + (p * 20)).toInt()),
              border: Border.all(
                color: Colors.white.withAlpha((80 - (p * 30)).toInt()),
                width: 1.2,
              ),
              boxShadow: [
                // Referans: Done butonu belirgin dış parlama
                BoxShadow(
                  color: Colors.white.withAlpha(((1 - p) * 35).toInt()),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.white.withAlpha(((1 - p) * 12).toInt()),
                  blurRadius: 40,
                  spreadRadius: 6,
                ),
                // Basınçta iç gölge
                BoxShadow(
                  color: Colors.black.withAlpha((p * 50).toInt()),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Center(
                  child: Text(
                    'TAMAM',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.0,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  showGlassNumericPad — modal helper
// ─────────────────────────────────────────────
Future<void> showGlassNumericPad({
  required BuildContext context,
  required TextEditingController controller,
  Function(String)? onChanged,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 120 / 255),
    builder: (ctx) => GlassNumericPad(
      onKeyPress: (char) {
        // Nokta tekrar girişini engelle
        if (char == '.' && controller.text.contains('.')) return;
        controller.text += char;
        onChanged?.call(controller.text);
      },
      onBackspace: () {
        if (controller.text.isNotEmpty) {
          controller.text =
              controller.text.substring(0, controller.text.length - 1);
          onChanged?.call(controller.text);
        }
      },
      onClear: () {
        controller.clear();
        onChanged?.call('');
      },
      onDone: () => Navigator.pop(ctx),
    ),
  );
}
