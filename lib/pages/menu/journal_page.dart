import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JournalPage extends StatefulWidget {
  final String userId;
  const JournalPage({super.key, required this.userId});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  List<Map<String, dynamic>> _journalEntries = [];

  String get userKey => "journal_${widget.userId}";

  @override
  void initState() {
    super.initState();
    _loadJournal();
  }

  Future<void> _loadJournal() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(userKey);
    if (data != null) {
      setState(() {
        _journalEntries = List<Map<String, dynamic>>.from(
            json.decode(data) as List);
      });
    }
  }

  Future<void> _saveJournalData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(userKey, json.encode(_journalEntries));
  }

  void _saveJournal() {
    if (_titleController.text.trim().isEmpty &&
        _contentController.text.trim().isEmpty) return;

    setState(() {
      _journalEntries.insert(0, {
        "title": _titleController.text.trim(),
        "content": _contentController.text.trim(),
        "time": DateTime.now().toIso8601String(),
      });
      _titleController.clear();
      _contentController.clear();
    });

    _saveJournalData();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Jurnal berhasil disimpan!")),
    );
  }

  String formatTime(String iso) {
    DateTime dt = DateTime.parse(iso);
    return "${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2,'0')}";
  }

  void openJournal(Map<String, dynamic> entry) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JournalDetailPage(entry: entry),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buku Harian Interaktif"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF3E5F5), Color(0xFFEDE7F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Input Judul ---
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Judul Jurnal",
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 8),
            // --- Input Isi ---
            TextField(
              controller: _contentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Tulis jurnal harianmu di sini...",
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton.icon(
                onPressed: _saveJournal,
                icon: const Icon(Icons.book),
                label: const Text("Simpan Jurnal"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Daftar Jurnal",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _journalEntries.isEmpty
                  ? const Center(
                      child: Text("Belum ada jurnal."),
                    )
                  : ListView.builder(
                      itemCount: _journalEntries.length,
                      itemBuilder: (context, index) {
                        final entry = _journalEntries[index];
                        return GestureDetector(
                          onTap: () => openJournal(entry),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 2),
                            child: ListTile(
                              title: Text(
                                entry["title"].isEmpty
                                    ? "Tanpa Judul"
                                    : entry["title"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  "Dicatat pada ${formatTime(entry["time"])}"),
                              trailing: const Icon(Icons.arrow_forward_ios,
                                  size: 16, color: Colors.deepPurple),
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

class JournalDetailPage extends StatefulWidget {
  final Map<String, dynamic> entry;
  const JournalDetailPage({super.key, required this.entry});

  @override
  State<JournalDetailPage> createState() => _JournalDetailPageState();
}

class _JournalDetailPageState extends State<JournalDetailPage> {
  // ignore: unused_field
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.entry["title"].isEmpty ? "Tanpa Judul" : widget.entry["title"]),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF3E5F5), Color(0xFFEDE7F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 8,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.entry["title"].isEmpty
                        ? "Tanpa Judul"
                        : widget.entry["title"],
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        widget.entry["content"],
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.deepPurple,
                            height: 1.5,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Dicatat pada ${DateTime.parse(widget.entry["time"]).day}/${DateTime.parse(widget.entry["time"]).month}/${DateTime.parse(widget.entry["time"]).year} "
                    "${DateTime.parse(widget.entry["time"]).hour}:${DateTime.parse(widget.entry["time"]).minute.toString().padLeft(2,'0')}",
                    style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.deepPurpleAccent),
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
