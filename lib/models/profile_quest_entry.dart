import 'package:flutter/material.dart';

class ProfileQuestEntry {
  const ProfileQuestEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconBackgroundColor,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color iconBackgroundColor;
}
