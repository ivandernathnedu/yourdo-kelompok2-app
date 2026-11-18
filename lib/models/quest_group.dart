class QuestGroup {
  const QuestGroup({
    required this.id,
    required this.description,
    required this.questIds,
    this.initialVisibleCount = 2,
  });

  final String id;
  final String description;
  final List<String> questIds;
  final int initialVisibleCount;
}
