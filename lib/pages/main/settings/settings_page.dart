import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_buddy/model/app_theme.dart';
import 'package:flutter_buddy/widgets/gradient_background.dart';
import 'package:flutter_buddy/pages/auth/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/app_state.dart';
import 'notifications_page.dart';
import 'appearance_page.dart';
import 'about_page.dart';
import 'device_info_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _showLogoutDialog(BuildContext context) async {
    double userRating = 0;
    TextEditingController feedbackController = TextEditingController();

    String getRatingText(double rating) {
      if (rating <= 1) return "Kurang";
      if (rating <= 2) return "Cukup";
      if (rating <= 3) return "Baik";
      if (rating <= 4) return "Sangat Baik";
      return "Sangat Direkomendasikan";
    }

    Future<void> _saveFeedback(String feedback, double rating) async {
      final prefs = await SharedPreferences.getInstance();
      List<String> feedbacks = prefs.getStringList('user_feedbacks') ?? [];
      if (feedback.trim().isNotEmpty) {
        feedbacks.add("⭐ $rating - $feedback");
        await prefs.setStringList('user_feedbacks', feedbacks);
      }
    }

    await showGeneralDialog(
      context: context,
      barrierLabel: "LogoutDialog",
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final curvedValue = Curves.easeOutBack.transform(anim1.value);
        return Transform.scale(
          scale: curvedValue,
          child: Opacity(
            opacity: anim1.value,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.lightBlue, AppTheme.primaryBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.favorite, color: Colors.white, size: 40),
                        const SizedBox(height: 10),
                        const Text(
                          "Terima kasih telah menggunakan FitBuddy 💙",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Bagaimana pengalaman kamu menggunakan aplikasi ini?",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 16),
                        RatingBar.builder(
                          initialRating: 0,
                          minRating: 1,
                          maxRating: 5,
                          itemCount: 5,
                          itemSize: 38,
                          glow: true,
                          unratedColor: Colors.white38,
                          itemBuilder: (context, _) => const Icon(Icons.star_rounded, color: Colors.amber),
                          onRatingUpdate: (value) => setState(() => userRating = value),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          getRatingText(userRating),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: feedbackController,
                          decoration: InputDecoration(
                            hintText: "Tulis saran atau komentar kamu...",
                            hintStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.white24,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.white),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Batal", style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber.shade600,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () async {
                                  await _saveFeedback(feedbackController.text, userRating);
                                  currentUser = null;
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginPage()),
                                  );
                                },
                                child: const Text("Kirim & Logout", style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade600,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () async {
                                  await _saveFeedback(feedbackController.text, userRating);
                                  Navigator.pop(context);
                                },
                                child: const Text("Kirim & Kembali", style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.transparent, elevation: 0),
      extendBodyBehindAppBar: true,
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.notifications, color: Colors.white),
                title: const Text("Notifications & Reminder", style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsPage())),
              ),
              ListTile(
                leading: const Icon(Icons.color_lens, color: Colors.white),
                title: const Text("Appearance", style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AppearancePage())),
              ),
              ListTile(
                leading: const Icon(Icons.devices, color: Colors.white),
                title: const Text("Device Info", style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DeviceInfoPage())),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.white),
                title: const Text("About", style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutPage())),
              ),
              const Divider(color: Colors.white38, thickness: 0.7),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text("Logout", style: TextStyle(color: Colors.white)),
                onTap: () => _showLogoutDialog(context),
              ),
            ],
          ),
        ),
      ),

      // 🔽 KODE LAMA DISIMPAN TAPI DIKOMENTARI UNTUK MENGHINDARI ERROR
      /*
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.teal),
              title: const Text("Notifications & Reminder"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.color_lens, color: Colors.teal),
              title: const Text("Appearance"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AppearancePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.teal),
              title: const Text("About"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () => _showLogoutDialog(context),
            ),
          ],
        ),
      ),
      */
    );
  }
}
