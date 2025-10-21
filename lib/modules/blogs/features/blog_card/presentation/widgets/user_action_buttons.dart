import 'package:blog_app/common/widgets/buttons/app_button.dart';
import 'package:blog_app/core/core.dart';
import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ActionButtons({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onEdit != null)
          Expanded(
            child: CustomButton.outlined(
              onTap: onEdit,
              label: 'Edit',
              textColor: context.customTheme.primary,
              border: Border.all(
                color: context.customTheme.primary,
                width: AppSpacing.xxs,
              ),
              borderRadius: AppBorderRadius.mediumBorderRadius,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              icon: Icon(
                Icons.edit_rounded,
                color: context.customTheme.primary,
              ),
              gap: AppGaps.gapW8,
              iconPosition: IconAlignment.start,
            ),
          ),

        if (onEdit != null && onDelete != null) AppGaps.gapW16,

        if (onDelete != null)
          Expanded(
            child: CustomButton.outlined(
              onTap: onDelete,
              label: 'Delete',
              textColor: context.customTheme.error,
              border: Border.all(
                color: context.customTheme.error,
                width: AppSpacing.xxs,
              ),
              borderRadius: AppBorderRadius.mediumBorderRadius,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              icon: Icon(
                Icons.delete_outline_rounded,
                color: context.customTheme.error,
              ),
              gap: AppGaps.gapW8,
              iconPosition: IconAlignment.start,
            ),
          ),
      ],
    );
  }
}
