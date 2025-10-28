import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DangerZoneSection extends StatefulWidget {
  const DangerZoneSection({super.key});

  @override
  State<DangerZoneSection> createState() => _DangerZoneSectionState();
}

class _DangerZoneSectionState extends State<DangerZoneSection> {
  void showDeleteAccountDialog() {
    String deleteConfirmation = '';
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: context.customTheme.surface,
          title: Row(
            children: [
              Icon(Icons.warning, color: context.customTheme.info),

              AppGaps.gapW8,

              Text('Delete Account', style: context.textTheme.titleSmall),
            ],
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to permanently delete your account?',
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              AppGaps.gapH12,

              const Text('This action will:'),

              AppGaps.gapH8,

              const Text('• Delete all your data permanently'),

              const Text('• Remove access to all your blogs'),

              const Text('• Cannot be undone'),

              AppGaps.gapH12,

              Text(
                'Type "DELETE" to confirm:',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.customTheme.error,
                ),
              ),

              AppGaps.gapH8,

              TextField(
                onChanged: (value) {
                  setState(() {
                    deleteConfirmation = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Type DELETE here',
                  border: const OutlineInputBorder(),
                  errorText:
                      deleteConfirmation.isNotEmpty &&
                          deleteConfirmation != 'DELETE'
                      ? 'Must type exactly "DELETE"'
                      : null,
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.customTheme.success,
                ),
              ),
            ),

            TextButton(
              onPressed: deleteConfirmation == 'DELETE'
                  ? () {
                      Navigator.pop(context);
                      showFinalDeleteConfirmation();
                    }
                  : null, // Disabled when not "DELETE"
              style: TextButton.styleFrom(
                foregroundColor: deleteConfirmation == 'DELETE'
                    ? context.customTheme.error
                    : Theme.of(context).disabledColor,
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  void showFinalDeleteConfirmation() async {
    bool confirmed = await DialogUtils.showConfirmationDialog(
      context,
      title: 'Final Confirmation',
      message:
          '⚠️ LAST WARNING\n\nYou typed "DELETE" to confirm. Your account will be permanently deleted and cannot be recovered.\n\nAre you absolutely sure you want to proceed?',
      confirmText: 'Yes, Delete Forever',
    );

    if (confirmed && mounted) {
      context.read<AccountBloc>().add(AccountDeleteRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        border: Border.all(
          color: context.customTheme.error.withValues(alpha: 0.5),
        ),
        borderRadius: AppBorderRadius.largeBorderRadius,
        color: context.customTheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_outlined, color: context.customTheme.error),

              AppGaps.gapW8,

              Text(
                'Danger Zone',
                style: context.textTheme.titleSmall?.copyWith(
                  color: context.customTheme.error,
                ),
              ),
            ],
          ),

          AppGaps.gapH12,

          Text(
            'Once you delete your account, there is no going back. Please be certain.',
            style: context.textTheme.bodySmall,
          ),

          AppGaps.gapH12,

          CustomButton(
            label: 'Delete Account',
            onTap: showDeleteAccountDialog,
            bgColor: context.customTheme.error,
            textColor: context.customTheme.background,
            borderRadius: AppBorderRadius.mediumBorderRadius,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            icon: Icon(
              Icons.delete_forever,
              color: context.customTheme.background,
            ),
          ),
        ],
      ),
    );
  }
}
