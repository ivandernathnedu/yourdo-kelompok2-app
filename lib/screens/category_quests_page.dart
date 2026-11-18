import 'package:flutter/material.dart';

import '../data/quest_repository.dart';
import '../models/quest.dart';
import '../models/quest_category.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import '../widgets/quest_card.dart';
import 'quest_detail_page.dart';

class CategoryQuestsPage extends StatelessWidget {
  const CategoryQuestsPage({
    super.key,
    required this.category,
    required this.repository,
    this.isPicker = false,
  });

  final QuestCategory category;
  final QuestRepository repository;
  final bool isPicker;

  void _onSelectQuest(BuildContext context, Quest quest) {
    if (isPicker) {
      // Jika dalam mode memilih quest untuk pop-up post, kembalikan data quest & category
      Navigator.of(context).pop({'quest': quest, 'category': category});
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => QuestDetailPage(quest: quest, category: category),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final quests = repository.questsByCategory(category.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          category.name.replaceAll('\n', ' '),
          style: AppTextStyles.sectionTitle,
        ),
      ),
      body: quests.isEmpty
          ? const Center(
              child: Text(
                'No quests in this category yet',
                style: AppTextStyles.groupDescription,
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppDimens.pagePadding),
              itemCount: quests.length,
              separatorBuilder: (_, index) =>
                  const SizedBox(height: AppDimens.itemGap),
              itemBuilder: (context, index) {
                final quest = quests[index];
                return QuestCard(
                  quest: quest,
                  category: category,
                  onTap: () => _onSelectQuest(context, quest),
                );
              },
            ),
    );
  }
}
