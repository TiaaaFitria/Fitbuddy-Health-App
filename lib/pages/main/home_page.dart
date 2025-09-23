import 'package:flutter/material.dart';
import '../../model/app_data.dart';
import 'profile_page.dart';
import 'settings/settings_page.dart';
import '../../model/user_model.dart';
import '../../model/user_preferences.dart'; 

class HomePage extends StatefulWidget {
  final UserModel? initialUser;

  const HomePage({super.key, this.initialUser, required UserModel user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    if (widget.initialUser != null) {
      currentUser = widget.initialUser;
    } else {
      _loadUserFromPreferences();
    }
  }

  Future<void> _loadUserFromPreferences() async {
    UserModel? savedUser = await UserPreferences.getUser();
    setState(() {
      currentUser = savedUser ??
          UserModel(
            id: '000',
            name: 'Guest',
            email: 'guest@example.com',
            role: 'user',
          );
    });
  }

  void _updateUser(UserModel updatedUser) async {
    setState(() {
      currentUser = updatedUser;
    });

    await UserPreferences.saveUser(updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    final String displayName =
        currentUser?.name ?? currentUser?.email ?? "Guest";

    final bool isAdmin = currentUser?.role == 'admin';

    final menuItems = AppData().menuItems; // Tetap sama untuk admin/user

    final List<Widget> pages = [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, $displayName 👋",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: item.color.withOpacity(0.2),
                        child: Icon(item.icon, color: item.color),
                      ),
                      title: Text(
                        item.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => item.page),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      const SettingsPage(),
      if (currentUser != null)
        ProfilePage(user: currentUser!, onProfileUpdated: _updateUser),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(isAdmin ? "Admin Panel" : "FitBuddy"),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
