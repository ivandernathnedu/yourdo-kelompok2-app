import 'package:flutter/material.dart';

import '../models/profile_post.dart';
import '../models/user_profile.dart';
import '../theme/app_colors.dart';

class MockHomeData {
  MockHomeData._();

  static const UserProfile rizky = UserProfile(
    id: 'rizky',
    displayName: 'Rizky Pratama',
    username: '@rizky.lifts',
    bio:
        'Showing up, lifting heavy, and stacking small wins. See you at the next session.',
    followers: 128,
    following: 64,
    questsTaken: 18,
    photoUrl: 'Assets/Images/avatar_rizky.jpg',
  );

  static const UserProfile naya = UserProfile(
    id: 'naya',
    displayName: 'Naya Putri',
    username: '@naya.withthecamera',
    bio:
        'Short films, long bloopers. Collecting behind-the-scenes moments with friends.',
    followers: 246,
    following: 91,
    questsTaken: 22,
  );

  static const UserProfile bima = UserProfile(
    id: 'bima',
    displayName: 'Bima Kurniawan',
    username: '@bima.bytes',
    bio:
        'Indie worlds, pixel towns, and games that accidentally steal four hours.',
    followers: 173,
    following: 88,
    questsTaken: 15,
  );

  static const UserProfile sasha = UserProfile(
    id: 'sasha',
    displayName: 'Sasha Wijaya',
    username: '@sashagoesplaces',
    bio:
        'Early mornings, ridgelines, and slow miles. Always looking for the next trail.',
    followers: 201,
    following: 110,
    questsTaken: 27,
  );

  static const List<UserProfile> users = [rizky, naya, bima, sasha];

  static UserProfile userById(String id) {
    return users.firstWhere(
      (user) => user.id == id,
      orElse: () => rizky,
    );
  }

  static const List<ProfilePost> posts = [
    ProfilePost(
      id: 'home_gym',
      userId: 'rizky',
      displayName: 'Rizky Pratama',
      username: '@rizky.lifts',
      photoUrl: 'Assets/Images/avatar_rizky.jpg',
      categoryLabel: 'Body Builder',
      categoryColor: AppColors.healthFitness,
      categoryIcon: Icons.fitness_center_rounded,
      activityTitle: 'Clocked in. Lifted heavy.',
      date: '10/09/2026',
      caption:
          "Almost talked myself out of going today. Glad I didn't. Nothing crazy, just showing up and getting the work done. See you at the next session.",
      mediaUrls: ['Assets/Images/post_gym.jpg'],
      stats: [
        PostStat(value: 42, icon: Icons.favorite_border_rounded),
        PostStat(value: 8, icon: Icons.chat_bubble_outline_rounded),
        PostStat(value: 3, icon: Icons.share_outlined),
      ],
    ),
    ProfilePost(
      id: 'home_film',
      userId: 'naya',
      displayName: 'Naya Putri',
      username: '@naya.withthecamera',
      categoryLabel: 'Filmmaker',
      categoryColor: AppColors.artsCreativity,
      categoryIcon: Icons.videocam_rounded,
      activityTitle: 'We came to film one video. We left with 47 bloopers.',
      date: '16/09/2026',
      caption:
          'Nobody can take anything seriously for more than 5 seconds. The actual video took 20 minutes, but the behind-the-scenes footage? Oscar-worthy. Please never let us start a production company.',
      mediaUrls: [
        'Assets/Images/post_filmmaking_1.jpg',
        'Assets/Images/post_filmmaking_2.jpg',
      ],
      stats: [
        PostStat(value: 98, icon: Icons.favorite_border_rounded),
        PostStat(value: 21, icon: Icons.chat_bubble_outline_rounded),
        PostStat(value: 14, icon: Icons.share_outlined),
      ],
    ),
    ProfilePost(
      id: 'home_indie',
      userId: 'bima',
      displayName: 'Bima Kurniawan',
      username: '@bima.bytes',
      categoryLabel: 'Indie Explorer',
      categoryColor: AppColors.mediaEntertainment,
      categoryIcon: Icons.sports_esports_rounded,
      activityTitle: 'Why did nobody tell me about this game?',
      date: '16/09/2026',
      caption:
          "Wasn't expecting a rustic harvest. Four hours later, I'm emotionally attached to fictional plants. Indie games are dangerous.",
      mediaUrls: ['Assets/Images/post_indie_game.png'],
      stats: [
        PostStat(value: 63, icon: Icons.favorite_border_rounded),
        PostStat(value: 12, icon: Icons.chat_bubble_outline_rounded),
        PostStat(value: 7, icon: Icons.share_outlined),
      ],
    ),
    ProfilePost(
      id: 'home_hike',
      userId: 'sasha',
      displayName: 'Sasha Wijaya',
      username: '@sashagoesplaces',
      categoryLabel: 'Hiker',
      categoryColor: AppColors.outdoorsAdventure,
      categoryIcon: Icons.terrain_rounded,
      activityTitle: 'The 4AM start was a personal attack.',
      date: '16/09/2026',
      caption:
          'But then the sun came up over the last, and suddenly the early start made sense. Already looking for the next hike.',
      mediaUrls: ['Assets/Images/post_hiking.jpg'],
      stats: [
        PostStat(value: 71, icon: Icons.favorite_border_rounded),
        PostStat(value: 9, icon: Icons.chat_bubble_outline_rounded),
        PostStat(value: 5, icon: Icons.share_outlined),
      ],
    ),
    ProfilePost(
      id: 'home_run',
      userId: 'sasha',
      displayName: 'Sasha Wijaya',
      username: '@sashagoesplaces',
      categoryLabel: 'Runner',
      categoryColor: AppColors.healthFitness,
      categoryIcon: Icons.directions_run_rounded,
      activityTitle: 'Not breaking any records, but we walk breaks this time.',
      date: '16/09/2026',
      caption:
          "Six months ago I couldn't even finish 2K. Small wins count. Legs are officially filing a complaint.",
      mediaUrls: ['Assets/Images/post_running.jpg'],
      stats: [
        PostStat(value: 54, icon: Icons.favorite_border_rounded),
        PostStat(value: 6, icon: Icons.chat_bubble_outline_rounded),
        PostStat(value: 2, icon: Icons.share_outlined),
      ],
    ),
  ];

  static List<ProfilePost> postsForUser(String userId) {
    return posts.where((post) => post.userId == userId).toList();
  }
}
