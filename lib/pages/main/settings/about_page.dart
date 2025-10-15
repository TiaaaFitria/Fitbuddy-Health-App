// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_buddy/model/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  /// Launch URL: try external app first, fallback to in-app web view / browser.
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);

    // Try external application (native app)
    try {
      bool launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (launched) return;
    } catch (_) {
      // ignore and fallback
    }

    // Fallback: open in an in-app webview (or default browser if not available)
    if (!await launchUrl(uri, mode: LaunchMode.inAppWebView)) {
      // last resort: try default browser
      if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
        // Jika semua gagal, tunjukkan pesan error
        throw 'Could not launch $url';
      }
    }
  }

  Widget _buildSocialIcon({
    required String assetPath,
    required String label,
    required String url,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: () => _launchURL(url),
      borderRadius: BorderRadius.circular(60),
      splashColor: Colors.white24,
      child: Column(
        children: [
          // Lingkaran latar yang subtle supaya logo tetap jelas
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.08),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.06),
                  blurRadius: 2,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Image.asset(
              assetPath,
              width: 46,
              height: 46,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.mainGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo & Title
                Column(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.25),
                            blurRadius: 26,
                            spreadRadius: 6,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        image: const DecorationImage(
                          image: AssetImage("assets/profile.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      "FitBuddy Health 🧠💙",
                      style: textTheme.headlineLarge?.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Teman kecil untuk hatimu",
                      style: textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Tentang Saya
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(0.10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Text(
                        "✨ Tentang Saya",
                        style: textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "✨ Tia Fitrianingsih\n"
                        "📍 Lahir di Purwakarta, Jawa Barat\n"
                        "🏠 Tinggal di Ponorogo, Jawa Timur\n"
                        "💻 Mahasiswi Informatika, Universitas Negeri Surabaya (NIM: 241111814082)\n"
                        "🚀 Passion: Pengembangan aplikasi, pemrograman & data\n"
                        "🏐 Hobi: Bermain voli, teamwork & disiplin",
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 26),

                // Tentang Aplikasi
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(0.10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: const [
                      Text(
                        "✨ Tentang Aplikasi",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),
                      Text(
                        "FitBuddy Health lahir dari ide sederhana tapi bermakna: menghadirkan ruang aman, privat, dan estetik untuk menuliskan perasaan. Nama “FitBuddy” sendiri berasal dari nama pembuat, Fitria, dipadukan dengan kata “Buddy” yang berarti teman—sebagai simbol kehadiran aplikasi ini sebagai teman kecil yang selalu ada untukmu.\n\n"
                        "Aplikasi ini terinspirasi dari kebiasaan banyak Gen Z yang suka menulis buku harian, namun sering merasa khawatir isi tulisannya terbaca orang lain. Dengan FitBuddy Health, kamu bisa menulis bebas tanpa takut dihakimi, sambil belajar merawat kesehatan mental secara mudah dan menyenangkan.\n\n"
                        "Tujuan utama FitBuddy Health jelas: menjadi teman yang menemani, membantu melepas stres, dan memberi energi positif setiap hari. Aplikasi ini bukan sekadar proyek kuliah, tapi wujud nyata kepedulian terhadap kesejahteraan mental generasi muda.\n\n"
                        "📅 Final Aplikasi: 15 Oktober 2025\n"
                        "✨ Caring for your mind, one note at a time ✨",
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Social icons (centered)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSocialIcon(
                      assetPath: "assets/icons/instagram.png",
                      label: "Instagram",
                      url: "https://www.instagram.com/tia_ftrn?igsh=eWxrbTQ5eXpseDRs&utm_source=qr",
                      context: context,
                    ),
                    _buildSocialIcon(
                      assetPath: "assets/icons/github.png",
                      label: "GitHub",
                      url: "https://github.com/TiaaaFitria?tab=repositories",
                      context: context,
                    ),           
                  ],
                ),

                const SizedBox(height: 34),

                Text(
                  "🌿 Made with love by Tia Fitrianingsih",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
