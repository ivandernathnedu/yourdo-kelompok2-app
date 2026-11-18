import 'package:flutter/material.dart';

import '../models/achievement.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import 'achievement_card.dart';

class AchievementSection extends StatelessWidget {
  const AchievementSection({super.key, required this.groups});

  final List<AchievementGroup> groups;

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < groups.length; i++) ...[
          if (i > 0) const SizedBox(height: AppDimens.sectionGap),
          Text(groups[i].monthLabel, style: AppTextStyles.monthHeading),
          const SizedBox(height: 12),
          _AchievementGrid(achievements: groups[i].achievements),
        ],
      ],
    );
  }
}

class _AchievementGrid extends StatelessWidget {
  const _AchievementGrid({required this.achievements});

  final List<Achievement> achievements;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < achievements.length; i += 2) {
      final left = achievements[i];
      final right = i + 1 < achievements.length ? achievements[i + 1] : null;
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: i + 2 < achievements.length ? 10 : 0),
          child: Row(
            children: [
              Expanded(child: AchievementCard(achievement: left)),
              const SizedBox(width: 10),
              Expanded(
                child: right == null
                    ? const SizedBox.shrink()
                    : AchievementCard(achievement: right),
              ),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}
