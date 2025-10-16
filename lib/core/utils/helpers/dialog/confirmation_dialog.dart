import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:blog_app/common/themes/typography/font_weight.dart';
import 'package:blog_app/core/core.dart';

//for showing the alert dialog in the app for confirmation. Will return true if confirmed, false if cancelled
class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    required this.title,
    required this.message,
    required this.confirmText,
    this.showCancelButton,
    super.key,
  });

  final String title;
  final String message;
  final String confirmText;
  final bool? showCancelButton;

  @override
  Widget build(BuildContext context) {
    return !kIsWeb && Platform.isIOS
        ? _IosConfirmationDialog(
            title: title,
            message: message,
            confirmText: confirmText,
            showCancelButton: showCancelButton ?? true,
          )
        : _AndroidConfirmationDialog(
            title: title,
            message: message,
            confirmText: confirmText,
            showCancelButton: showCancelButton ?? true,
          );
  }
}

class _AndroidConfirmationDialog extends StatelessWidget {
  const _AndroidConfirmationDialog({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.showCancelButton,
  });

  final String title;
  final String message;
  final String confirmText;
  final bool showCancelButton;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: context.textTheme.bodyLarge?.copyWith(
          fontWeight: AppFontWeight.bold,
        ),
      ),
      content: Text(
        message,
        textAlign: TextAlign.justify,
        style: context.textTheme.bodyMedium?.copyWith(
          fontWeight: AppFontWeight.regular,
        ),
      ),
      actions: [
        if (showCancelButton)
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: context.colorScheme.onSurface,
            ),
            onPressed: () => context.pop(),
            child: Text(
              'Cancel',
              style: context.textTheme.bodySmall?.copyWith(
                fontWeight: AppFontWeight.semiBold,
              ),
            ),
          ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: context.colorScheme.onSurface,
          ),
          onPressed: () => context.pop(true),
          child: Text(
            confirmText,
            style: context.textTheme.bodySmall?.copyWith(
              fontWeight: AppFontWeight.semiBold,
            ),
          ),
        ),
      ],
    );
  }
}

class _IosConfirmationDialog extends StatelessWidget {
  const _IosConfirmationDialog({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.showCancelButton,
  });

  final String title;
  final String message;
  final String confirmText;
  final bool showCancelButton;

  @override
  Widget build(BuildContext context) {
    const OutlinedBorder buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    );

    return CupertinoAlertDialog(
      title: Text(
        title,
        style: context.textTheme.bodyLarge?.copyWith(
          fontWeight: AppFontWeight.bold,
        ),
      ),
      content: Text(
        message,
        textAlign: TextAlign.left,
        style: context.textTheme.bodyMedium?.copyWith(
          fontWeight: AppFontWeight.regular,
        ),
      ),
      actions: [
        if (showCancelButton)
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: context.colorScheme.onSurface,
              shape: buttonShape,
            ),
            onPressed: () => context.pop(),
            child: Text(
              'Cancel',
              style: context.textTheme.bodySmall?.copyWith(
                fontWeight: AppFontWeight.semiBold,
              ),
            ),
          ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: context.colorScheme.onSurface,
            shape: buttonShape,
          ),
          onPressed: () => context.pop(true),
          child: Text(
            confirmText,
            style: context.textTheme.bodySmall?.copyWith(
              fontWeight: AppFontWeight.semiBold,
            ),
          ),
        ),
      ],
    );
  }
}
