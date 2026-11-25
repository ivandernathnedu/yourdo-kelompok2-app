import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/auth_service.dart';
import '../services/post_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'profile_avatar.dart';

class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({
    super.key,
    this.authService,
    this.postService,
  });

  final AuthService? authService;
  final PostService? postService;

  static Future<bool?> show(
    BuildContext context, {
    AuthService? authService,
    PostService? postService,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => EditProfileDialog(
        authService: authService,
        postService: postService,
      ),
    );
  }

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late final AuthService _authService;
  late final PostService _postService;
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  final _imagePicker = ImagePicker();

  String? _photoUrl;
  String? _nameError;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _authService = widget.authService ?? AuthService();
    _postService = widget.postService ?? PostService();
    final currentProfile = _authService.currentProfile;
    _nameController = TextEditingController(text: currentProfile.displayName);
    _bioController = TextEditingController(text: currentProfile.bio);
    _photoUrl = currentProfile.photoUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 75,
      );
      if (picked == null) return;

      final bytes = await picked.readAsBytes();
      if (!mounted) return;

      setState(() {
        _photoUrl = 'data:image/jpeg;base64,${base64Encode(bytes)}';
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengambil foto profil')),
      );
    }
  }

  Future<void> _save() async {
    if (_isSaving) return;

    final trimmedName = _nameController.text.trim();
    final trimmedBio = _bioController.text.trim();
    if (trimmedName.isEmpty) {
      setState(() => _nameError = 'Nama akun tidak boleh kosong');
      return;
    }

    setState(() {
      _nameError = null;
      _isSaving = true;
    });

    final messenger = ScaffoldMessenger.of(context);
    await _authService.updateProfile(
      displayName: trimmedName,
      bio: trimmedBio,
      photoUrl: _photoUrl,
    );
    await _postService.updateCurrentUserPostsProfile(
      displayName: trimmedName,
      photoUrl: _photoUrl,
    );

    if (!mounted) return;
    Navigator.of(context).pop(true);
    messenger.showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.section,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text('Edit Profile', style: AppTextStyles.sectionTitle),
                const Spacer(),
                IconButton(
                  onPressed:
                      _isSaving ? null : () => Navigator.of(context).pop(false),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: _isSaving ? null : () => _pickPhoto(ImageSource.gallery),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ProfileAvatar(size: 88, photoUrl: _photoUrl),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.questButton,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.section,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed:
                      _isSaving ? null : () => _pickPhoto(ImageSource.gallery),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.divider),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.photo_library_outlined, size: 18),
                  label: const Text('Galeri'),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed:
                      _isSaving ? null : () => _pickPhoto(ImageSource.camera),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.divider),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.camera_alt_outlined, size: 18),
                  label: const Text('Kamera'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Nama Akun',
              style: AppTextStyles.postName.copyWith(fontSize: 13),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              enabled: !_isSaving,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Masukkan nama akun',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.6),
                ),
                errorText: _nameError,
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.questButton),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Bio',
              style: AppTextStyles.postName.copyWith(fontSize: 13),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _bioController,
              enabled: !_isSaving,
              maxLines: 3,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Tulis bio singkat...',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.6),
                ),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.questButton),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed:
                      _isSaving ? null : () => Navigator.of(context).pop(false),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.questButton,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Simpan',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
