import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.size,
    this.photoUrl,
  });

  final double size;
  final String? photoUrl;

  bool get _hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;

  bool get _isNetwork {
    final source = photoUrl;
    if (source == null) return false;
    return source.startsWith('http://') || source.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.backButton,
        border: Border.all(color: AppColors.divider, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: _hasPhoto
          ? (_isNetwork
                ? Image.network(
                    photoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _Placeholder(size: size),
                  )
                : Image.asset(
                    photoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _Placeholder(size: size),
                  ))
          : _Placeholder(size: size),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.person_rounded,
      size: size * 0.52,
      color: AppColors.textSecondary,
    );
  }
}
