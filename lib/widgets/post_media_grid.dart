import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';

class PostMediaGrid extends StatelessWidget {
  const PostMediaGrid({super.key, required this.mediaUrls});

  final List<String> mediaUrls;

  @override
  Widget build(BuildContext context) {
    if (mediaUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    if (mediaUrls.length == 1) {
      return _MediaTile(source: mediaUrls.first, aspectRatio: 16 / 9);
    }

    final rows = <Widget>[];
    for (var i = 0; i < mediaUrls.length; i += 2) {
      final left = mediaUrls[i];
      final right = i + 1 < mediaUrls.length ? mediaUrls[i + 1] : null;
      rows.add(
        Padding(
          padding: EdgeInsets.only(
            bottom: i + 2 < mediaUrls.length ? AppDimens.mediaGap : 0,
          ),
          child: Row(
            children: [
              Expanded(child: _MediaTile(source: left)),
              const SizedBox(width: AppDimens.mediaGap),
              Expanded(
                child: right == null
                    ? const SizedBox.shrink()
                    : _MediaTile(source: right),
              ),
            ],
          ),
        ),
      );
    }

    return Column(children: rows);
  }
}

class _MediaTile extends StatelessWidget {
  const _MediaTile({
    required this.source,
    this.aspectRatio = 1,
  });

  final String source;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.questCardRadius),
        child: ColoredBox(
          color: AppColors.questButton,
          child: Image.asset(
            source,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}
