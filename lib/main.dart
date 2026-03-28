import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as legacy_provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/lang_provider.dart';
import 'providers/app_data_provider.dart';
import 'core/router/app_router.dart';
import 'core/localization/app_localizations.dart';

void main() {
  runApp(
    ProviderScope(
      child: legacy_provider.MultiProvider(
        providers: [
          legacy_provider.ChangeNotifierProvider(create: (_) => ThemeProvider()),
          legacy_provider.ChangeNotifierProvider(create: (_) => LanguageProvider()),
          legacy_provider.ChangeNotifierProvider(create: (_) => AppDataProvider()),
        ],
        child: const HesAppsApp(),
      ),
    ),
  );
}

class HesAppsApp extends ConsumerWidget {
  const HesAppsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Provider'ları dinle — dil veya tema değişince sadece bu widget rebuild olur
    final themeProvider = legacy_provider.Provider.of<ThemeProvider>(context);
    final langProvider = legacy_provider.Provider.of<LanguageProvider>(context);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Tüm Hesaplamalar',
      debugShowCheckedModeBanner: false,

      // Tema
      themeMode: themeProvider.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      // Lokalizasyon
      locale: langProvider.currentLocale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      routerConfig: router,
    );
  }
}
