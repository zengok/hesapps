import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme.dart';
import 'providers/theme_provider.dart';
import 'providers/lang_provider.dart';
import 'providers/app_data_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => AppDataProvider()),
      ],
      child: const HesAppsApp(),
    ),
  );
}

class HesAppsApp extends StatelessWidget {
  const HesAppsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // İleride intl ile çoklu dil ebatlarına adaptasyon yapılırken langProvider.currentLocale kullanılabilir
    // final langProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      title: 'Tüm Hesaplamalar',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
