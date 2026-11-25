import 'dart:async';

import 'package:flutter/material.dart';

import '../data/mock_profile_data.dart';
import '../data/quest_repository.dart';
import '../models/profile_journey.dart';
import '../models/profile_post.dart';
import '../models/profile_quest_entry.dart';
import '../models/profile_tab.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/post_service.dart';
import '../services/quest_randomizer.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../widgets/achievement_section.dart';
import '../widgets/edit_profile_dialog.dart';
import '../widgets/journey_list.dart';
import '../widgets/post_list.dart';
import '../widgets/post_skeleton.dart';
import '../widgets/profile_description.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_tab_bar.dart';
import '../widgets/quest_list.dart';
import '../widgets/quest_statistics_card.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    this.repository,
    this.randomizer,
    this.authService,
    this.loadTrigger = 0,
  });

  final QuestRepository? repository;
  final QuestRandomizer? randomizer;
  final AuthService? authService;
  final int loadTrigger;

  static const Duration skeletonDuration = Duration(milliseconds: 400);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileContentTab _activeTab = ProfileContentTab.posts;
  late List<ProfileQuestEntry> _quests;
  late List<ProfileJourney> _journeys;
  late final PostService _postService;
  Timer? _postsLoadingTimer;
  bool _isPostsLoading = true;

  @override
  void initState() {
    super.initState();
    _quests = List<ProfileQuestEntry>.from(MockProfileData.quests);
    _journeys = List<ProfileJourney>.from(MockProfileData.journeys);
    _postService = PostService();
    _startPostsSkeletonTimer();
  }

  @override
  void didUpdateWidget(covariant ProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.loadTrigger != widget.loadTrigger) {
      _startPostsSkeletonTimer();
    }
  }

  void _startPostsSkeletonTimer() {
    _postsLoadingTimer?.cancel();
    _isPostsLoading = true;
    _postsLoadingTimer = Timer(ProfilePage.skeletonDuration, () {
      if (!mounted) return;
      setState(() => _isPostsLoading = false);
    });
  }

  @override
  void dispose() {
    _postsLoadingTimer?.cancel();
    super.dispose();
  }

  Future<void> _logout() async {
    final authService = widget.authService ?? AuthService();
    await authService.logout();
    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => LoginPage(
          repository: widget.repository ?? const QuestRepository(),
          randomizer: widget.randomizer ?? QuestRandomizer(),
          authService: authService,
        ),
      ),
      (_) => false,
    );
  }

  ProfilePost _withUpdatedAuthor(ProfilePost post, UserProfile profile) {
    return ProfilePost(
      id: post.id,
      userId: post.userId,
      displayName: AuthService.customDisplayName ?? post.displayName,
      username: profile.username,
      photoUrl: profile.photoUrl ?? post.photoUrl,
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

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserProfile>(
      valueListenable: AuthService.profileNotifier,
      builder: (context, profile, _) {
        return SingleChildScrollView(
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: AppDimens.navHeight + AppDimens.navBottomInset + 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimens.pagePadding,
                      16,
                      AppDimens.pagePadding,
                      0,
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: _logout,
                            icon: const Icon(
                              Icons.logout_rounded,
                              size: 18,
                              color: AppColors.textSecondary,
                            ),
                            label: const Text(
                              'Logout',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        ProfileHeader(
                          profile: profile,
                          onEditProfile: () => EditProfileDialog.show(
                            context,
                            authService: widget.authService,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ProfileDescription(text: profile.bio),
                        const SizedBox(height: 20),
                        QuestStatisticsCard(questsTaken: profile.questsTaken),
                        const SizedBox(height: 24),
                        const AchievementSection(
                          groups: MockProfileData.achievementGroups,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  ProfileTabBar(
                    activeTab: _activeTab,
                    onChanged: (tab) {
                      setState(() {
                        _activeTab = tab;
                        if (tab == ProfileContentTab.posts) {
                          _startPostsSkeletonTimer();
                        }
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimens.pagePadding,
                      16,
                      AppDimens.pagePadding,
                      0,
                    ),
                    child: _tabContent(profile),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _tabContent(UserProfile profile) {
    switch (_activeTab) {
      case ProfileContentTab.posts:
        if (_isPostsLoading) {
          return const PostSkeletonList();
        }
        final mockPosts = MockProfileData.posts
            .map((post) => _withUpdatedAuthor(post, profile))
            .toList();
        return StreamBuilder<List<ProfilePost>>(
          stream: _postService.streamPosts(),
          builder: (context, snapshot) {
            final firestorePosts = (snapshot.data ?? [])
                .where(
                  (post) => post.userId == 'current_user' || post.userId == 'me',
                )
                .map((post) => _withUpdatedAuthor(post, profile))
                .toList();
            return PostList(posts: [...firestorePosts, ...mockPosts]);
          },
        );
      case ProfileContentTab.quests:
        return QuestList(
          quests: _quests,
          onRemove: (quest) {
            setState(() => _quests.removeWhere((item) => item.id == quest.id));
          },
        );
      case ProfileContentTab.journeys:
        return JourneyList(
          journeys: _journeys,
          onRemove: (journey) {
            setState(
              () => _journeys.removeWhere((item) => item.id == journey.id),
            );
          },
        );
    }
  }
}
