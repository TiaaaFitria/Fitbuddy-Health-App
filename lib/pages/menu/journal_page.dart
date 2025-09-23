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
  final TextEditingController _controller = TextEditingController();
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
        _journalEntries = List<Map<String, dynamic>>.from(json.decode(data) as List);
      });
    }
  }

  Future<void> _saveJournalData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(userKey, json.encode(_journalEntries));
  }

  void _saveJournal() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _journalEntries.insert(0, {
        "text": _controller.text.trim(),
        "time": DateTime.now().toIso8601String(),
      });
      _controller.clear();
    });

    _saveJournalData();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Jurnal berhasil disimpan!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Journal"),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE3F2FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tulis jurnal harianmu:",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                ],
              ),
              child: TextField(
                controller: _controller,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Hari ini aku merasa...",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: _saveJournal,
                icon: const Icon(Icons.save),
                label: const Text(
                  "Simpan Jurnal",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Riwayat Jurnal:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _journalEntries.isEmpty
                  ? const Center(child: Text("Belum ada jurnal yang ditulis."))
                  : ListView.builder(
                      itemCount: _journalEntries.length,
                      itemBuilder: (context, index) {
                        final entry = _journalEntries[index];
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            leading: const Icon(Icons.book, color: Colors.purple),
                            title: Text(
                              entry["text"],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "Dicatat pada ${entry["time"].substring(0, 16)}",
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
