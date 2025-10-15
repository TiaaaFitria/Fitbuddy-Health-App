import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatefulWidget {
  final List<String> loggedUsers;

  const AdminPage({super.key, required this.loggedUsers});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController _feedbackController = TextEditingController();
  List<String> _loggedUsers = [];
  List<String> _feedbackList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLoggedUsers();
    _loadFeedbacks();
  }

  // ==================== USER LOGIN ====================
  Future<void> _loadLoggedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _loggedUsers = prefs.getStringList('logged_users') ?? widget.loggedUsers;
    });
  }

  Future<void> _saveLoggedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('logged_users', _loggedUsers);
  }

  void _logoutUser(int index) async {
    setState(() {
      _loggedUsers.removeAt(index);
    });
    _saveLoggedUsers();
  }

  void _logoutAllUsers() async {
    setState(() {
      _loggedUsers.clear();
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_users');
  }

  // ==================== FEEDBACK ====================
  Future<void> _loadFeedbacks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _feedbackList = prefs.getStringList('user_feedbacks') ?? [];
    });
  }

  Future<void> _saveFeedbacks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('user_feedbacks', _feedbackList);
  }
  void _removeFeedback(int index) {
    setState(() => _feedbackList.removeAt(index));
    _saveFeedbacks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Panel',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: colorScheme.onPrimary,
          labelColor: colorScheme.onPrimary,
          unselectedLabelColor: Colors.black54,
          tabs: const [
            Tab(icon: Icon(Icons.people_alt)), // tulisan dihapus
            Tab(icon: Icon(Icons.feedback_outlined)), // tulisan dihapus
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ================= USER LOGIN TAB =================
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: _loggedUsers.isEmpty
                      ? const Center(child: Text('Belum ada user login'))
                      : ListView.builder(
                          itemCount: _loggedUsers.length,
                          itemBuilder: (context, index) {
                            final username = _loggedUsers[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: colorScheme.primary,
                                  child: Text(
                                    username.isNotEmpty ? username[0].toUpperCase() : '?',
                                    style: TextStyle(color: colorScheme.onPrimary),
                                  ),
                                ),
                                title: Text(username),
                                trailing: IconButton(
                                  icon: Icon(Icons.logout, color: colorScheme.error),
                                  tooltip: 'Logout User',
                                  onPressed: () => _logoutUser(index),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                if (_loggedUsers.isNotEmpty)
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout Semua'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.error,
                        foregroundColor: colorScheme.onError,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _logoutAllUsers,
                    ),
                  ),
              ],
            ),
          ),

          // ================= FEEDBACK TAB =================
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Expanded(
                  child: _feedbackList.isEmpty
                      ? const Center(child: Text('Belum ada feedback'))
                      : ListView.builder(
                          itemCount: _feedbackList.length,
                          itemBuilder: (context, index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              child: ListTile(
                                title: Text(_feedbackList[index]),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: colorScheme.error),
                                  onPressed: () => _removeFeedback(index),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
