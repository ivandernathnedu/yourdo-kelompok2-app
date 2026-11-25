import 'dart:async';

import 'package:flutter/material.dart';

import '../data/mock_home_data.dart';
import '../models/profile_post.dart';
import '../models/user_profile.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../widgets/post_card.dart';
import '../widgets/post_skeleton.dart';
import 'user_profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.loadTrigger = 0,
  });

  final int loadTrigger;

  static const Duration skeletonDuration = Duration(milliseconds: 400);
  static const Duration loadMoreDelay = Duration(milliseconds: 400);
  static const int initialBatchSize = 10;
  static const int loadMoreBatchSize = 5;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const List<UserProfile> _dummyAuthors = MockHomeData.users;

  static const List<({String label, Color color, IconData icon})>
      _dummyCategories = [
    (
      label: 'Body Builder',
      color: AppColors.healthFitness,
      icon: Icons.fitness_center_rounded,
    ),
    (
      label: 'Filmmaker',
      color: AppColors.artsCreativity,
      icon: Icons.videocam_rounded,
    ),
    (
      label: 'Indie Explorer',
      color: AppColors.mediaEntertainment,
      icon: Icons.sports_esports_rounded,
    ),
    (
      label: 'Hiker',
      color: AppColors.outdoorsAdventure,
      icon: Icons.terrain_rounded,
    ),
    (
      label: 'Runner',
      color: AppColors.healthFitness,
      icon: Icons.directions_run_rounded,
    ),
  ];

  static const List<String> _dummyTitles = [
    'Clocked in. Lifted heavy.',
    'We came to film one video. We left with 47 bloopers.',
    'Why did nobody tell me about this game?',
    'The 4AM start was a personal attack.',
    'Not breaking any records, but we walk breaks this time.',
  ];

  static const List<String> _dummyCaptions = [
    "Almost talked myself out of going today. Glad I didn't. Nothing crazy, just showing up and getting the work done. See you at the next session.",
    'Nobody can take anything seriously for more than 5 seconds. The actual video took 20 minutes, but the behind-the-scenes footage? Oscar-worthy.',
    "Wasn't expecting a rustic harvest. Four hours later, I'm emotionally attached to fictional plants. Indie games are dangerous.",
    'But then the sun came up over the last ridge, and suddenly the early start made sense. Already looking for the next hike.',
    "Six months ago I couldn't even finish 2K. Small wins count. Legs are officially filing a complaint.",
  ];

  final ScrollController _scrollController = ScrollController();
  final List<ProfilePost> _posts = [];

  Timer? _loadingTimer;
  Timer? _loadMoreTimer;
  bool _isLoading = true;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _posts.addAll(_generateDummyPosts(0, HomePage.initialBatchSize));
    _scrollController.addListener(_onScroll);
    _startSkeletonTimer();
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.loadTrigger != widget.loadTrigger) {
      _startSkeletonTimer();
    }
  }

  void _startSkeletonTimer() {
    _loadingTimer?.cancel();
    _isLoading = true;
    _loadingTimer = Timer(HomePage.skeletonDuration, () {
      if (!mounted) return;
      setState(() => _isLoading = false);
    });
  }

  void _onScroll() {
    if (_isLoading || _isLoadingMore) return;
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      _loadMorePosts();
    }
  }

  void _loadMorePosts() {
    if (_isLoadingMore) return;

    setState(() => _isLoadingMore = true);
    _loadMoreTimer?.cancel();
    _loadMoreTimer = Timer(HomePage.loadMoreDelay, () {
      if (!mounted) return;
      final nextBatch = _generateDummyPosts(
        _posts.length,
        HomePage.loadMoreBatchSize,
      );
      setState(() {
        _posts.addAll(nextBatch);
        _isLoadingMore = false;
      });
    });
  }

  List<ProfilePost> _generateDummyPosts(int startIndex, int count) {
    return List<ProfilePost>.generate(count, (offset) {
      final index = startIndex + offset;
      final author = _dummyAuthors[index % _dummyAuthors.length];
      final category = _dummyCategories[index % _dummyCategories.length];
      final title = _dummyTitles[index % _dummyTitles.length];
      final baseCaption = _dummyCaptions[index % _dummyCaptions.length];
      final hoursAgo = (index % 23) + 1;

      return ProfilePost(
        id: 'dummy_post_$index',
        userId: author.id,
        displayName: author.displayName,
        username: author.username,
        photoUrl: author.photoUrl,
        categoryLabel: category.label,
        categoryColor: category.color,
        categoryIcon: category.icon,
        activityTitle: '$title (#${index + 1})',
        date: '$hoursAgo jam lalu',
        caption: baseCaption,
        mediaUrls: ['https://picsum.photos/seed/post$index/600/400'],
        stats: [
          PostStat(
            value: 15 + ((index * 7) % 90),
            icon: Icons.favorite_border_rounded,
          ),
          PostStat(
            value: 3 + ((index * 3) % 25),
            icon: Icons.chat_bubble_outline_rounded,
          ),
          PostStat(
            value: 1 + (index % 12),
            icon: Icons.share_outlined,
          ),
        ],
      );
    });
  }

  void _openProfile(BuildContext context, ProfilePost post) {
    final userPosts = _posts.where((p) => p.userId == post.userId).toList();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => UserProfilePage(
          profile: MockHomeData.userById(post.userId),
          posts: userPosts.isNotEmpty
              ? userPosts
              : MockHomeData.postsForUser(post.userId),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    _loadMoreTimer?.cancel();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const contentPadding = EdgeInsets.fromLTRB(
      AppDimens.pagePadding,
      16,
      AppDimens.pagePadding,
      AppDimens.navHeight + AppDimens.navBottomInset + 32,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: _isLoading
            ? const SingleChildScrollView(
                padding: contentPadding,
                child: PostSkeletonList(),
              )
            : ListView.builder(
                controller: _scrollController,
                padding: contentPadding,
                itemCount: _posts.length + (_isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= _posts.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: SizedBox(
                          width: 26,
                          height: 26,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.questButton,
                          ),
                        ),
                      ),
                    );
                  }

                  final post = _posts[index];
                  final isLastItem =
                      index == _posts.length - 1 && !_isLoadingMore;

                  return PostCard(
                    post: post,
                    showDivider: !isLastItem,
                    onProfileTap: () => _openProfile(context, post),
                  );
                },
              ),
      ),
    );
  }
}
