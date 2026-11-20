import 'package:flutter/material.dart';

import '../data/mock_home_data.dart';
import '../models/profile_post.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/post_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../widgets/post_list.dart';
import 'user_profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  bool _isCurrentUserPost(ProfilePost post) {
    return post.userId == 'current_user' || post.userId == 'me';
  }

  ProfilePost _applyCurrentProfile(
    ProfilePost post,
    UserProfile currentProfile,
  ) {
    if (!_isCurrentUserPost(post)) return post;

    return ProfilePost(
      id: post.id,
      userId: post.userId,
      displayName: AuthService.customDisplayName ?? post.displayName,
      username: currentProfile.username,
      photoUrl: currentProfile.photoUrl ?? post.photoUrl,
      categoryLabel: post.categoryLabel,
      categoryColor: post.categoryColor,
      categoryIcon: post.categoryIcon,
      activityTitle: post.activityTitle,
      date: post.date,
      caption: post.caption,
      mediaUrls: post.mediaUrls,
      stats: post.stats,
    );
  }

  void _openProfile(
    BuildContext context,
    ProfilePost post,
    List<ProfilePost> allPosts,
  ) {
    final isSelf = _isCurrentUserPost(post);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => UserProfilePage(
          profile: isSelf
              ? AuthService.profileNotifier.value
              : MockHomeData.userById(post.userId),
          posts: isSelf
              ? allPosts.where(_isCurrentUserPost).toList()
              : MockHomeData.postsForUser(post.userId),
        ),
      ),
    );
  }

  void _handleDeletePost(
    BuildContext context,
    ProfilePost post,
    PostService postService,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.section,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Delete post?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'This post and its images will be permanently removed.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final messenger = ScaffoldMessenger.of(context);
      await postService.deletePost(post.id);
      messenger.showSnackBar(
        const SnackBar(content: Text('Postingan berhasil dihapus')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final postService = PostService();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.pagePadding,
              16,
              AppDimens.pagePadding,
              AppDimens.navHeight + AppDimens.navBottomInset + 32,
            ),
            child: ValueListenableBuilder<UserProfile>(
              valueListenable: AuthService.profileNotifier,
              builder: (context, currentProfile, _) {
                return StreamBuilder<List<ProfilePost>>(
                  stream: postService.streamPosts(),
                  builder: (context, snapshot) {
                    final firestorePosts = (snapshot.data ?? [])
                        .map((post) => _applyCurrentProfile(post, currentProfile))
                        .toList();
                    // Gabungkan postingan dari Firebase (paling atas) dengan data lokal/mock
                    final allPosts = [...firestorePosts, ...MockHomeData.posts];

                    return PostList(
                      posts: allPosts,
                      onProfileTap: (post) =>
                          _openProfile(context, post, allPosts),
                      // Hanya tampilkan opsi hapus untuk postingan milik uploader
                      onDeletePost: (post) {
                        final isUploader = _isCurrentUserPost(post) ||
                            firestorePosts.any((p) => p.id == post.id);

                        if (isUploader) {
                          _handleDeletePost(context, post, postService);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
