import 'package:blog_app/core/core.dart';
import 'package:flutter/material.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.customTheme.contentPrimary,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
