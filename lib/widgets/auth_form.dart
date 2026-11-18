import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AuthForm extends StatelessWidget {
  const AuthForm({
    super.key,
    required this.title,
    required this.actionLabel,
    required this.footerPrompt,
    required this.footerActionLabel,
    required this.usernameController,
    required this.passwordController,
    required this.showPassword,
    required this.onToggleShowPassword,
    required this.onSubmit,
    required this.onFooterTap,
    required this.isLoading,
    this.statusMessage,
    this.isError = false,
    this.usernameError,
    this.passwordError,
  });

  final String title;
  final String actionLabel;
  final String footerPrompt;
  final String footerActionLabel;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool showPassword;
  final ValueChanged<bool?> onToggleShowPassword;
  final VoidCallback onSubmit;
  final VoidCallback onFooterTap;
  final bool isLoading;
  final String? statusMessage;
  final bool isError;
  final String? usernameError;
  final String? passwordError;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFF243244),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 36, 22, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.profileName.copyWith(
                      fontSize: 26,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _AuthField(
                    controller: usernameController,
                    hint: 'Email/username',
                    icon: Icons.person_outline_rounded,
                    enabled: !isLoading,
                    errorText: usernameError,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 14),
                  _AuthField(
                    controller: passwordController,
                    hint: 'Password',
                    icon: Icons.lock_outline_rounded,
                    enabled: !isLoading,
                    obscureText: !showPassword,
                    errorText: passwordError,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => onSubmit(),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: isLoading
                          ? null
                          : () => onToggleShowPassword(!showPassword),
                      borderRadius: BorderRadius.circular(6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: Checkbox(
                              value: showPassword,
                              onChanged: isLoading ? null : onToggleShowPassword,
                              side: const BorderSide(
                                color: AppColors.textSecondary,
                                width: 1.4,
                              ),
                              fillColor: WidgetStateProperty.resolveWith((
                                states,
                              ) {
                                if (states.contains(WidgetState.selected)) {
                                  return AppColors.questButton;
                                }
                                return Colors.transparent;
                              }),
                              checkColor: AppColors.textPrimary,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Show password',
                            style: AppTextStyles.profileMeta.copyWith(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (statusMessage != null) ...[
                    const SizedBox(height: 14),
                    Text(
                      statusMessage!,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.profileMeta.copyWith(
                        fontSize: 13,
                        color: isError
                            ? const Color(0xFFFF8A9A)
                            : AppColors.randomizeGlow,
                      ),
                    ),
                  ],
                  const SizedBox(height: 22),
                  SizedBox(
                    width: 148,
                    height: 44,
                    child: FilledButton(
                      onPressed: isLoading ? null : onSubmit,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF4A6784),
                        disabledBackgroundColor: const Color(0xFF3A5066),
                        foregroundColor: AppColors.textPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: AppColors.textPrimary,
                              ),
                            )
                          : Text(
                              actionLabel,
                              style: AppTextStyles.profileUsername.copyWith(
                                fontFamily: AppTextStyles.clashGrotesk,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                letterSpacing: 0.8,
                                color: AppColors.textPrimary,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        footerPrompt,
                        style: AppTextStyles.profileMeta.copyWith(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: isLoading ? null : onFooterTap,
                        child: Text(
                          footerActionLabel,
                          style: AppTextStyles.profileMeta.copyWith(
                            fontFamily: AppTextStyles.clashGrotesk,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.enabled,
    this.obscureText = false,
    this.errorText,
    this.textInputAction,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool enabled;
  final bool obscureText;
  final String? errorText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      style: AppTextStyles.detailBody.copyWith(fontSize: 14),
      cursorColor: AppColors.textPrimary,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.profileMeta.copyWith(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
        errorText: errorText,
        errorStyle: AppTextStyles.profileMeta.copyWith(
          fontSize: 11,
          color: const Color(0xFFFF8A9A),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(
            color: AppColors.textSecondary.withValues(alpha: 0.55),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: AppColors.textPrimary),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(
            color: AppColors.textSecondary.withValues(alpha: 0.3),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Color(0xFFFF8A9A)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Color(0xFFFF8A9A)),
        ),
      ),
    );
  }
}
