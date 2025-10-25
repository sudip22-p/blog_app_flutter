import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/core.dart';
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: context.customTheme.background,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: AppSpacing.xxxlg,
              color: context.customTheme.contentSurface,
            ),
          ),

          AppGaps.gapH16,

          Text(
            title,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          AppGaps.gapH12,

          Text(
            message,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.customTheme.contentPrimary,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),

          if (buttonText != null && onButtonPressed != null) ...[
            AppGaps.gapH16,

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 120),
              child: CustomButton.outlined(
                onTap: onButtonPressed,
                label: buttonText!,
                textColor: context.customTheme.secondary,
                border: Border.all(
                  color: context.customTheme.secondary,
                  width: AppSpacing.xxs,
                ),
                borderRadius: AppBorderRadius.mediumBorderRadius,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  color: context.customTheme.secondary,
                ),
                gap: AppGaps.gapW8,
                iconPosition: IconAlignment.start,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
