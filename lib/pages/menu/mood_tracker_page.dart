import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MoodTrackerPage extends StatefulWidget {
  final String userId;
  const MoodTrackerPage({super.key, required this.userId});

  @override
  State<MoodTrackerPage> createState() => _MoodTrackerPageState();
}

class _MoodTrackerPageState extends State<MoodTrackerPage> {
  String? _selectedMood;
  List<Map<String, dynamic>> _moodHistory = [];
  final List<Map<String, dynamic>> moods = [
    {"emoji": "😊", "label": "Happy", "color": Colors.yellow},
    {"emoji": "😐", "label": "Neutral", "color": Colors.grey},
    {"emoji": "😢", "label": "Sad", "color": Colors.blue},
    {"emoji": "😡", "label": "Angry", "color": Colors.red},
    {"emoji": "😴", "label": "Tired", "color": Colors.purple},
  ];

  @override
  void initState() {
    super.initState();
    _loadMoodHistory();
  }

  Future<void> _loadMoodHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('mood_${widget.userId}');
    if (data != null) {
      setState(() {
        _moodHistory =
            List<Map<String, dynamic>>.from(json.decode(data) as List);
      });
    }
  }

  Future<void> _saveMoodHistory() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('mood_${widget.userId}', json.encode(_moodHistory));
  }

  void _saveMood() {
    if (_selectedMood != null) {
      setState(() {
        _moodHistory.insert(0, {
          "mood": _selectedMood!,
          "time": DateTime.now().toIso8601String(),
        });
        _selectedMood = null;
      });
      _saveMoodHistory();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mood berhasil disimpan!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mood Tracker"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        toolbarHeight: 60,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Bagaimana perasaanmu hari ini?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: moods.map((mood) {
                bool isSelected = _selectedMood == mood["label"];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMood =
                          isSelected ? null : mood["label"] as String;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 18),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (mood["color"] as Color).withOpacity(0.8)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: mood["color"], width: 2),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: (mood["color"] as Color).withOpacity(0.6),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : [],
                    ),
                    child: Text(
                      "${mood["emoji"]} ${mood["label"]}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 25),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: _saveMood,
                icon: const Icon(Icons.save),
                label: const Text(
                  "Simpan Mood",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Riwayat Mood:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _moodHistory.isEmpty
                  ? const Center(child: Text("Belum ada mood yang dicatat."))
                  : ListView.builder(
                      itemCount: _moodHistory.length,
                      itemBuilder: (context, index) {
                        final item = _moodHistory[index];
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            leading:
                                const Icon(Icons.mood, color: Colors.pink),
                            title: Text(
                              item["mood"],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "Dicatat pada ${DateTime.parse(item["time"]).toString().substring(0, 16)}",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
