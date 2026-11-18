import '../models/quest.dart';
import '../models/quest_category.dart';
import '../models/quest_group.dart';
import 'mock_quest_data.dart';

class QuestRepository {
  const QuestRepository();

  List<QuestCategory> get categories => MockQuestData.categories;

  List<Quest> get quests => MockQuestData.quests;

  List<QuestGroup> get recommendedGroups => MockQuestData.recommendedGroups;

  List<QuestGroup> get discoverGroups => MockQuestData.discoverGroups;

  Quest? questById(String id) {
    for (final quest in quests) {
      if (quest.id == id) return quest;
    }
    return null;
  }

  QuestCategory? categoryById(String id) {
    for (final category in categories) {
      if (category.id == id) return category;
    }
    return null;
  }

  List<Quest> questsByCategory(String categoryId) {
    return quests.where((quest) => quest.categoryId == categoryId).toList();
  }

  List<Quest> questsForGroup(QuestGroup group) {
    return group.questIds
        .map(questById)
        .whereType<Quest>()
        .toList(growable: false);
  }
}
