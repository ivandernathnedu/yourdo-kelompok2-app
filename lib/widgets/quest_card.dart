import 'package:flutter/material.dart';

import '../models/quest.dart';
import '../models/quest_category.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import 'glyph_icon.dart';

class QuestCard extends StatelessWidget {
  const QuestCard({
    super.key,
    required this.quest,
    required this.category,
    required this.onTap,
  });

  final Quest quest;
  final QuestCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.questButton,
      borderRadius: BorderRadius.circular(AppDimens.questCardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.questCardRadius),
        child: SizedBox(
          height: AppDimens.questCardHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: AppDimens.questIconSize,
                  height: AppDimens.questIconSize,
                  decoration: BoxDecoration(
                    color: category.color,
                    borderRadius: BorderRadius.circular(
                      AppDimens.questIconRadius,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: GlyphIcon(
                    glyph: quest.glyph,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        quest.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.questTitle,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          GlyphIcon(
                            glyph: quest.glyph,
                            color: AppColors.textSecondary,
                            size: 11,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              quest.achievementLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.questLabel,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
