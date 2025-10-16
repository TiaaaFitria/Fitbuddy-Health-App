<<<<<<< HEAD
import 'package:shared_preferences/shared_preferences.dart';
import 'user_model.dart';

class UserPreferences {
  static const String _keyId = "user_id";
  static const String _keyName = "user_name";
  static const String _keyEmail = "user_email";
  static const String _keyPassword = "user_password";
  static const String _keyPhotoPath = "user_photoPath";
  static const String _keyRole = "user_role";

  static const String _keyMenus = "app_menus";
  static const String _keyFeedbacks = "user_feedbacks";
  static const String _keyLoggedUsers = "logged_users";

  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyId, user.id);
    await prefs.setString(_keyName, user.name);
    await prefs.setString(_keyEmail, user.email);
    await prefs.setString(_keyRole, user.role);
    if (user.password != null) {
      await prefs.setString(_keyPassword, user.password!);
    }
    if (user.photoPath != null) {
      await prefs.setString(_keyPhotoPath, user.photoPath!);
    }

    List<String> users = prefs.getStringList(_keyLoggedUsers) ?? [];
    if (!users.contains(user.email)) {
      users.add(user.email);
      await prefs.setStringList(_keyLoggedUsers, users);
    }
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_keyId);
    final name = prefs.getString(_keyName);
    final email = prefs.getString(_keyEmail);

    if (id == null || name == null || email == null) {
      return null;
    }

    return UserModel(
      id: id,
      name: name,
      email: email,
      password: prefs.getString(_keyPassword),
      photoPath: prefs.getString(_keyPhotoPath),
      role: prefs.getString(_keyRole) ?? 'user',
    );
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyId);
    await prefs.remove(_keyName);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyPassword);
    await prefs.remove(_keyPhotoPath);
    await prefs.remove(_keyRole);
  }

  static Future<void> setPhotoPath(String photoPath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPhotoPath, photoPath);
  }

  static Future<String?> getPhotoPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPhotoPath);
  }

  static Future<void> saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRole, role);
  }

  static Future<void> saveMenus(List<String> menus) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyMenus, menus);
  }

  static Future<List<String>> getMenus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyMenus) ?? ["Dashboard", "Fitness Tracker", "Meal Plan"];
  }

  static Future<void> saveFeedbacks(List<String> feedbacks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyFeedbacks, feedbacks);
  }

  static Future<List<String>> getFeedbacks() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyFeedbacks) ?? [];
  }

  static Future<void> saveLoggedUsers(List<String> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyLoggedUsers, users);
  }

  static Future<List<String>> getLoggedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyLoggedUsers) ?? [];
  }

  static Future<void> addLoggedUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList(_keyLoggedUsers) ?? [];
    if (!users.contains(email)) {
      users.add(email);
      await prefs.setStringList(_keyLoggedUsers, users);
    }
  }

  static Future<void> removeLoggedUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList(_keyLoggedUsers) ?? [];
    users.remove(email);
    await prefs.setStringList(_keyLoggedUsers, users);
  }

  static Future<void> clearAllLoggedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoggedUsers);
  }

  static Future<void> saveQuote(String editableQuote) async { 
  }
}
=======
import 'package:shared_preferences/shared_preferences.dart';
import 'user_model.dart';

class UserPreferences {
  static const String _keyId = "user_id";
  static const String _keyName = "user_name";
  static const String _keyEmail = "user_email";
  static const String _keyPassword = "user_password";
  static const String _keyPhotoPath = "user_photoPath";
  static const String _keyRole = "user_role";

  static const String _keyMenus = "app_menus";
  static const String _keyFeedbacks = "user_feedbacks";
  static const String _keyLoggedUsers = "logged_users";

  // ======================================================
  // 🔹 BAGIAN UTAMA: Data User
  // ======================================================

  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyId, user.id);
    await prefs.setString(_keyName, user.name);
    await prefs.setString(_keyEmail, user.email);
    await prefs.setString(_keyRole, user.role);
    if (user.password != null) {
      await prefs.setString(_keyPassword, user.password!);
    }
    if (user.photoPath != null) {
      await prefs.setString(_keyPhotoPath, user.photoPath!);
    }

    // 🆕 Tambahkan user ke daftar logged_users
    List<String> users = prefs.getStringList(_keyLoggedUsers) ?? [];
    if (!users.contains(user.email)) {
      users.add(user.email);
      await prefs.setStringList(_keyLoggedUsers, users);
    }
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_keyId);
    final name = prefs.getString(_keyName);
    final email = prefs.getString(_keyEmail);

    if (id == null || name == null || email == null) {
      return null;
    }

    return UserModel(
      id: id,
      name: name,
      email: email,
      password: prefs.getString(_keyPassword),
      photoPath: prefs.getString(_keyPhotoPath),
      role: prefs.getString(_keyRole) ?? 'user',
    );
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyId);
    await prefs.remove(_keyName);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyPassword);
    await prefs.remove(_keyPhotoPath);
    await prefs.remove(_keyRole);
  }

  static Future<void> setPhotoPath(String photoPath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPhotoPath, photoPath);
  }

  static Future<String?> getPhotoPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPhotoPath);
  }

  static Future<void> saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRole, role);
  }

  // ======================================================
  // 🔹 BAGIAN MENU & FEEDBACK
  // ======================================================

  static Future<void> saveMenus(List<String> menus) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyMenus, menus);
  }

  static Future<List<String>> getMenus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyMenus) ?? ["Dashboard", "Fitness Tracker", "Meal Plan"];
  }

  static Future<void> saveFeedbacks(List<String> feedbacks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyFeedbacks, feedbacks);
  }

  static Future<List<String>> getFeedbacks() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyFeedbacks) ?? [];
  }

  // ======================================================
  // 🔹 BAGIAN USER LOGIN MANAGEMENT
  // ======================================================

  /// Simpan daftar user yang sedang login
  static Future<void> saveLoggedUsers(List<String> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyLoggedUsers, users);
  }

  /// Ambil daftar user yang sedang login
  static Future<List<String>> getLoggedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyLoggedUsers) ?? [];
  }

  /// Tambahkan 1 user ke daftar login
  static Future<void> addLoggedUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList(_keyLoggedUsers) ?? [];
    if (!users.contains(email)) {
      users.add(email);
      await prefs.setStringList(_keyLoggedUsers, users);
    }
  }

  /// Logout 1 user berdasarkan index atau email
  static Future<void> removeLoggedUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList(_keyLoggedUsers) ?? [];
    users.remove(email);
    await prefs.setStringList(_keyLoggedUsers, users);
  }

  /// Logout semua user sekaligus
  static Future<void> clearAllLoggedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoggedUsers);
  }

  // ======================================================
  // 🔹 Fungsi Tambahan Kosong (Placeholder)
  // ======================================================

  static Future<void> saveQuote(String editableQuote) async {
    // Placeholder: bisa diisi nanti kalau dibutuhkan
  }
}
>>>>>>> bc4ed19293464f12c16099e9a02ca1f1ebdf90f4
