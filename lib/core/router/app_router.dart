import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../screens/home_screen.dart';
import '../../screens/settings_screen.dart';
import '../../screens/main_scaffold.dart';
import '../../screens/category_screen.dart';
import '../../screens/history_screen.dart';
import '../../models/category_model.dart';
import '../../screens/search_screen.dart';
import '../../screens/about_screen.dart';

// Finansal
import '../../features/financial/presentation/screens/kdv_screen.dart';
import '../../features/financial/presentation/screens/doviz_screen.dart';
import '../../features/financial/presentation/screens/iskonto_screen.dart';
import '../../features/financial/presentation/screens/kar_marji_screen.dart';
import '../../features/financial/presentation/screens/enflasyon_screen.dart';
import '../../features/financial/presentation/screens/maas_vergi_screen.dart';

// Bankacılık
import '../../features/banking/presentation/screens/kredi_screen.dart';
import '../../features/banking/presentation/screens/mevduat_screen.dart';
import '../../features/banking/presentation/screens/kredi_karti_screen.dart';

// Sağlık
import '../../features/health/presentation/screens/bmi_screen.dart';
import '../../features/health/presentation/screens/ideal_kilo_screen.dart';
import '../../features/health/presentation/screens/bmr_screen.dart';
import '../../features/health/presentation/screens/su_tuketimi_screen.dart';
import '../../features/health/presentation/screens/hamilelik_screen.dart';

// Teknik
import '../../features/technical/presentation/screens/birim_donusturucu_screen.dart';
import '../../features/technical/presentation/screens/sicaklik_screen.dart';
import '../../features/technical/presentation/screens/yakit_screen.dart';
import '../../features/technical/presentation/screens/internet_hizi_screen.dart';

// Eğitim
import '../../features/education/presentation/screens/lgs_yks_screen.dart';
import '../../features/education/presentation/screens/gno_screen.dart';
import '../../features/education/presentation/screens/yas_screen.dart';

// Günlük
import '../../features/daily/presentation/screens/bahsis_screen.dart';
import '../../features/daily/presentation/screens/indirim_fiyat_screen.dart';
import '../../features/daily/presentation/screens/tarih_farki_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final shellNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        pageBuilder: (context, state, child) => NoTransitionPage(child: MainScaffold(child: child)),
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          GoRoute(path: '/history', builder: (context, state) => const HistoryScreen()),
          GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),
          GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
        ],
      ),
      GoRoute(path: '/category', parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => CategoryScreen(category: state.extra as Category)),

      // --- FİNANSAL ---
      GoRoute(path: '/kdv', parentNavigatorKey: rootNavigatorKey, builder: (_, __) => const KdvScreen()),
      GoRoute(path: '/doviz', parentNavigatorKey: rootNavigatorKey, builder: (_, __) => const DovizScreen()),
      GoRoute(path: '/iskonto', parentNavigatorKey: rootNavigatorKey, builder: (_, __) => const IskontoScreen()),
      GoRoute(path: '/karmarji', parentNavigatorKey: rootNavigatorKey, builder: (_, __) => const KarMarjiScreen()),
      GoRoute(path: '/enflasyon', parentNavigatorKey: rootNavigatorKey, builder: (_, __) => const EnflasyonScreen()),
      GoRoute(path: '/maasvergi', parentNavigatorKey: rootNavigatorKey, builder: (_, __) => const MaasVergiScreen()),

      // --- BANKACILIK ---
      GoRoute(path: '/kredi', parentNavigatorKey: rootNavigatorKey, builder: (_, __) => const KrediScreen()),
      GoRoute(path: '/mevduat', parentNavigatorKey: rootNavigatorKey, builder: (_, __) => const MevduatScreen()),
      GoRoute(path: '/kredikartiasgari', parentNavigatorKey: rootNavigatorKey, builder: (_, __) => const KrediKartiScreen()),

      // --- SAĞLIK ---
      GoRoute(path: '/bmi', parentNavigatorKey: rootNavigatorKey, builder: (_, __) => const BmiScreen()),
      GoRoute(path: '/idealkilo', parentNavigatorKey: rootNavigatorKey, builder: (_, __) => const IdealKiloScreen()),
      GoRoute(path: '/bmr', parentNavigatorKey: rootNavigatorKey, builder: (_, __) => const BmrScreen()),
      GoRoute(path: '/sutuketimi', parentNavigatorKey: rootNavigatorKey, builder: (_, __) => const SuTuketimiScreen()),
      GoRoute(path: '/hamilelik', parentNavigatorKey: rootNavigatorKey, builder: (_, __) => const HamilelikScreen()),

      // --- TEKNİK ---
      GoRoute(path: '/birim', parentNavigatorKey: rootNavigatorKey, builder: (_, __) => const BirimDonusturucuScreen()),
      GoRoute(path: '/sicaklik', parentNavigatorKey: rootNavigatorKey, builder: (_, __) => const SicaklikScreen()),
      GoRoute(path: '/yakit', parentNavigatorKey: rootNavigatorKey, builder: (_, __) => const YakitScreen()),
      GoRoute(path: '/internet', parentNavigatorKey: rootNavigatorKey, builder: (_, __) => const InternetHiziScreen()),

      // --- EĞİTİM ---
      GoRoute(path: '/lgsyks', parentNavigatorKey: rootNavigatorKey, builder: (_, __) => const LgsYksScreen()),
      GoRoute(path: '/gno', parentNavigatorKey: rootNavigatorKey, builder: (_, __) => const GnoScreen()),
      GoRoute(path: '/yas', parentNavigatorKey: rootNavigatorKey, builder: (_, __) => const YasHesaplamaScreen()),

      // --- GÜNLÜK ---
      GoRoute(path: '/bahsis', parentNavigatorKey: rootNavigatorKey, builder: (_, __) => const BahsisScreen()),
      GoRoute(path: '/indirimlifiyat', parentNavigatorKey: rootNavigatorKey, builder: (_, __) => const IndirimFiyatScreen()),
      GoRoute(path: '/tarihfarki', parentNavigatorKey: rootNavigatorKey, builder: (_, __) => const TarihFarkiScreen()),
      GoRoute(path: '/about', parentNavigatorKey: rootNavigatorKey, builder: (context, state) => const AboutScreen()),
    ],
  );
});
