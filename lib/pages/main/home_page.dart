
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/widgets/menu_grid.dart';
import '../../model/app_data.dart';
import '../../model/user_model.dart';
import '../../model/user_preferences.dart';
import '../../model/menu_item.dart';
import '../main/profile_page.dart';
import '../main/settings/settings_page.dart';
import '../admin/admin_page.dart';
import '../../widgets/gradient_background.dart';
import '../../model/app_theme.dart';

class HomePage extends StatefulWidget {
  final UserModel? initialUser;
  final UserModel user;
  const HomePage({super.key, this.initialUser, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  UserModel? currentUser;
  List<MenuItem> menuItems = [];
  List<String> loggedUsers = [];

  double waterProgress = 0.75;
  double sleepProgress = 0.85;
  double activityProgress = 0.6;

  @override
  void initState() {
    super.initState();
    loggedUsers = ["${widget.user.name} (${widget.user.email})"];

    if (widget.initialUser != null) {
      currentUser = widget.initialUser;
      _loadMenu();
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
    _loadMenu();
  }

  void _loadMenu() {
    final userId = currentUser?.id ?? "000";
    setState(() {
      menuItems = AppData().getMenuItems(userId);
    });
  }

  Future<void> _saveData() async {
    await UserPreferences.saveMenus(menuItems.cast<String>());
  }

  void _editMenu(int index, MenuItem item) async {
    final itemNow = menuItems[index];
    final titleController = TextEditingController(text: itemNow.title);
    final iconController = TextEditingController();

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Menu"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Nama Menu"),
            ),
            TextField(
              controller: iconController,
              decoration: const InputDecoration(
                  labelText: "Icon (home, settings, person, dll)"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, {
              "title": titleController.text,
              "icon": iconController.text,
            }),
            child: const Text("Simpan"),
          ),
        ],
      ),
    );

    final iconMap = {
      "home": Icons.home,
      "settings": Icons.settings,
      "favorite": Icons.favorite,
      "person": Icons.person,
      "star": Icons.star,
      "info": Icons.info,
      "help": Icons.help_outline,
    };

    if (result != null) {
      setState(() {
        menuItems[index] = itemNow.copyWith(
          title: result["title"] ?? itemNow.title,
          icon: iconMap[result["icon"]] ?? itemNow.icon,
        );
      });
      _saveData();
    }
  }

  void _deleteMenu(int index) {
    setState(() => menuItems.removeAt(index));
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String displayName = currentUser?.name ?? "Guest";
    final bool isAdmin = currentUser?.role == 'admin';
    final todayDate =
        DateFormat('EEEE, d MMMM y', 'id_ID').format(DateTime.now());

    final List<Widget> pages = [
      _buildBody(displayName, isDark, isAdmin, todayDate),
      const SettingsPage(),
      if (currentUser != null)
        ProfilePage(user: currentUser!, onProfileUpdated: (p1) {}),
      if (isAdmin) AdminPage(loggedUsers: loggedUsers),
    ];

    final navItems = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      const BottomNavigationBarItem(
          icon: Icon(Icons.settings), label: "Settings"),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      if (isAdmin)
        const BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings), label: "Admin"),
    ];

    return GradientBackground(
      applySafeArea: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            "FitBuddy Health",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          // **Foto profil di AppBar dihapus, kosongkan actions**
          actions: [],
        ),
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: AppTheme.accentYellow,
          unselectedItemColor: isDark ? Colors.white70 : Colors.white70,
          // ignore: deprecated_member_use
          backgroundColor: AppTheme.primaryBlue.withOpacity(0.9),
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          items: navItems,
        ),
      ),
    );
  }

  Widget _buildBody(
      String displayName, bool isDark, bool isAdmin, String todayDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todayDate,
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Hai, $displayName 👋",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 70,  // ukuran diperbesar dari 40 ke 60
                width: 70,
                child: Image.asset(
                  'assets/logo.png', // logo di kanan atas body, lebih besar
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF121212) : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTrackerCard(isDark),
                  const SizedBox(height: 25),
                  MenuGrid(
                    menuItems: menuItems,
                    isAdmin: isAdmin,
                    onEdit: _editMenu,
                    onDelete: _deleteMenu,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrackerCard(bool isDark) {
    final Color textColor = Colors.white;
    // ignore: deprecated_member_use
    final Color bg1 = AppTheme.lightBlue.withOpacity(0.8);
    // ignore: deprecated_member_use
    final Color bg2 = AppTheme.primaryBlue.withOpacity(0.9);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark ? const Color(0xFF1E1E1E) : null,
        gradient: isDark
            ? null
            : LinearGradient(
                colors: [bg1, bg2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
       boxShadow: [
  BoxShadow(
    // ignore: deprecated_member_use
    color: Colors.black.withOpacity(0.3),
    blurRadius: 10,
    offset: const Offset(0, 5),
  ),
],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "🎯 Jangan Lupa",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18, color: textColor),
            ),
            const SizedBox(height: 12),
            _buildProgressItem(Icons.local_drink, "Air Minum", waterProgress,
                "6/8 gelas", textColor),
            _buildProgressItem(Icons.bedtime, "Tidur Cukup", sleepProgress,
                "7/8 malam", textColor),
            _buildProgressItem(Icons.fitness_center, "Aktivitas Fisik",
                activityProgress, "4/7 hari", textColor),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(
      IconData icon, String title, double progress, String label, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: textColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      TextStyle(fontWeight: FontWeight.w500, color: textColor),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white24,
                    color: AppTheme.accentYellow,
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(label,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        ],
      ),
    );
  }
}
