import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onSelect,
    this.onAddTap,
  });

  final int currentIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback? onAddTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(bottom: AppDimens.navBottomInset),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.navHorizontalInset,
          8,
          AppDimens.navHorizontalInset,
          0,
        ),
        child: Row(
          children: [
            // Kapsul Navigasi Utama (Home, Quests, Profile)
            Expanded(
              child: Container(
                height: AppDimens.navHeight,
                decoration: BoxDecoration(
                  color: AppColors.navBar,
                  borderRadius: BorderRadius.circular(AppDimens.navRadius),
                  border: Border.all(
                    color: AppColors.randomizeGlow.withValues(alpha: 0.35),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.randomizeGlow.withValues(alpha: 0.28),
                      blurRadius: AppDimens.navGlowBlur,
                      spreadRadius: AppDimens.navGlowSpread,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _NavItem(
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home_rounded,
                      label: 'Home',
                      selected: currentIndex == 0,
                      onTap: () => onSelect(0),
                    ),
                    _NavItem(
                      icon: Icons.grid_view_outlined,
                      activeIcon: Icons.grid_view_rounded,
                      label: 'Quests',
                      selected: currentIndex == 1,
                      onTap: () => onSelect(1),
                    ),
                    _NavItem(
                      icon: Icons.person_outline_rounded,
                      activeIcon: Icons.person_rounded,
                      label: 'Profile',
                      selected: currentIndex == 2,
                      onTap: () => onSelect(2),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Tombol Bulat Plus (+) di sisi kanan sesuai Gambar 6
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onAddTap,
                borderRadius: BorderRadius.circular(AppDimens.navRadius),
                child: Container(
                  width: AppDimens.navHeight,
                  height: AppDimens.navHeight,
                  decoration: BoxDecoration(
                    color: AppColors.navBar,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.randomizeGlow.withValues(alpha: 0.35),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.randomizeGlow.withValues(alpha: 0.28),
                        blurRadius: AppDimens.navGlowBlur,
                        spreadRadius: AppDimens.navGlowSpread,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add_rounded,
                      color: AppColors.randomizeGlow,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.textPrimary : AppColors.textSecondary;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.navRadius),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(selected ? activeIcon : icon, size: 22, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.navLabel.copyWith(
                color: color,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
