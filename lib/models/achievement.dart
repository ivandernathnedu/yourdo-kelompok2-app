import 'package:flutter/material.dart';

class Achievement {
  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
}

class AchievementGroup {
  const AchievementGroup({
    required this.monthLabel,
    required this.achievements,
  });

  final String monthLabel;
  final List<Achievement> achievements;
}
