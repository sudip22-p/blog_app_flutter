import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DangerZoneSection extends StatefulWidget {
  final ColorScheme colorScheme;
  const DangerZoneSection({super.key, required this.colorScheme});

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
          title: Row(
            children: [
              Icon(Icons.warning, color: Theme.of(context).colorScheme.error),
              const SizedBox(width: 8),
              const Text('Delete Account'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Are you sure you want to permanently delete your account?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text('This action will:'),
              const SizedBox(height: 8),
              const Text('• Delete all your data permanently'),
              const Text('• Remove access to all your blogs'),
              const Text('• Cannot be undone'),
              const SizedBox(height: 12),
              Text(
                'Type "DELETE" to confirm:',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
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
              child: const Text('Cancel'),
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
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).disabledColor,
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  void showFinalDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.dangerous, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 8),
            const Text('Final Confirmation'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '⚠️ LAST WARNING',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'You typed "DELETE" to confirm. Your account will be permanently deleted and cannot be recovered.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Are you absolutely sure you want to proceed?',
              style: TextStyle(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(AuthDeleteAccountRequested());
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Yes, Delete Forever'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = widget.colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.error.withAlpha(128)),
        borderRadius: BorderRadius.circular(8),
        color: colorScheme.errorContainer.withAlpha(128),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning, color: colorScheme.error),
              const SizedBox(width: 8),
              Text(
                'Danger Zone',
                style: TextStyle(
                  color: colorScheme.error,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Once you delete your account, there is no going back. Please be certain.',
            style: TextStyle(color: colorScheme.onErrorContainer, fontSize: 12),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: showDeleteAccountDialog,
              icon: const Icon(Icons.delete_forever),
              label: const Text('Delete Account'),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.error,
                side: BorderSide(color: colorScheme.error.withAlpha(128)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
