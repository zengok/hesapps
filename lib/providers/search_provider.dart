import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/search_tool.dart';
import '../data/search_tools_data.dart';

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  void updateQuery(String value) => state = value;
}

// Arama metni state'i
final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

// Filtrelenmiş sonuçlar — türetilmiş provider
final searchResultsProvider = Provider<List<SearchTool>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  
  if (query.isEmpty) {
    // Boşken en çok kullanılanları sırayla göster
    return [...allTools]..sort((a, b) => a.usageRank.compareTo(b.usageRank));
  }
  
  // Türkçe karakter normalize fonksiyonu
  String normalize(String s) => s
      .replaceAll('ı', 'i').replaceAll('İ', 'i').replaceAll('ğ', 'g')
      .replaceAll('Ğ', 'g').replaceAll('ü', 'u').replaceAll('Ü', 'u')
      .replaceAll('ş', 's').replaceAll('Ş', 's').replaceAll('ö', 'o')
      .replaceAll('Ö', 'o').replaceAll('ç', 'c').replaceAll('Ç', 'c')
      .toLowerCase();

  final nQuery = normalize(query);

  return allTools.where((tool) {
    final nName = normalize(tool.name);
    // İsim başından eşleşme (en yüksek öncelik)
    if (nName.startsWith(nQuery)) return true;
    // İsim içinde geçiyor
    if (nName.contains(nQuery)) return true;
    // Keyword'lerden herhangi biri eşleşiyor
    return tool.keywords.any((kw) => normalize(kw).contains(nQuery));
  }).toList()
    ..sort((a, b) {
      final nA = normalize(a.name);
      final nB = normalize(b.name);
      // Baştan eşleşenler üste
      final aStarts = nA.startsWith(nQuery) ? 0 : 1;
      final bStarts = nB.startsWith(nQuery) ? 0 : 1;
      if (aStarts != bStarts) return aStarts.compareTo(bStarts);
      return a.usageRank.compareTo(b.usageRank);
    });
});
