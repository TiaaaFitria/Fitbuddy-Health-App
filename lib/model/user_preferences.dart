import 'package:flutter_buddy/model/menu_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_model.dart';

class UserPreferences {
  static const String _keyId = "user_id";
  static const String _keyName = "user_name";
  static const String _keyEmail = "user_email";
  static const String _keyPassword = "user_password";
  static const String _keyPhotoPath = "user_photoPath";

  // Simpan semua data user
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyId, user.id);
    await prefs.setString(_keyName, user.name);
    await prefs.setString(_keyEmail, user.email);
    if (user.password != null) {
      await prefs.setString(_keyPassword, user.password!);
    }
    if (user.photoPath != null) {
      await prefs.setString(_keyPhotoPath, user.photoPath!);
    }
  }

  // Ambil semua data user
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
    );
  }

  // Hapus semua data user
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Setter individual
  static Future<void> setPhotoPath(String photoPath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPhotoPath, photoPath);
  }

  // Getter individual
  static Future<String?> getPhotoPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPhotoPath);
  }

  static Future getQuote() async {}

  static Future getMenus() async {}

  static Future<void> saveQuote(String editableQuote) async {}

  static Future<void> saveMenus(List<MenuItem> menuItems) async {}

  static Future<void> saveUserRole(String s) async {}
}
