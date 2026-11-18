import 'package:flutter/material.dart';

import '../data/quest_repository.dart';
import '../models/quest.dart';
import '../theme/app_dimens.dart';
import 'quest_group_block.dart';
import 'section_card.dart';

class RecommendedSection extends StatelessWidget {
  const RecommendedSection({
    super.key,
    required this.repository,
    required this.onQuestTap,
  });

  final QuestRepository repository;
  final ValueChanged<Quest> onQuestTap;

  @override
  Widget build(BuildContext context) {
    final groups = repository.recommendedGroups;

    return SectionCard(
      title: 'Recommended for you',
      child: Column(
        children: [
          for (var i = 0; i < groups.length; i++) ...[
            QuestGroupBlock(
              description: groups[i].description,
              quests: repository.questsForGroup(groups[i]),
              categoryOf: (quest) => repository.categoryById(quest.categoryId)!,
              onQuestTap: onQuestTap,
              initialVisibleCount: groups[i].initialVisibleCount,
            ),
            if (i != groups.length - 1)
              const SizedBox(height: AppDimens.sectionGap),
          ],
        ],
      ),
    );
  }
}
