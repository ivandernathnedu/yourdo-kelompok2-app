import 'package:flutter/material.dart';

import '../models/profile_post.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class PostStatistics extends StatelessWidget {
  const PostStatistics({super.key, required this.stats});

  final List<PostStat> stats;

  @override
  Widget build(BuildContext context) {
    if (stats.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        for (var i = 0; i < stats.length; i++) ...[
          if (i > 0) const SizedBox(width: 18),
          _StatItem(stat: stats[i]),
        ],
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.stat});

  final PostStat stat;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.questButton,
          ),
          alignment: Alignment.center,
          child: stat.icon == null
              ? null
              : Icon(stat.icon, size: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 6),
        Text('${stat.value}', style: AppTextStyles.postStat),
      ],
    );
  }
}
