import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

class QuestStatisticsCard extends StatelessWidget {
  const QuestStatisticsCard({
    super.key,
    required this.questsTaken,
    this.label = 'Quest taken',
  });

  final int questsTaken;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.section,
          borderRadius: BorderRadius.circular(AppDimens.statsCardRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppDimens.statsCircleSize,
              height: AppDimens.statsCircleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.section,
                border: Border.all(
                  color: AppColors.randomizeGlow.withValues(alpha: 0.55),
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.randomizeGlow.withValues(alpha: 0.45),
                    blurRadius: AppDimens.statsGlowBlur,
                    spreadRadius: AppDimens.statsGlowSpread,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                '$questsTaken',
                style: AppTextStyles.questTakenCount,
              ),
            ),
            const SizedBox(height: 10),
            Text(label, style: AppTextStyles.questTakenLabel),
          ],
        ),
      ),
    );
  }
}
