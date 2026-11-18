import 'package:flutter/material.dart';

class PostStat {
  const PostStat({
    required this.value,
    this.icon,
  });

  final int value;
  final IconData? icon;
}

class ProfilePost {
  const ProfilePost({
    required this.id,
    required this.userId,
    required this.displayName,
    required this.username,
    required this.categoryLabel,
    required this.categoryColor,
    required this.categoryIcon,
    required this.activityTitle,
    required this.date,
    required this.caption,
    this.photoUrl,
    this.mediaUrls = const [],
    this.stats = const [],
  });

  final String id;
  final String userId;
  final String displayName;
  final String username;
  final String? photoUrl;
  final String categoryLabel;
  final Color categoryColor;
  final IconData categoryIcon;
  final String activityTitle;
  final String date;
  final String caption;
  final List<String> mediaUrls;
  final List<PostStat> stats;
}
