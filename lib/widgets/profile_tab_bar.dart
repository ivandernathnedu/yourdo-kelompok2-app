import 'package:flutter/material.dart';

import '../models/profile_tab.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

class ProfileTabBar extends StatelessWidget {
  const ProfileTabBar({
    super.key,
    required this.activeTab,
    required this.onChanged,
  });

  final ProfileContentTab activeTab;
  final ValueChanged<ProfileContentTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.divider),
          bottom: BorderSide(color: AppColors.divider),
        ),
      ),
      child: SizedBox(
        height: AppDimens.tabBarHeight,
        child: Row(
          children: [
            _TabButton(
              label: 'Posts',
              selected: activeTab == ProfileContentTab.posts,
              onTap: () => onChanged(ProfileContentTab.posts),
            ),
            _TabButton(
              label: 'Quests',
              selected: activeTab == ProfileContentTab.quests,
              onTap: () => onChanged(ProfileContentTab.quests),
            ),
            _TabButton(
              label: 'Journeys',
              selected: activeTab == ProfileContentTab.journeys,
              onTap: () => onChanged(ProfileContentTab.journeys),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.textPrimary : AppColors.textSecondary;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.profileTab.copyWith(color: color),
          ),
        ),
      ),
    );
  }
}
