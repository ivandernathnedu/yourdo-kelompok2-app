import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';

class ProfileDescription extends StatelessWidget {
  const ProfileDescription({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: AppTextStyles.profileBio,
      ),
    );
  }
}
