import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text(
          '$title page coming soon',
          style: AppTextStyles.sectionTitle.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
