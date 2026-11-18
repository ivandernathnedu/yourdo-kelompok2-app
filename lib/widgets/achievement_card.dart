import 'package:flutter/material.dart';

import '../models/achievement.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

class AchievementCard extends StatelessWidget {
  const AchievementCard({super.key, required this.achievement});

  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.questButton,
        borderRadius: BorderRadius.circular(AppDimens.questCardRadius),
      ),
      child: Row(
        children: [
          Container(
            width: AppDimens.achievementIconSize,
            height: AppDimens.achievementIconSize,
            decoration: BoxDecoration(
              color: achievement.color,
              borderRadius: BorderRadius.circular(AppDimens.questIconRadius),
            ),
            alignment: Alignment.center,
            child: Icon(
              achievement.icon,
              size: 18,
              color: AppColors.background,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  achievement.name.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.achievementTitle,
                ),
                const SizedBox(height: 2),
                Text(
                  achievement.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.achievementProgress,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
