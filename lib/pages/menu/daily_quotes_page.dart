<<<<<<< HEAD
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyQuotesPage extends StatefulWidget {
  final String userId;
  const DailyQuotesPage({super.key, required this.userId});

  @override
  State<DailyQuotesPage> createState() => _DailyQuotesPageState();
}

class _DailyQuotesPageState extends State<DailyQuotesPage> {
  final List<String> quotes = [
    "Kesuksesan adalah hasil dari persiapan, kerja keras, dan belajar dari kegagalan.",
    "Jangan takut gagal, takutlah untuk tidak mencoba.",
    "Setiap hari adalah kesempatan baru untuk menjadi lebih baik.",
    "Keberanian bukanlah ketiadaan rasa takut, tapi kemampuan untuk menghadapinya.",
    "Jadilah versi terbaik dari dirimu sendiri.",
    "Perubahan besar dimulai dari langkah kecil yang konsisten.",
    "Hidup bukan tentang menunggu badai berlalu, tapi belajar menari di tengah hujan.",
    "Kamu lebih kuat dari yang kamu kira.",
    "Semangat adalah bahan bakar menuju impianmu.",
  ];

  late String _currentQuote;

  String get quoteKey => "dailyquote_${widget.userId}";

  @override
  void initState() {
    super.initState();
    _loadQuote();
  }

  Future<void> _loadQuote() async {
    final prefs = await SharedPreferences.getInstance();
    final savedQuote = prefs.getString(quoteKey);
    if (savedQuote != null) {
      setState(() {
        _currentQuote = savedQuote;
      });
    } else {
      _generateRandomQuote();
    }
  }

  Future<void> _generateRandomQuote() async {
    final random = Random();
    setState(() {
      _currentQuote = quotes[random.nextInt(quotes.length)];
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(quoteKey, _currentQuote);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Quotes"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepPurpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        toolbarHeight: 60,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFEDE7F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.format_quote,
                  size: 60, color: Colors.purpleAccent.shade100),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Text(
                  _currentQuote,
                  style: const TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: _generateRandomQuote,
                icon: const Icon(Icons.refresh),
                label: const Text(
                  "Kutipan Baru",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
=======
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyQuotesPage extends StatefulWidget {
  final String userId; // untuk per akun
  const DailyQuotesPage({super.key, required this.userId});

  @override
  State<DailyQuotesPage> createState() => _DailyQuotesPageState();
}

class _DailyQuotesPageState extends State<DailyQuotesPage> {
  final List<String> quotes = [
    "Kesuksesan adalah hasil dari persiapan, kerja keras, dan belajar dari kegagalan.",
    "Jangan takut gagal, takutlah untuk tidak mencoba.",
    "Setiap hari adalah kesempatan baru untuk menjadi lebih baik.",
    "Keberanian bukanlah ketiadaan rasa takut, tapi kemampuan untuk menghadapinya.",
    "Jadilah versi terbaik dari dirimu sendiri.",
    "Perubahan besar dimulai dari langkah kecil yang konsisten.",
    "Hidup bukan tentang menunggu badai berlalu, tapi belajar menari di tengah hujan.",
    "Kamu lebih kuat dari yang kamu kira.",
    "Semangat adalah bahan bakar menuju impianmu.",
  ];

  late String _currentQuote;

  String get quoteKey => "dailyquote_${widget.userId}";

  @override
  void initState() {
    super.initState();
    _loadQuote();
  }

  Future<void> _loadQuote() async {
    final prefs = await SharedPreferences.getInstance();
    final savedQuote = prefs.getString(quoteKey);
    if (savedQuote != null) {
      setState(() {
        _currentQuote = savedQuote;
      });
    } else {
      _generateRandomQuote();
    }
  }

  Future<void> _generateRandomQuote() async {
    final random = Random();
    setState(() {
      _currentQuote = quotes[random.nextInt(quotes.length)];
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(quoteKey, _currentQuote);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar gradien presisi
      appBar: AppBar(
        title: const Text("Daily Quotes"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepPurpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        toolbarHeight: 60,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFEDE7F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.format_quote,
                  size: 60, color: Colors.purpleAccent.shade100),
              const SizedBox(height: 20),

              // Card kutipan
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Text(
                  _currentQuote,
                  style: const TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 30),

              // Tombol Kutipan Baru
              ElevatedButton.icon(
                onPressed: _generateRandomQuote,
                icon: const Icon(Icons.refresh),
                label: const Text(
                  "Kutipan Baru",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
>>>>>>> bc4ed19293464f12c16099e9a02ca1f1ebdf90f4
