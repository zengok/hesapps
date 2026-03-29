class SearchTool {
  final String id;
  final String name;           // Türkçe tam isim
  final List<String> keywords; // arama için eşanlamlılar ve kısaltmalar
  final String route;          // GoRouter path
  final String icon;           // lucide_icons string karşılığı (widget olarak kullanılacak)
  final int usageRank;         // 1 = en çok kullanılan, küçük sayı önce gelir

  const SearchTool({
    required this.id,
    required this.name,
    required this.keywords,
    required this.route,
    required this.icon,
    required this.usageRank,
  });
}
