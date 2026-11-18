import 'package:cloud_firestore/cloud_firestore.dart';
import 'quest_glyph.dart';

class Quest {
  const Quest({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.achievementLabel,
    required this.description,
    required this.glyph,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final String categoryId;
  final String achievementLabel;
  final String description;
  final QuestGlyph glyph;
  final bool isCompleted;

  factory Quest.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>?) ?? {};
    final glyphName = data['glyph'] as String? ?? 'brain';
    final glyph = QuestGlyph.values.firstWhere(
      (g) => g.name == glyphName,
      orElse: () => QuestGlyph.brain,
    );

    return Quest(
      id: doc.id,
      title: data['title'] as String? ?? '',
      categoryId: data['categoryId'] as String? ?? 'general',
      achievementLabel: data['achievementLabel'] as String? ?? 'Quest',
      description: data['description'] as String? ?? '',
      glyph: glyph,
      isCompleted: data['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'categoryId': categoryId,
      'achievementLabel': achievementLabel,
      'description': description,
      'glyph': glyph.name,
      'isCompleted': isCompleted,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  Quest copyWith({
    String? id,
    String? title,
    String? categoryId,
    String? achievementLabel,
    String? description,
    QuestGlyph? glyph,
    bool? isCompleted,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
      achievementLabel: achievementLabel ?? this.achievementLabel,
      description: description ?? this.description,
      glyph: glyph ?? this.glyph,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
