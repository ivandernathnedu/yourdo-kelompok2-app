import 'package:flutter/material.dart';

import '../models/profile_post.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'post_header.dart';
import 'post_media_grid.dart';
import 'post_statistics.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    this.showDivider = true,
    this.onProfileTap,
    this.onDelete,
  });

  final ProfilePost post;
  final bool showDivider;
  final VoidCallback? onProfileTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PostHeader(
          post: post,
          onProfileTap: onProfileTap,
          onDelete: onDelete,
        ),
        const SizedBox(height: 10),
        Text(post.caption, style: AppTextStyles.postCaption),
        if (post.mediaUrls.isNotEmpty) ...[
          const SizedBox(height: 12),
          PostMediaGrid(mediaUrls: post.mediaUrls),
        ],
        const SizedBox(height: 12),
        PostStatistics(stats: post.stats),
        if (showDivider) ...[
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: AppColors.divider),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}
