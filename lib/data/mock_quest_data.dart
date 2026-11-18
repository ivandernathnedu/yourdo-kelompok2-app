import '../models/quest.dart';
import '../models/quest_category.dart';
import '../models/quest_glyph.dart';
import '../models/quest_group.dart';
import '../theme/app_colors.dart';

class CategoryIds {
  CategoryIds._();

  static const String mediaEntertainment = 'media_entertainment';
  static const String learningDiscovery = 'learning_discovery';
  static const String healthFitness = 'health_fitness';
  static const String artsCreativity = 'arts_creativity';
  static const String outdoorsAdventure = 'outdoors_adventure';
  static const String socialExperiences = 'social_experiences';
  static const String foodsLifestyle = 'foods_lifestyle';
}

class MockQuestData {
  MockQuestData._();

  static const List<QuestCategory> categories = [
    QuestCategory(
      id: CategoryIds.mediaEntertainment,
      name: 'Media &\nentertainment',
      color: AppColors.mediaEntertainment,
      glyph: QuestGlyph.clapperboard,
    ),
    QuestCategory(
      id: CategoryIds.learningDiscovery,
      name: 'Learning &\ndiscovery',
      color: AppColors.learningDiscovery,
      glyph: QuestGlyph.brain,
    ),
    QuestCategory(
      id: CategoryIds.healthFitness,
      name: 'Health &\nFitness',
      color: AppColors.healthFitness,
      glyph: QuestGlyph.dumbbell,
    ),
    QuestCategory(
      id: CategoryIds.artsCreativity,
      name: 'Arts &\nCreativity',
      color: AppColors.artsCreativity,
      glyph: QuestGlyph.swatches,
    ),
    QuestCategory(
      id: CategoryIds.outdoorsAdventure,
      name: 'Outdoors &\nAdventure',
      color: AppColors.outdoorsAdventure,
      glyph: QuestGlyph.mountain,
    ),
    QuestCategory(
      id: CategoryIds.socialExperiences,
      name: 'Social &\nExperiences',
      color: AppColors.socialExperiences,
      glyph: QuestGlyph.people,
    ),
    QuestCategory(
      id: CategoryIds.foodsLifestyle,
      name: 'Foods &\nLifestyle',
      color: AppColors.foodsLifestyle,
      glyph: QuestGlyph.dining,
    ),
  ];

  static const List<Quest> quests = [
    Quest(
      id: 'q_director',
      title: "Watch a movie from a director you've never seen",
      categoryId: CategoryIds.mediaEntertainment,
      achievementLabel: 'DIRECTOR DISCOVERER',
      description:
          'Pick a director whose work you have never watched and finish one of their films from start to end.',
      glyph: QuestGlyph.clapperboard,
    ),
    Quest(
      id: 'q_album',
      title: 'Listen to an album from start to finish',
      categoryId: CategoryIds.learningDiscovery,
      achievementLabel: 'ALBUM LISTENER',
      description:
          'Choose an album you have never fully heard and listen to every track without skipping.',
      glyph: QuestGlyph.brain,
    ),
    Quest(
      id: 'q_motion',
      title: 'Create a motion graphic',
      categoryId: CategoryIds.artsCreativity,
      achievementLabel: 'DESIGNER',
      description:
          'Design a short motion graphic, even a simple loop, using any tool you already have.',
      glyph: QuestGlyph.swatches,
    ),
    Quest(
      id: 'q_street_photo',
      title: 'Try street photography',
      categoryId: CategoryIds.artsCreativity,
      achievementLabel: 'PHOTOGRAPHER',
      description:
          'Go outside and capture candid moments, textures, or people in public spaces.',
      glyph: QuestGlyph.camera,
    ),
    Quest(
      id: 'q_unfamiliar',
      title: 'Learn about an unfamiliar subject',
      categoryId: CategoryIds.learningDiscovery,
      achievementLabel: 'KNOWLEDGE SEEKER',
      description:
          'Spend focused time reading or watching something about a topic you know almost nothing about.',
      glyph: QuestGlyph.book,
    ),
    Quest(
      id: 'q_new_place',
      title: "Visit a place you've never been",
      categoryId: CategoryIds.outdoorsAdventure,
      achievementLabel: 'TRAVELER',
      description:
          'Go to a neighborhood, park, or landmark you have never visited and spend time exploring it.',
      glyph: QuestGlyph.mountain,
    ),
    Quest(
      id: 'q_get_together',
      title: 'Plan a get-together',
      categoryId: CategoryIds.socialExperiences,
      achievementLabel: 'HOST',
      description:
          'Invite people you care about and organize a simple gathering, online or in person.',
      glyph: QuestGlyph.people,
    ),
    Quest(
      id: 'q_concert',
      title: 'Attend a concert',
      categoryId: CategoryIds.socialExperiences,
      achievementLabel: 'CONCERT GOER',
      description:
          'Go see live music, whether a stadium show, a local gig, or a campus performance.',
      glyph: QuestGlyph.ticket,
    ),
    Quest(
      id: 'q_foreign_film',
      title: 'Watch a film in a language you do not speak',
      categoryId: CategoryIds.mediaEntertainment,
      achievementLabel: 'WORLD CINEMA',
      description:
          'Finish a full movie originally made in a language you are not fluent in.',
      glyph: QuestGlyph.clapperboard,
    ),
    Quest(
      id: 'q_playlist',
      title: 'Build a playlist for a rainy afternoon',
      categoryId: CategoryIds.mediaEntertainment,
      achievementLabel: 'CURATOR',
      description:
          'Collect tracks that fit one mood and listen to the finished playlist in order.',
      glyph: QuestGlyph.music,
    ),
    Quest(
      id: 'q_science',
      title: 'Read a short article on a new science topic',
      categoryId: CategoryIds.learningDiscovery,
      achievementLabel: 'CURIOUS MIND',
      description:
          'Pick a science subject outside your usual interests and read one complete article.',
      glyph: QuestGlyph.book,
    ),
    Quest(
      id: 'q_gym',
      title: 'Do a full gym session',
      categoryId: CategoryIds.healthFitness,
      achievementLabel: 'TRAINEE',
      description:
          'Complete a planned workout with a warm-up, main set, and cool-down.',
      glyph: QuestGlyph.dumbbell,
    ),
    Quest(
      id: 'q_yoga',
      title: 'Try a 20-minute yoga flow',
      categoryId: CategoryIds.healthFitness,
      achievementLabel: 'STRETCHED',
      description:
          'Follow a short yoga sequence and stay with it until the session ends.',
      glyph: QuestGlyph.dumbbell,
    ),
    Quest(
      id: 'q_sketch',
      title: 'Sketch something you can see from your window',
      categoryId: CategoryIds.artsCreativity,
      achievementLabel: 'OBSERVER',
      description:
          'Draw a scene, object, or person you can actually see right now. Keep it simple.',
      glyph: QuestGlyph.swatches,
    ),
    Quest(
      id: 'q_sunrise',
      title: 'Take a sunrise walk',
      categoryId: CategoryIds.outdoorsAdventure,
      achievementLabel: 'EARLY EXPLORER',
      description:
          'Go outside around sunrise and walk without headphones for at least 20 minutes.',
      glyph: QuestGlyph.mountain,
    ),
    Quest(
      id: 'q_call_friend',
      title: "Call a friend you haven't talked to in a while",
      categoryId: CategoryIds.socialExperiences,
      achievementLabel: 'RECONNECTOR',
      description:
          'Reach out with a real conversation, not just a short chat message.',
      glyph: QuestGlyph.people,
    ),
    Quest(
      id: 'q_new_dish',
      title: 'Cook a dish from another country',
      categoryId: CategoryIds.foodsLifestyle,
      achievementLabel: 'HOME CHEF',
      description:
          'Prepare a meal from a cuisine you do not usually cook at home.',
      glyph: QuestGlyph.dining,
    ),
    Quest(
      id: 'q_new_cafe',
      title: 'Try a cafe you have never visited',
      categoryId: CategoryIds.foodsLifestyle,
      achievementLabel: 'LOCAL TASTER',
      description:
          'Sit down at a new cafe, order something, and stay long enough to notice the place.',
      glyph: QuestGlyph.dining,
    ),
  ];

  static const List<QuestGroup> recommendedGroups = [
    QuestGroup(
      id: 'rec_media',
      description: 'Because you seem to enjoy\nEntertainment & Media',
      questIds: ['q_director', 'q_album', 'q_foreign_film', 'q_playlist'],
    ),
    QuestGroup(
      id: 'rec_making',
      description: 'Because you enjoy making things',
      questIds: ['q_motion', 'q_street_photo', 'q_sketch'],
    ),
  ];

  static const List<QuestGroup> discoverGroups = [
    QuestGroup(
      id: 'disc_new',
      description: 'Explore something new',
      questIds: ['q_unfamiliar', 'q_new_place', 'q_science', 'q_sunrise'],
    ),
    QuestGroup(
      id: 'disc_together',
      description: 'Bring someone along',
      questIds: ['q_get_together', 'q_concert', 'q_call_friend'],
    ),
  ];
}
