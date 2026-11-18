import 'package:flutter/material.dart';

import '../data/mock_profile_data.dart';
import '../models/profile_journey.dart';
import '../models/profile_quest_entry.dart';
import '../models/profile_tab.dart';
import '../theme/app_dimens.dart';
import '../widgets/achievement_section.dart';
import '../widgets/journey_list.dart';
import '../widgets/post_list.dart';
import '../widgets/profile_description.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_tab_bar.dart';
import '../widgets/quest_list.dart';
import '../widgets/quest_statistics_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileContentTab _activeTab = ProfileContentTab.posts;
  late List<ProfileQuestEntry> _quests;
  late List<ProfileJourney> _journeys;

  @override
  void initState() {
    super.initState();
    _quests = List<ProfileQuestEntry>.from(MockProfileData.quests);
    _journeys = List<ProfileJourney>.from(MockProfileData.journeys);
  }

  @override
  Widget build(BuildContext context) {
    final profile = MockProfileData.user;

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
                    ProfileHeader(profile: profile),
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
                onChanged: (tab) => setState(() => _activeTab = tab),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.pagePadding,
                  16,
                  AppDimens.pagePadding,
                  0,
                ),
                child: _tabContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabContent() {
    switch (_activeTab) {
      case ProfileContentTab.posts:
        return const PostList(posts: MockProfileData.posts);
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
