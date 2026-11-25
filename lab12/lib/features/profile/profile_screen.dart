import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _prefs = SharedPreferencesAsync();
  final _picker = ImagePicker();

  String? _photoPath;

  @override
  void initState() {
    super.initState();
    unawaited(_loadPhoto());
  }

  Future<void> _loadPhoto() async {
    final path = await _prefs.getString('avatarPath');

    if (path == null) return;

    final exists = await File(path).exists();

    if (!mounted || !exists) return;

    setState(() {
      _photoPath = path;
    });
  }

  void _message(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pick(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      imageQuality: 85,
    );

    if (picked == null) return;
    if (!mounted) return;

    final directory = await getApplicationDocumentsDirectory();

    final saved = await File(picked.path).copy('${directory.path}/avatar.jpg');

    await FileImage(saved).evict();

    await _prefs.setString('avatarPath', saved.path);

    if (!mounted) return;

    setState(() {
      _photoPath = saved.path;
    });
  }

  Future<void> _permissionDialog() async {
    final openSettings = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Camera permission required'),
        content: const Text(
          'Camera access is permanently denied. '
          'Please enable camera permission '
          'in your app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            child: const Text('Open settings'),
          ),
        ],
      ),
    );

    if (openSettings ?? false) {
      await openAppSettings();
    }
  }

  Future<void> _takePhoto() async {
    final status = await Permission.camera.request();

    if (!mounted) return;

    switch (status) {
      case PermissionStatus.granted:
        await _pick(ImageSource.camera);
        break;

      case PermissionStatus.denied:
        _message(
          'Camera permission denied. '
          'You can still choose a gallery photo.',
        );
        break;

      case PermissionStatus.permanentlyDenied:
        await _permissionDialog();
        break;

      case PermissionStatus.restricted:
        _message('Camera access is restricted by the system.');
        break;

      case PermissionStatus.limited:
        _message('Camera access is limited.');
        break;

      case PermissionStatus.provisional:
        _message('Camera access is provisional.');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final path = _photoPath;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 65,
              backgroundImage: path == null ? null : FileImage(File(path)),
              child: path == null
                  ? const Text('M', style: TextStyle(fontSize: 40))
                  : null,
            ),
            const SizedBox(height: 24),
            const Text('My profile', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () async {
                await _pick(ImageSource.gallery);
              },
              icon: const Icon(Icons.photo_library),
              label: const Text('Choose photo'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _takePhoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take photo'),
            ),
          ],
        ),
      ),
    );
  }
}
