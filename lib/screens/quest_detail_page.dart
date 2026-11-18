import 'package:flutter/material.dart';

import '../models/quest.dart';
import '../models/quest_category.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import '../widgets/glyph_icon.dart';
import 'create_post_dialog.dart';

class QuestDetailPage extends StatelessWidget {
  const QuestDetailPage({
    super.key,
    required this.quest,
    required this.category,
  });

  final Quest quest;
  final QuestCategory category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          category.name.replaceAll('\n', ' '),
          style: AppTextStyles.seeMore,
        ),
      ),
      // Tombol Plus (+) di halaman detail sesuai Gambar 3
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.randomizeGlow,
        foregroundColor: Colors.black,
        tooltip: 'Upload Progress Quest',
        onPressed: () {
          CreatePostDialog.show(
            context,
            initialQuest: quest,
            initialCategory: category,
          );
        },
        child: const Icon(Icons.add_rounded, size: 30),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimens.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: category.color,
                borderRadius: BorderRadius.circular(AppDimens.categoryRadius),
              ),
              alignment: Alignment.center,
              child: GlyphIcon(
                glyph: quest.glyph,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(quest.title, style: AppTextStyles.pageInstruction),
            const SizedBox(height: 8),
            Text(quest.achievementLabel, style: AppTextStyles.questLabel),
            const SizedBox(height: 20),
            Text(quest.description, style: AppTextStyles.detailBody),
          ],
        ),
      ),
    );
  }
}
