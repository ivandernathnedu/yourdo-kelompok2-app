import 'package:flutter/material.dart';

import '../models/profile_post.dart';
import '../theme/app_text_styles.dart';
import 'post_card.dart';

class PostList extends StatelessWidget {
  const PostList({
    super.key,
    required this.posts,
    this.onProfileTap,
    this.onDeletePost,
  });

  final List<ProfilePost> posts;
  final ValueChanged<ProfilePost>? onProfileTap;
  final ValueChanged<ProfilePost>? onDeletePost;

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Text('No posts yet.', style: AppTextStyles.emptyTab),
      );
    }

    return Column(
      children: [
        for (var i = 0; i < posts.length; i++)
          PostCard(
            post: posts[i],
            showDivider: i != posts.length - 1,
            onProfileTap: onProfileTap == null
                ? null
                : () => onProfileTap!(posts[i]),
            onDelete: onDeletePost == null
                ? null
                : () => onDeletePost!(posts[i]),
          ),
      ],
    );
  }
}
