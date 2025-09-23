import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/model/user_model.dart';
import '/model/user_preferences.dart'; 

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

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);

    if (widget.user.photoPath != null) {
      _imageFile = File(widget.user.photoPath!);
    }

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
        widget.user.photoPath = picked.path; 
      });
      _animationController.forward().then((_) => _animationController.reverse());
    }
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() async {
    setState(() {
      widget.user.name = _nameController.text;
      widget.user.email = _emailController.text;
    });

    widget.onProfileUpdated(widget.user);

    await UserPreferences.saveUser(widget.user);

    setState(() {
      _isEditing = false;
    });

    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated'),
        backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avatar = _imageFile != null
        ? ScaleTransition(
            scale: _scaleAnimation,
            child: CircleAvatar(
              radius: 60,
              backgroundImage: FileImage(_imageFile!),
            ),
          )
        : ScaleTransition(
            scale: _scaleAnimation,
            child: const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
          );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadowColor: Colors.teal.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Avatar
              GestureDetector(
                onTap: _isEditing ? _pickImage : null,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    avatar,
                    if (_isEditing)
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.teal,
                        child: Icon(Icons.edit, size: 18, color: Colors.white),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

      
              TextFormField(
                controller: _nameController,
                enabled: _isEditing,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.teal,
                      width: 1.2,
                    ),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              
              TextFormField(
                controller: _emailController,
                enabled: _isEditing,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.teal,
                      width: 1.2,
                    ),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 30),

              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isEditing ? _saveProfile : _toggleEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _isEditing ? "Save Profile" : "Edit Profile",
                    style: const TextStyle(
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
    );
  }
}
