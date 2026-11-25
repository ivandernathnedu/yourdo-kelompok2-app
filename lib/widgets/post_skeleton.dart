import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';

class PostSkeletonList extends StatelessWidget {
  const PostSkeletonList({
    super.key,
    this.itemCount = 2,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.45, end: 0.9),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
      child: Column(
        children: [
          for (var i = 0; i < itemCount; i++) ...[
            const _PostSkeletonCard(),
            if (i != itemCount - 1) ...[
              const SizedBox(height: 16),
              const Divider(height: 1, thickness: 1, color: AppColors.divider),
              const SizedBox(height: 16),
            ],
          ],
        ],
      ),
    );
  }
}

class _PostSkeletonCard extends StatelessWidget {
  const _PostSkeletonCard();

  Widget _bar({
    double? width,
    required double height,
    double radius = 6,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.section,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: AppDimens.postAvatarSize,
              height: AppDimens.postAvatarSize,
              decoration: const BoxDecoration(
                color: AppColors.section,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _bar(width: 110, height: 14),
                      const SizedBox(width: 8),
                      _bar(width: 72, height: 12),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _bar(width: 96, height: 20, radius: 6),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _bar(height: 12)),
                      const SizedBox(width: 16),
                      _bar(width: 60, height: 12),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _bar(width: double.infinity, height: 13),
        const SizedBox(height: 8),
        _bar(width: 220, height: 13),
        const SizedBox(height: 12),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.section,
              borderRadius: BorderRadius.circular(AppDimens.questCardRadius),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _bar(width: 48, height: 14),
            const SizedBox(width: 18),
            _bar(width: 48, height: 14),
            const SizedBox(width: 18),
            _bar(width: 48, height: 14),
          ],
        ),
      ],
    );
  }
}
