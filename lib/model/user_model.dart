class UserModel {
  // Private fields
  String _id;
  String _name;
  String _email;
  String? _password;
  String? _photoPath;
  String _role;

  UserModel({
    required String id,
    required String name,
    required String email,
    String? password,
    String? photoPath,
    String role = 'user', // default role
  })  : _id = id,
        _name = name,
        _email = email,
        _password = password,
        _photoPath = photoPath,
        _role = role;

  // =============================
  // Getters
  String get id => _id;
  String get name => _name;
  String get email => _email;
  String? get password => _password;
  String? get photoPath => _photoPath;
  String get role => _role;

  // =============================
  // Setters
  set id(String value) {
    if (value.isNotEmpty) _id = value;
  }

  set name(String value) {
    if (value.isNotEmpty) _name = value;
  }

  set email(String value) {
    if (value.contains('@')) _email = value;
  }

  set password(String? value) {
    if (value != null && value.length >= 6) {
      _password = value;
    }
  }

  set photoPath(String? value) {
    _photoPath = value;
  }

  set role(String value) {
    if (value == 'admin' || value == 'user') {
      _role = value;
    }
  }

  // =============================
  // Mapping
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name,
      'email': _email,
      'password': _password,
      'photoPath': _photoPath,
      'role': _role,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      photoPath: map['photoPath'],
      role: map['role'] ?? 'user',
    );
  }
}
