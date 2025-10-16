<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter_buddy/model/app_data.dart';
import 'package:flutter_buddy/model/theme_provider.dart';
import 'package:flutter_buddy/model/app_theme.dart';
import 'package:flutter_buddy/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  setUrlStrategy(PathUrlStrategy());

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => AppData()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FitBuddy Health",
      themeMode: themeProvider.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const SplashScreen(),
      routes: {},
    );
  }
}
=======
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

// 🧩 Import semua model dan halaman
import 'package:flutter_buddy/model/app_data.dart';
import 'package:flutter_buddy/model/theme_provider.dart';
import 'package:flutter_buddy/model/app_theme.dart';
//import 'package:flutter_buddy/model/user_model.dart';

import 'package:flutter_buddy/pages/splash_screen.dart';
//import 'package:flutter_buddy/pages/auth/login_page.dart';
//import 'package:flutter_buddy/pages/auth/register_page.dart';
//import 'package:flutter_buddy/pages/main/home_page.dart';
//import 'package:flutter_buddy/pages/admin/admin_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🗓️ Inisialisasi format tanggal lokal Indonesia
  await initializeDateFormatting('id_ID', null);

  // 🌐 Hilangkan # di URL
  setUrlStrategy(PathUrlStrategy());

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => AppData()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FitBuddy Health",

      // 🎨 Tema aplikasi
      themeMode: themeProvider.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      // 🏁 Splash screen jadi root (URL bersih tanpa /splash)
      home: const SplashScreen(),

      // ⛔ Pastikan tidak ada route default yang menambah "/splash"
      routes: {},
    );
  }
}
>>>>>>> bc4ed19293464f12c16099e9a02ca1f1ebdf90f4
