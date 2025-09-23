import 'package:flutter/material.dart';
import 'package:flutter_buddy/pages/main/home_page.dart';
import 'package:provider/provider.dart';
import 'pages/splash_screen.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';
// ignore: unused_import
import 'pages/home_page.dart'; 
import 'model/app_data.dart';
import 'model/theme_provider.dart';
import 'model/user_model.dart'; 

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppData()),
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
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),

      // 🔹 route awal
      initialRoute: '/splash',

      // 🔹 daftar route statis
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
      },

      // 🔹 handle route dinamis (misalnya butuh arguments)
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final args = settings.arguments as UserModel;
          return MaterialPageRoute(
            builder: (context) => HomePage(user: args),
          );
        }
        return null; // biar kalau route ga ketemu → error jelas
      },
    );
  }
}
