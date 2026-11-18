import 'package:flutter/material.dart';

import '../data/quest_repository.dart';
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
  });

  final QuestRepository repository;
  final QuestRandomizer randomizer;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: IndexedStack(
        index: _index,
        children: [
          const HomePage(),
          QuestPage(
            repository: widget.repository,
            randomizer: widget.randomizer,
          ),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _index,
        onSelect: (index) => setState(() => _index = index),
        onAddTap: () => CreatePostDialog.show(context),
      ),
    );
  }
}
