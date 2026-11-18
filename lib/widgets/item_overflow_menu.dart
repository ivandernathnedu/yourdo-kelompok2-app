import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum ItemOverflowAction { details, remove }

class ItemOverflowMenu extends StatelessWidget {
  const ItemOverflowMenu({
    super.key,
    required this.itemLabel,
    required this.onDetails,
    required this.onRemove,
  });

  final String itemLabel;
  final VoidCallback onDetails;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ItemOverflowAction>(
      tooltip: 'More',
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      color: AppColors.section,
      icon: const Icon(
        Icons.more_horiz_rounded,
        color: AppColors.textSecondary,
      ),
      onSelected: (action) async {
        switch (action) {
          case ItemOverflowAction.details:
            onDetails();
          case ItemOverflowAction.remove:
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: AppColors.section,
                title: Text(
                  'Remove item?',
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 16),
                ),
                content: Text(
                  'Remove “$itemLabel” from this list?',
                  style: AppTextStyles.profileBio,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                      'Remove',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            );
            if (confirmed == true) {
              onRemove();
            }
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: ItemOverflowAction.details,
          child: Text('View details', style: AppTextStyles.profileMeta),
        ),
        PopupMenuItem(
          value: ItemOverflowAction.remove,
          child: Text('Remove', style: AppTextStyles.profileMeta),
        ),
      ],
    );
  }
}
