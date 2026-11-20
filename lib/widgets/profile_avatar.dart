import 'dart:convert';
import 'dart:io';

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
      child: _hasPhoto ? _buildImage(photoUrl!) : _Placeholder(size: size),
    );
  }

  Widget _buildImage(String source) {
    if (source.startsWith('data:image')) {
      try {
        final bytes = base64Decode(source.split(',').last);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _Placeholder(size: size),
        );
      } catch (_) {
        return _Placeholder(size: size);
      }
    }

    if (source.startsWith('http://') || source.startsWith('https://')) {
      return Image.network(
        source,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _Placeholder(size: size),
      );
    }

    if (!source.startsWith('Assets/') && File(source).existsSync()) {
      return Image.file(
        File(source),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _Placeholder(size: size),
      );
    }

    return Image.asset(
      source,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => _Placeholder(size: size),
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
