import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

// 🧩 Import semua model dan halaman yang kamu punya
import 'package:flutter_buddy/model/app_data.dart';
import 'package:flutter_buddy/model/theme_provider.dart';
import 'package:flutter_buddy/model/app_theme.dart';
import 'package:flutter_buddy/model/user_model.dart';

import 'package:flutter_buddy/pages/splash_screen.dart';
import 'package:flutter_buddy/pages/auth/login_page.dart';
import 'package:flutter_buddy/pages/auth/register_page.dart';
import 'package:flutter_buddy/pages/main/home_page.dart';

import 'pages/admin/admin_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

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

      // 🎨 Gunakan theme mode dari provider
      themeMode: themeProvider.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      // 🧭 Route awal
      initialRoute: '/splash',

      // 📌 Daftar route statis
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/admin': (context) => const AdminPage(
              loggedUsers: [],
            ), // ✅ Tambah route admin
      },

      // 🧭 Route dinamis (pakai args)
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final args = settings.arguments as UserModel;
          return MaterialPageRoute(
            builder: (context) => HomePage(user: args),
          );
        }
        return null;
      },
    );
  }
}
