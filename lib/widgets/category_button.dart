import 'package:flutter/material.dart';

import '../models/quest_category.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import 'glyph_icon.dart';

class CategoryButton extends StatelessWidget {
  const CategoryButton({
    super.key,
    required this.category,
    required this.onTap,
  });

  final QuestCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppDimens.categoryButtonSize,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppDimens.categoryButtonSize,
              height: AppDimens.categoryButtonSize,
              decoration: BoxDecoration(
                color: category.color,
                borderRadius: BorderRadius.circular(AppDimens.categoryRadius),
              ),
              alignment: Alignment.center,
              child: GlyphIcon(
                glyph: category.glyph,
                color: Colors.white,
                size: AppDimens.categoryIconSize,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              category.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.categoryLabel,
            ),
          ],
        ),
      ),
    );
  }
}
