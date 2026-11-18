import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

class RandomizeQuestButton extends StatelessWidget {
  const RandomizeQuestButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: AppDimens.randomizeButtonSize,
            height: AppDimens.randomizeButtonSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.background,
              border: Border.all(
                color: AppColors.randomizeGlow.withValues(alpha: 0.55),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.randomizeGlow.withValues(alpha: 0.45),
                  blurRadius: AppDimens.randomizeGlowBlur,
                  spreadRadius: AppDimens.randomizeGlowSpread,
                ),
              ],
            ),
            child: const Icon(
              Icons.shuffle_rounded,
              size: AppDimens.randomizeIconSize,
              color: AppColors.randomizeGlow,
            ),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Let us decide\nfor you.',
          textAlign: TextAlign.center,
          style: AppTextStyles.pageInstruction,
        ),
      ],
    );
  }
}
