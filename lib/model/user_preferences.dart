import 'package:shared_preferences/shared_preferences.dart';
import 'user_model.dart';

class UserPreferences {
  static const String _keyId = "user_id";
  static const String _keyName = "user_name";
  static const String _keyEmail = "user_email";
  static const String _keyPassword = "user_password";
  static const String _keyPhotoPath = "user_photoPath";

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

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    final id = prefs.getString(_keyId);
    final name = prefs.getString(_keyName);
    final email = prefs.getString(_keyEmail);

    if (id == null || name == null || email == null) {
      return null; // belum ada data user
    }

    return UserModel(
      id: id,
      name: name,
      email: email,
      password: prefs.getString(_keyPassword),
      photoPath: prefs.getString(_keyPhotoPath),
    );
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyId);
    await prefs.remove(_keyName);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyPassword);
    await prefs.remove(_keyPhotoPath);
  }

  static Future<void> setId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyId, id);
  }

  static Future<void> setName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
  }

  static Future<void> setEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
  }

  static Future<void> setPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPassword, password);
  }

  static Future<void> setPhotoPath(String photoPath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPhotoPath, photoPath);
  }

  static Future<String?> getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyId);
  }

  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  static Future<String?> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPassword);
  }

  static Future<String?> getPhotoPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPhotoPath);
  }
}
