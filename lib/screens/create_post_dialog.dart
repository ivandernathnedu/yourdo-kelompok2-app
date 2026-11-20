import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/mock_quest_data.dart';
import '../data/quest_repository.dart';
import '../models/quest.dart';
import '../models/quest_category.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/post_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/glyph_icon.dart';
import '../widgets/profile_avatar.dart';
import 'all_categories_page.dart';

class CreatePostDialog extends StatefulWidget {
  const CreatePostDialog({
    super.key,
    this.initialQuest,
    this.initialCategory,
  });

  final Quest? initialQuest;
  final QuestCategory? initialCategory;

  /// Menampilkan pop-up full-screen dialog 
  static Future<bool?> show(
    BuildContext context, {
    Quest? initialQuest,
    QuestCategory? initialCategory,
  }) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Create Post',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => CreatePostDialog(
        initialQuest: initialQuest,
        initialCategory: initialCategory,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic)),
          child: child,
        );
      },
    );
  }

  @override
  State<CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  final _imagePicker = ImagePicker();
  final _postService = PostService();

  QuestCategory? _selectedCategory;
  Quest? _selectedQuest;
  final List<File> _selectedImages = [];
  bool _isPosting = false;

  @override
  void initState() {
    super.initState();
    _selectedQuest = widget.initialQuest;
    _selectedCategory = widget.initialCategory ??
        (widget.initialQuest != null
            ? const QuestRepository().categoryById(widget.initialQuest!.categoryId)
            : MockQuestData.categories.first);

    _titleController = TextEditingController(
      text: widget.initialQuest?.title ?? '',
    );
    _descController = TextEditingController(
      text: widget.initialQuest?.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // ─── Buka Halaman Kategori (Gambar 5) saat Ikon Panah Bawah Ditekan ───
  Future<void> _openCategoryPickerPage() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => const AllCategoriesPage(
          repository: QuestRepository(),
          isPicker: true,
        ),
      ),
    );

    if (result != null && mounted) {
      final selectedQuest = result['quest'] as Quest?;
      final selectedCategory = result['category'] as QuestCategory?;

      setState(() {
        if (selectedCategory != null) {
          _selectedCategory = selectedCategory;
        }
        if (selectedQuest != null) {
          _selectedQuest = selectedQuest;
          _titleController.text = selectedQuest.title;
          _descController.text = selectedQuest.description;
        }
      });
    }
  }

  Future<void> _pickImage() async {
    final picked = await _imagePicker.pickMultiImage(
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 70,
    );
    if (picked.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(picked.map((xFile) => File(xFile.path)));
      });
    }
  }

  Future<void> _pickCamera() async {
    final picked = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 70,
    );
    if (picked != null) {
      setState(() {
        _selectedImages.add(File(picked.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _submitPost() async {
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul quest tidak boleh kosong')),
      );
      return;
    }

    setState(() => _isPosting = true);

    final category = _selectedCategory ?? MockQuestData.categories.first;

    try {
      await _postService.createPost(
        title: title,
        description: desc,
        categoryLabel: _selectedQuest?.achievementLabel ??
            category.name.replaceAll('\n', ' '),
        categoryColor: category.color,
        categoryIcon: _categoryToIcon(category),
        imageFiles: _selectedImages,
      );

      if (!mounted) return;
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Postingan berhasil')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isPosting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal upload post: $e')),
      );
    }
  }

  IconData _categoryToIcon(QuestCategory category) {
    const categoryIcons = {
      'media_entertainment': Icons.movie_rounded,
      'learning_discovery': Icons.auto_stories_rounded,
      'health_fitness': Icons.fitness_center_rounded,
      'arts_creativity': Icons.palette_rounded,
      'outdoors_adventure': Icons.terrain_rounded,
      'social_experiences': Icons.people_rounded,
      'foods_lifestyle': Icons.restaurant_rounded,
    };
    return categoryIcons[category.id] ?? Icons.explore_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final category = _selectedCategory ?? MockQuestData.categories.first;
    final badgeLabel = _selectedQuest?.achievementLabel ??
        category.name.replaceAll('\n', ' ').toUpperCase();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Top Bar: Tombol Close (X) di kiri atas (Sesuai Gambar 4) ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary, size: 28),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── Category Row dengan Avatar, Badge & Ikon Panah Bawah (Gambar 4) ───
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Avatar Pengguna Aktif
                        ValueListenableBuilder<UserProfile>(
                          valueListenable: AuthService.profileNotifier,
                          builder: (context, profile, _) {
                            return ProfileAvatar(
                              size: 48,
                              photoUrl: profile.photoUrl,
                            );
                          },
                        ),
                        const SizedBox(width: 14),
                        // Label Category & Badge Achievement
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Category',
                              style: AppTextStyles.seeMore.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                // Badge Achievement (Contoh: "MOVIE WATCHER")
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: category.color,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GlyphIcon(
                                        glyph: category.glyph,
                                        color: category.color.computeLuminance() > 0.5
                                            ? Colors.black
                                            : Colors.white,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        badgeLabel,
                                        style: AppTextStyles.badgeLabel.copyWith(
                                          color: category.color.computeLuminance() > 0.5
                                              ? Colors.black
                                              : Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Ikon Panah ke Bawah (Chevron Down) di samping badge (Sesuai Gambar 4)
                                GestureDetector(
                                  onTap: _openCategoryPickerPage,
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      color: AppColors.section,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppColors.divider),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: AppColors.textSecondary,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ─── Label Title (Sesuai Gambar 4) ───
                    Text(
                      'Title:',
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // ─── Input What's your quest? (Sesuai Gambar 4) ───
                    TextField(
                      controller: _titleController,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration: InputDecoration(
                        hintText: "What's your quest?",
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary.withValues(alpha: 0.5),
                          fontSize: 15,
                        ),
                        filled: true,
                        fillColor: AppColors.section,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ─── Input Describe your quest (Sesuai Gambar 4) ───
                    TextField(
                      controller: _descController,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Describe your quest',
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary.withValues(alpha: 0.5),
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: AppColors.section,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ─── Preview Foto Terpilih ───
                    if (_selectedImages.isNotEmpty) ...[
                      SizedBox(
                        height: 110,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedImages.length,
                          separatorBuilder: (_, index) => const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    _selectedImages[index],
                                    width: 110,
                                    height: 110,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () => _removeImage(index),
                                    child: Container(
                                      width: 22,
                                      height: 22,
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),

            // ─── Bottom Bar: Ikon Galeri & Tombol Post (Sesuai Gambar 4) ───
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.divider),
                ),
              ),
              child: Row(
                children: [
                  // Ikon Galeri Gambar
                  IconButton(
                    icon: const Icon(
                      Icons.photo_library_outlined,
                      color: AppColors.textSecondary,
                      size: 28,
                    ),
                    tooltip: 'Pilih Foto dari Galeri',
                    onPressed: _isPosting ? null : _pickImage,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.textSecondary,
                      size: 28,
                    ),
                    tooltip: 'Ambil Foto dari Kamera',
                    onPressed: _isPosting ? null : _pickCamera,
                  ),
                  const Spacer(),
                  // Tombol "Post"
                  SizedBox(
                    width: 100,
                    height: 42,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.questButton,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _isPosting ? null : _submitPost,
                      child: _isPosting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Post',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
