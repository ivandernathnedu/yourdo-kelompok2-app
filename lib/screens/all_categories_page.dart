import 'package:flutter/material.dart';

import '../data/quest_repository.dart';
import '../models/quest_category.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import '../widgets/glyph_icon.dart';
import 'category_quests_page.dart';

class AllCategoriesPage extends StatefulWidget {
  const AllCategoriesPage({
    super.key,
    required this.repository,
    this.isPicker = false,
  });

  final QuestRepository repository;
  final bool isPicker;

  @override
  State<AllCategoriesPage> createState() => _AllCategoriesPageState();
}

class _AllCategoriesPageState extends State<AllCategoriesPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCategory(BuildContext context, QuestCategory category) async {
    final navigator = Navigator.of(context);
    final result = await navigator.push(
      MaterialPageRoute(
        builder: (_) => CategoryQuestsPage(
          category: category,
          repository: widget.repository,
          isPicker: widget.isPicker,
        ),
      ),
    );

    if (!mounted) return;
    if (result != null) {
      navigator.pop(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final allCategories = widget.repository.categories;
    final filteredCategories = _searchQuery.isEmpty
        ? allCategories
        : allCategories.where((c) {
            return c.name.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.pagePadding,
            vertical: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Tombol Back Bulat (Sesuai Gambar 5) ───
              Material(
                color: AppColors.backButton,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.of(context).maybePop(),
                  child: const SizedBox(
                    width: AppDimens.backButtonSize,
                    height: AppDimens.backButtonSize,
                    child: Icon(
                      Icons.chevron_left_rounded,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ─── Search Bar: "Find your adventure" (Sesuai Gambar 5) ───
              Container(
                decoration: BoxDecoration(
                  color: AppColors.section,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.textSecondary,
                    ),
                    hintText: 'Find your adventure',
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.6),
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ─── Daftar Kategori (Cards Sesuai Gambar 5) ───
              Expanded(
                child: ListView.separated(
                  itemCount: filteredCategories.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final category = filteredCategories[index];

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _openCategory(context, category),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.section,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Row(
                            children: [
                              // Kotak Ikon Kategori
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: category.color,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: GlyphIcon(
                                    glyph: category.glyph,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Nama Kategori
                              Expanded(
                                child: Text(
                                  category.name.replaceAll('\n', ' '),
                                  style: AppTextStyles.sectionTitle.copyWith(
                                    fontSize: 15,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              // Ikon Titik Tiga (...) sesuai Gambar 5
                              const Icon(
                                Icons.more_horiz_rounded,
                                color: AppColors.textSecondary,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
