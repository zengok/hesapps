import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart'; // boş durum fadeIn (A4)
import '../providers/search_provider.dart';
import '../data/search_tools_data.dart';
import '../widgets/glass_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    
    // Ekran açıldığında klavyeyi otomatik aç (delay olmadan)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchResultsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent, // ShellRoute'dan dark/light base alır
      body: SafeArea(
        child: Column(
          children: [
            // Arama hücresi
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
              child: GlassCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    // TÜRKÇE Q KLAVYE (doğru eşleşme için zorunlu koşullar)
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: true,
                    autocorrect: false,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Hesaplama aracı ara...',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.white54 : Colors.black38,
                      ),
                      prefixIcon: Icon(
                        LucideIcons.search,
                        color: isDark ? Colors.white54 : Colors.black38,
                      ),
                      suffixIcon: _controller.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                LucideIcons.x,
                                color: isDark ? Colors.white54 : Colors.black38,
                              ),
                              onPressed: () {
                                _controller.clear();
                                ref.read(searchQueryProvider.notifier).updateQuery('');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onChanged: (value) {
                      ref.read(searchQueryProvider.notifier).updateQuery(value);
                    },
                    onSubmitted: (value) {
                      // Klavyedeki ara tuşuna basıldığında
                      if (results.isNotEmpty) {
                         // ilk sonucu açabilir
                      }
                    },
                  ),
                ),
              ),
            ),

            // Başlık
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  ref.watch(searchQueryProvider).isEmpty
                      ? 'En Çok Kullanılanlar'
                      : '${results.length} sonuç',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ),
            ),

            // Sonuç listesi
            Expanded(
              child: results.isEmpty
                  ? Center(
                      child: Text(
                        'Sonuç bulunamadı',
                        style: TextStyle(
                          color: isDark ? Colors.white54 : Colors.black45,
                        ),
                      ),
                    ).animate().fadeIn(duration: const Duration(milliseconds: 150))
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: results.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final tool = results[index];
                        return GlassCard(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                toolIcon(tool.icon),
                                color: isDark ? Colors.white : Colors.black87,
                                size: 24,
                              ),
                            ),
                            title: Text(
                              tool.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            trailing: Icon(
                              LucideIcons.chevronRight,
                              color: isDark ? Colors.white38 : Colors.black26,
                            ),
                            onTap: () {
                              _focusNode.unfocus();
                              ref.read(searchQueryProvider.notifier).updateQuery('');
                              context.push(tool.route);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
