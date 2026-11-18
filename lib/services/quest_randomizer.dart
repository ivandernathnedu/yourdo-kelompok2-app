import 'dart:math';

import '../models/quest.dart';

class QuestRandomizer {
  QuestRandomizer({Random? random}) : _random = random ?? Random();

  final Random _random;

  Quest pick(List<Quest> quests) {
    if (quests.isEmpty) {
      throw StateError('Cannot randomize an empty quest list.');
    }
    return quests[_random.nextInt(quests.length)];
  }
}
