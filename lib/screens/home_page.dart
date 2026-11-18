import 'package:flutter/material.dart';

import '../data/mock_home_data.dart';
import '../models/profile_post.dart';
import '../services/post_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../widgets/post_list.dart';
import 'user_profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openProfile(BuildContext context, ProfilePost post) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => UserProfilePage(
          profile: MockHomeData.userById(post.userId),
          posts: MockHomeData.postsForUser(post.userId),
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
          'This post and its images will be permanently removed from Firebase.',
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
        const SnackBar(content: Text('Post berhasil dihapus dari Firebase')),
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
            child: StreamBuilder<List<ProfilePost>>(
              stream: postService.streamPosts(),
              builder: (context, snapshot) {
                final firestorePosts = snapshot.data ?? [];
                // Gabungkan postingan dari Firebase (paling atas) dengan data lokal/mock
                final allPosts = [...firestorePosts, ...MockHomeData.posts];

                return PostList(
                  posts: allPosts,
                  onProfileTap: (post) => _openProfile(context, post),
                  // Hanya tampilkan opsi hapus untuk postingan milik uploader (dari Firebase)
                  onDeletePost: (post) {
                    final isUploader = post.userId == 'current_user' ||
                        firestorePosts.any((p) => p.id == post.id);

                    if (isUploader) {
                      _handleDeletePost(context, post, postService);
                    }
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
