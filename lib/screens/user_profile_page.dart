import 'package:flutter/material.dart';

import '../models/profile_post.dart';
import '../models/user_profile.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import '../widgets/post_list.dart';
import '../widgets/profile_description.dart';
import '../widgets/profile_header.dart';
import '../widgets/quest_statistics_card.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({
    super.key,
    required this.profile,
    required this.posts,
  });

  final UserProfile profile;
  final List<ProfilePost> posts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(profile.displayName, style: AppTextStyles.sectionTitle),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.pagePadding,
              8,
              AppDimens.pagePadding,
              32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProfileHeader(profile: profile),
                const SizedBox(height: 20),
                ProfileDescription(text: profile.bio),
                const SizedBox(height: 20),
                QuestStatisticsCard(questsTaken: profile.questsTaken),
                const SizedBox(height: 24),
                PostList(posts: posts),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
