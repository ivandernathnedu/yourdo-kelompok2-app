import 'package:flutter/material.dart';

import '../data/quest_repository.dart';
import '../models/quest.dart';
import '../models/quest_category.dart';
import '../services/quest_randomizer.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../widgets/browse_categories_section.dart';
import '../widgets/discover_section.dart';
import '../widgets/randomize_quest_button.dart';
import '../widgets/recommended_section.dart';
import 'all_categories_page.dart';
import 'category_quests_page.dart';
import 'quest_detail_page.dart';

class QuestPage extends StatelessWidget {
  const QuestPage({
    super.key,
    required this.repository,
    required this.randomizer,
  });

  final QuestRepository repository;
  final QuestRandomizer randomizer;

  void _openQuest(BuildContext context, Quest quest) {
    final category = repository.categoryById(quest.categoryId);
    if (category == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuestDetailPage(quest: quest, category: category),
      ),
    );
  }

  void _openCategory(BuildContext context, QuestCategory category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategoryQuestsPage(
          category: category,
          repository: repository,
        ),
      ),
    );
  }

  void _openAllCategories(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AllCategoriesPage(repository: repository),
      ),
    );
  }

  void _randomize(BuildContext context) {
    final quest = randomizer.pick(repository.quests);
    _openQuest(context, quest);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.pagePadding,
            8,
            AppDimens.pagePadding,
            AppDimens.navHeight + AppDimens.navBottomInset + 32,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: _BackCircleButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
              const SizedBox(height: 8),
              RandomizeQuestButton(onPressed: () => _randomize(context)),
              const SizedBox(height: 28),
              BrowseCategoriesSection(
                categories: repository.categories,
                onCategoryTap: (category) => _openCategory(context, category),
                onSeeMore: () => _openAllCategories(context),
              ),
              const SizedBox(height: AppDimens.sectionGap),
              RecommendedSection(
                repository: repository,
                onQuestTap: (quest) => _openQuest(context, quest),
              ),
              const SizedBox(height: AppDimens.sectionGap),
              DiscoverSection(
                repository: repository,
                onQuestTap: (quest) => _openQuest(context, quest),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackCircleButton extends StatelessWidget {
  const _BackCircleButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.backButton,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: const SizedBox(
          width: AppDimens.backButtonSize,
          height: AppDimens.backButtonSize,
          child: Icon(
            Icons.chevron_left_rounded,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
