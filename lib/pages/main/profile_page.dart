// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/model/user_model.dart';
import '/model/user_preferences.dart';
import '/model/app_theme.dart'; // 🌈 pastikan AppTheme ada

class ProfilePage extends StatefulWidget {
  final UserModel user;
  final Function(UserModel) onProfileUpdated;

  const ProfilePage({
    super.key,
    required this.user,
    required this.onProfileUpdated,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  bool _isEditing = false;
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  Uint8List? _imageBytes;

  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);

    if (widget.user.photoPath != null) {
      if (kIsWeb) {
        try {
          _imageBytes = base64Decode(widget.user.photoPath!);
        } catch (_) {}
      } else {
        _imageFile = File(widget.user.photoPath!);
      }
    }

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnim = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source);
      if (picked != null) {
        if (kIsWeb) {
          final bytes = await picked.readAsBytes();
          setState(() {
            _imageBytes = bytes;
            widget.user.photoPath = base64Encode(bytes);
          });
        } else {
          setState(() {
            _imageFile = File(picked.path);
            widget.user.photoPath = picked.path;
          });
        }
        await UserPreferences.saveUser(widget.user);
        _animController.forward().then((_) => _animController.reverse());
      }
    } catch (e) {
      debugPrint("Gagal memilih gambar: $e");
    }
  }

  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppTheme.primaryBlue),
                title: const Text('Pilih dari Galeri'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppTheme.primaryBlue),
                title: const Text('Gunakan Kamera'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
                title: const Text('Hapus Foto Profil'),
                onTap: () async {
                  Navigator.pop(context);
                  setState(() {
                    _imageFile = null;
                    _imageBytes = null;
                    widget.user.photoPath = null;
                  });
                  await UserPreferences.saveUser(widget.user);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Foto profil dihapus'),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleEdit() => setState(() => _isEditing = !_isEditing);

  void _saveProfile() async {
    setState(() {
      widget.user.name = _nameController.text;
      widget.user.email = _emailController.text;
    });

    widget.onProfileUpdated(widget.user);
    await UserPreferences.saveUser(widget.user);

    setState(() => _isEditing = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil berhasil diperbarui 💙'),
        backgroundColor: AppTheme.primaryBlue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avatar = _imageBytes != null
        ? ScaleTransition(
            scale: _scaleAnim,
            child: CircleAvatar(radius: 55, backgroundImage: MemoryImage(_imageBytes!)),
          )
        : _imageFile != null
            ? ScaleTransition(
                scale: _scaleAnim,
                child: CircleAvatar(radius: 55, backgroundImage: FileImage(_imageFile!)),
              )
            : ScaleTransition(
                scale: _scaleAnim,
                child: const CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, size: 55, color: Colors.white),
                ),
              );

    // **DIHAPUS** Widget appBarAvatar yang sebelumnya dipakai di actions AppBar

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // *** Bagian actions yang berisi foto profil dihapus ***
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.lightBlue, AppTheme.primaryBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutBack,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: _isEditing ? _showImageSourceDialog : null,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        avatar,
                        if (_isEditing)
                          const CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.edit, size: 18, color: AppTheme.primaryBlue),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  TextFormField(
                    controller: _nameController,
                    enabled: _isEditing,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Nama',
                      labelStyle: TextStyle(color: Colors.white70),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _emailController,
                    enabled: _isEditing,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white70),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isEditing ? _saveProfile : _toggleEdit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        shadowColor: Colors.black26,
                        elevation: 4,
                      ),
                      child: Text(
                        _isEditing ? "Simpan Profil" : "Edit Profil",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
