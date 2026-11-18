import 'package:flutter/material.dart';

import '../models/profile_quest_entry.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import 'item_overflow_menu.dart';

class QuestList extends StatelessWidget {
  const QuestList({
    super.key,
    required this.quests,
    required this.onRemove,
    this.onDetails,
  });

  final List<ProfileQuestEntry> quests;
  final ValueChanged<ProfileQuestEntry> onRemove;
  final ValueChanged<ProfileQuestEntry>? onDetails;

  @override
  Widget build(BuildContext context) {
    if (quests.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Text('No quests taken yet.', style: AppTextStyles.emptyTab),
      );
    }

    return Column(
      children: [
        for (var i = 0; i < quests.length; i++) ...[
          if (i > 0) const SizedBox(height: AppDimens.profileListGap),
          QuestListItem(
            quest: quests[i],
            onRemove: () => onRemove(quests[i]),
            onDetails: onDetails == null ? null : () => onDetails!(quests[i]),
          ),
        ],
      ],
    );
  }
}

class QuestListItem extends StatelessWidget {
  const QuestListItem({
    super.key,
    required this.quest,
    required this.onRemove,
    this.onDetails,
  });

  final ProfileQuestEntry quest;
  final VoidCallback onRemove;
  final VoidCallback? onDetails;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: AppDimens.profileListIconSize,
          height: AppDimens.profileListIconSize,
          decoration: BoxDecoration(
            color: quest.iconBackgroundColor,
            borderRadius: BorderRadius.circular(AppDimens.questIconRadius),
          ),
          alignment: Alignment.center,
          child: Icon(
            quest.icon,
            size: 22,
            color: AppColors.background,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quest.title,
                style: AppTextStyles.profileListTitle,
              ),
              const SizedBox(height: 4),
              Text(
                quest.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.profileListSubtitle,
              ),
            ],
          ),
        ),
        ItemOverflowMenu(
          itemLabel: quest.title,
          onDetails: onDetails ?? () {},
          onRemove: onRemove,
        ),
      ],
    );
  }
}
