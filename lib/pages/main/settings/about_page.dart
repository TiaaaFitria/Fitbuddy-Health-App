import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF89CFF0), Color(0xFF6A5ACD)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo + Judul
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Image.asset(
                          "assets/logo.png",
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "FitBuddy Health 🧠💙",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Card dengan deskripsi
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(18),
                    child:const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Nama Fit diambil dari Fitria, pembuat aplikasi ini, lalu dipadukan dengan kata Buddy yang berarti teman. Dari sini lahirlah ide untuk menghadirkan aplikasi yang sederhana namun bermakna: ruang aman, privat, dan estetik untuk menuliskan perasaan.",
                          style: TextStyle(fontSize: 16, height: 1.5),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "FitBuddy Health terinspirasi dari kebiasaan Gen Z yang suka menulis buku harian, tapi sering khawatir isi tulisannya terbaca orang lain. Lewat aplikasi ini, kamu bisa bebas menuliskan pikiran dan perasaan tanpa takut dihakimi, sekaligus belajar merawat diri dengan cara yang mudah.",
                          style: TextStyle(fontSize: 16, height: 1.5),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Tujuannya jelas: FitBuddy Health ingin menjadi teman kecil yang selalu ada—teman yang bisa menemani, membantu melepas stres, dan memberi energi positif setiap hari.",
                          style: TextStyle(fontSize: 16, height: 1.5),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Dibuat oleh Tia Fitrianingsih, mahasiswa Informatika, aplikasi ini bukan hanya sekadar proyek kuliah. Lebih dari itu, ini adalah bentuk nyata kepedulian terhadap kesehatan mental generasi muda.",
                          style: TextStyle(fontSize: 16, height: 1.5),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tagline
                  const Text(
                    "✨c",
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
