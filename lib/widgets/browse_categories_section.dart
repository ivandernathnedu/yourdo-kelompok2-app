import 'package:flutter/material.dart';

import '../models/quest_category.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import 'category_button.dart';
import 'section_card.dart';

class BrowseCategoriesSection extends StatelessWidget {
  const BrowseCategoriesSection({
    super.key,
    required this.categories,
    required this.onCategoryTap,
    required this.onSeeMore,
  });

  final List<QuestCategory> categories;
  final ValueChanged<QuestCategory> onCategoryTap;
  final VoidCallback onSeeMore;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Browse categories',
      trailing: TextButton(
        onPressed: onSeeMore,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text('See more', style: AppTextStyles.seeMore),
      ),
      child: SizedBox(
        height: AppDimens.categoryListHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (_, _) => const SizedBox(width: AppDimens.itemGap),
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryButton(
              category: category,
              onTap: () => onCategoryTap(category),
            );
          },
        ),
      ),
    );
  }
}
