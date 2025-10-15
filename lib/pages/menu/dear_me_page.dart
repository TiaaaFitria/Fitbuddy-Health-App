import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DearMePage extends StatefulWidget {
  final String userId; 

  const DearMePage({super.key, required this.userId});

  @override
  State<DearMePage> createState() => _DearMePageState();
}

class _DearMePageState extends State<DearMePage> {
  final TextEditingController _controller = TextEditingController();
  List<String> _messages = [];

  String get messageKey => "dearme_${widget.userId}";

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(messageKey);
    if (data != null) {
      setState(() {
        _messages = List<String>.from(json.decode(data) as List);
      });
    }
  }

  Future<void> _saveMessage() async {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(text);
        _controller.clear();
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(messageKey, json.encode(_messages));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pesan berhasil disimpan.")),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dear Me"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tulis pesan untuk dirimu sendiri ✍️",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Dear future me...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _saveMessage,
                icon: const Icon(Icons.send),
                label: const Text("Kirim Pesan"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Pesan Sebelumnya:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _messages.isEmpty
                  ? const Center(
                      child: Text(
                        "Belum ada pesan. Tulis sesuatu untuk dirimu 😊",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const Icon(Icons.favorite, color: Colors.pink),
                            title: Text(
                              _messages[index],
                              style: const TextStyle(fontSize: 16),
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
