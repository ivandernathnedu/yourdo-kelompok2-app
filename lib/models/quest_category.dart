import 'package:flutter/material.dart';

import 'quest_glyph.dart';

class QuestCategory {
  const QuestCategory({
    required this.id,
    required this.name,
    required this.color,
    required this.glyph,
  });

  final String id;
  final String name;
  final Color color;
  final QuestGlyph glyph;
}
