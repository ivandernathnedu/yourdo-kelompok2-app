import 'package:flutter/material.dart';

import '../data/quest_repository.dart';
import '../services/auth_service.dart';
import '../services/quest_randomizer.dart';
import '../theme/app_colors.dart';
import '../widgets/app_bottom_nav.dart';
import 'create_post_dialog.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'quest_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.repository,
    required this.randomizer,
    this.authService,
    this.initialIndex = 0,
  });

  final QuestRepository repository;
  final QuestRandomizer randomizer;
  final AuthService? authService;
  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index;
  int _homeLoadTrigger = 0;
  int _profileLoadTrigger = 0;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  void _onSelectTab(int index) {
    setState(() {
      _index = index;
      if (index == 0) {
        _homeLoadTrigger++;
      } else if (index == 2) {
        _profileLoadTrigger++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: IndexedStack(
        index: _index,
        children: [
          HomePage(loadTrigger: _homeLoadTrigger),
          QuestPage(
            repository: widget.repository,
            randomizer: widget.randomizer,
          ),
          ProfilePage(
            repository: widget.repository,
            randomizer: widget.randomizer,
            authService: widget.authService,
            loadTrigger: _profileLoadTrigger,
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _index,
        onSelect: _onSelectTab,
        onAddTap: () => CreatePostDialog.show(context),
      ),
    );
  }
}
