import 'package:flutter/material.dart';

import '../models/profile_journey.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import 'item_overflow_menu.dart';
import 'journey_badge.dart';

class JourneyList extends StatelessWidget {
  const JourneyList({
    super.key,
    required this.journeys,
    required this.onRemove,
    this.onDetails,
  });

  final List<ProfileJourney> journeys;
  final ValueChanged<ProfileJourney> onRemove;
  final ValueChanged<ProfileJourney>? onDetails;

  @override
  Widget build(BuildContext context) {
    if (journeys.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Text('No journeys yet.', style: AppTextStyles.emptyTab),
      );
    }

    return Column(
      children: [
        for (var i = 0; i < journeys.length; i++) ...[
          if (i > 0) const SizedBox(height: AppDimens.profileListGap),
          JourneyListItem(
            journey: journeys[i],
            onRemove: () => onRemove(journeys[i]),
            onDetails: onDetails == null ? null : () => onDetails!(journeys[i]),
          ),
        ],
      ],
    );
  }
}

class JourneyListItem extends StatelessWidget {
  const JourneyListItem({
    super.key,
    required this.journey,
    required this.onRemove,
    this.onDetails,
  });

  final ProfileJourney journey;
  final VoidCallback onRemove;
  final VoidCallback? onDetails;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _JourneyThumbnail(
          asset: journey.thumbnailAsset,
          url: journey.thumbnailUrl,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                journey.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.profileListTitle,
              ),
              const SizedBox(height: 6),
              JourneyBadge(
                label: journey.badgeLabel,
                icon: journey.badgeIcon,
                color: journey.badgeColor,
              ),
            ],
          ),
        ),
        ItemOverflowMenu(
          itemLabel: journey.title,
          onDetails: onDetails ?? () {},
          onRemove: onRemove,
        ),
      ],
    );
  }
}

class _JourneyThumbnail extends StatelessWidget {
  const _JourneyThumbnail({this.asset, this.url});

  final String? asset;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.questCardRadius),
      child: SizedBox(
        width: AppDimens.journeyThumbSize,
        height: AppDimens.journeyThumbSize,
        child: ColoredBox(
          color: AppColors.questButton,
          child: _image(),
        ),
      ),
    );
  }

  Widget? _image() {
    if (asset != null && asset!.isNotEmpty) {
      return Image.asset(
        asset!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const SizedBox.expand(),
      );
    }
    if (url != null && url!.isNotEmpty) {
      return Image.network(
        url!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const SizedBox.expand(),
      );
    }
    return null;
  }
}
