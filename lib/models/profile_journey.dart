import 'package:flutter/material.dart';

class ProfileJourney {
  const ProfileJourney({
    required this.id,
    required this.title,
    required this.badgeLabel,
    required this.badgeIcon,
    required this.badgeColor,
    this.thumbnailAsset,
    this.thumbnailUrl,
  });

  final String id;
  final String title;
  final String badgeLabel;
  final IconData badgeIcon;
  final Color badgeColor;
  final String? thumbnailAsset;
  final String? thumbnailUrl;
}
