import 'package:flutter/material.dart';

import '../models/quest.dart';
import '../models/quest_category.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import 'quest_card.dart';
import 'show_more_button.dart';

class QuestGroupBlock extends StatefulWidget {
  const QuestGroupBlock({
    super.key,
    required this.description,
    required this.quests,
    required this.categoryOf,
    required this.onQuestTap,
    this.initialVisibleCount = 2,
  });

  final String description;
  final List<Quest> quests;
  final QuestCategory Function(Quest quest) categoryOf;
  final ValueChanged<Quest> onQuestTap;
  final int initialVisibleCount;

  @override
  State<QuestGroupBlock> createState() => _QuestGroupBlockState();
}

class _QuestGroupBlockState extends State<QuestGroupBlock> {
  late int _visibleCount;

  @override
  void initState() {
    super.initState();
    _visibleCount = widget.initialVisibleCount;
  }

  @override
  void didUpdateWidget(covariant QuestGroupBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialVisibleCount != widget.initialVisibleCount) {
      _visibleCount = widget.initialVisibleCount;
    }
  }

  bool get _isExpanded => _visibleCount >= widget.quests.length;

  void _toggleExpanded() {
    setState(() {
      _visibleCount = _isExpanded
          ? widget.initialVisibleCount
          : widget.quests.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final collapsedCount = widget.initialVisibleCount;
    final visible = widget.quests.take(_visibleCount).toList();
    final canToggle = widget.quests.length > collapsedCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.description, style: AppTextStyles.groupDescription),
        const SizedBox(height: 8),
        for (var i = 0; i < visible.length; i++) ...[
          QuestCard(
            quest: visible[i],
            category: widget.categoryOf(visible[i]),
            onTap: () => widget.onQuestTap(visible[i]),
          ),
          if (i != visible.length - 1) const SizedBox(height: AppDimens.itemGap),
        ],
        if (canToggle) ...[
          const SizedBox(height: 4),
          ShowMoreButton(
            onPressed: _toggleExpanded,
            expanded: _isExpanded,
          ),
        ],
      ],
    );
  }
}
