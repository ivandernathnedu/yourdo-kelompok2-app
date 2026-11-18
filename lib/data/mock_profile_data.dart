import 'package:flutter/material.dart';

import '../models/achievement.dart';
import '../models/profile_journey.dart';
import '../models/profile_post.dart';
import '../models/profile_quest_entry.dart';
import '../models/user_profile.dart';
import '../theme/app_colors.dart';

class MockProfileData {
  MockProfileData._();

  static const UserProfile user = UserProfile(
    id: 'me',
    displayName: 'Lorem Ipsum dolor',
    username: '@username',
    bio:
        'Lorem ipsum dolor sit amet, irure elit nulla dolore eiusmod adipiscing magna. Tempor tempor ut in elit irure dolore non et dolore. Nostrud in ut aliqua ad ut ex incididunt.',
    followers: 0,
    following: 0,
    questsTaken: 25,
  );

  static const List<AchievementGroup> achievementGroups = [
    AchievementGroup(
      monthLabel: 'September',
      achievements: [
        Achievement(
          id: 'movie_watcher',
          name: 'Movie Watcher',
          description: 'Watched 7 new movies',
          icon: Icons.movie_creation_rounded,
          color: AppColors.mediaEntertainment,
        ),
        Achievement(
          id: 'designer',
          name: 'Designer',
          description: 'Made 5 designs',
          icon: Icons.desktop_windows_rounded,
          color: AppColors.artsCreativity,
        ),
        Achievement(
          id: 'friend',
          name: 'Friend',
          description: 'Explored 3 places',
          icon: Icons.people_alt_rounded,
          color: AppColors.socialExperiences,
        ),
        Achievement(
          id: 'knowledge_seeker',
          name: 'Knowledge Seeker',
          description: 'Read 2 books',
          icon: Icons.lightbulb_rounded,
          color: AppColors.learningDiscovery,
        ),
      ],
    ),
  ];

  static const List<PostStat> _defaultStats = [
    PostStat(value: 100),
    PostStat(value: 100),
    PostStat(value: 100),
  ];

  static const List<ProfilePost> posts = [
    ProfilePost(
      id: 'post_1',
      userId: 'me',
      displayName: 'Lorem Ipsum',
      username: '@username',
      categoryLabel: 'Movie Watcher',
      categoryColor: AppColors.mediaEntertainment,
      categoryIcon: Icons.movie_creation_rounded,
      activityTitle: 'Thunderbolts',
      date: '16/09/2026',
      caption:
          'Finally got around to watching this one. The characters were what made it worth the watch.',
      mediaUrls: ['placeholder_1', 'placeholder_2'],
      stats: _defaultStats,
    ),
    ProfilePost(
      id: 'post_2',
      userId: 'me',
      displayName: 'Lorem Ipsum',
      username: '@username',
      categoryLabel: 'Designer',
      categoryColor: AppColors.artsCreativity,
      categoryIcon: Icons.desktop_windows_rounded,
      activityTitle: 'A little motion study',
      date: '12/09/2026',
      caption:
          'Spent the evening experimenting with shapes, transitions, and timing in After Effects.',
      mediaUrls: ['placeholder_3', 'placeholder_4'],
      stats: _defaultStats,
    ),
  ];

  static const List<ProfileQuestEntry> quests = [
    ProfileQuestEntry(
      id: 'pq_1',
      title: 'Watch a movie',
      description: '7 quests',
      icon: Icons.movie_creation_rounded,
      iconBackgroundColor: AppColors.mediaEntertainment,
    ),
    ProfileQuestEntry(
      id: 'pq_2',
      title: 'Listen to music',
      description: '5 quests',
      icon: Icons.headphones_rounded,
      iconBackgroundColor: AppColors.mediaEntertainment,
    ),
    ProfileQuestEntry(
      id: 'pq_3',
      title: 'Create a motion graphic',
      description: '4 quests',
      icon: Icons.desktop_windows_rounded,
      iconBackgroundColor: AppColors.artsCreativity,
    ),
    ProfileQuestEntry(
      id: 'pq_4',
      title: 'Complete a gym session',
      description: '5 quests',
      icon: Icons.fitness_center_rounded,
      iconBackgroundColor: AppColors.healthFitness,
    ),
    ProfileQuestEntry(
      id: 'pq_5',
      title: "Learn about something you've always wondered about",
      description: '3 quests',
      icon: Icons.lightbulb_rounded,
      iconBackgroundColor: AppColors.learningDiscovery,
    ),
    ProfileQuestEntry(
      id: 'pq_6',
      title: 'Read a nonfiction book',
      description: '3 quests',
      icon: Icons.menu_book_rounded,
      iconBackgroundColor: AppColors.learningDiscovery,
    ),
    ProfileQuestEntry(
      id: 'pq_7',
      title: 'Hang out with a friend',
      description: '2 quests',
      icon: Icons.people_alt_rounded,
      iconBackgroundColor: AppColors.socialExperiences,
    ),
  ];

  static const List<ProfileJourney> journeys = [
    ProfileJourney(
      id: 'j_1',
      title: 'Nonton Breaking Bad',
      badgeLabel: 'Season Finisher',
      badgeIcon: Icons.flag_rounded,
      badgeColor: AppColors.mediaEntertainment,
    ),
    ProfileJourney(
      id: 'j_2',
      title: 'My Blender Journey',
      badgeLabel: 'Designer',
      badgeIcon: Icons.desktop_windows_rounded,
      badgeColor: AppColors.artsCreativity,
    ),
    ProfileJourney(
      id: 'j_3',
      title: 'Filming “The Chair” short movie',
      badgeLabel: 'Filmmaker',
      badgeIcon: Icons.videocam_rounded,
      badgeColor: AppColors.artsCreativity,
    ),
    ProfileJourney(
      id: 'j_4',
      title: 'Yogyakarta Trip',
      badgeLabel: 'Traveler',
      badgeIcon: Icons.public_rounded,
      badgeColor: AppColors.outdoorsAdventure,
    ),
    ProfileJourney(
      id: 'j_5',
      title: 'Character Illustration Project',
      badgeLabel: 'Illustrator',
      badgeIcon: Icons.edit_rounded,
      badgeColor: AppColors.artsCreativity,
    ),
  ];
}
