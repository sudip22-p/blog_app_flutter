import 'package:blog_app/common/widgets/custom_app_bar.dart';
import 'package:blog_app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorScreen extends StatelessWidget {
  final String error;
  final String location;

  const ErrorScreen({super.key, required this.error, required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        showBackButton: true,
        title: Text(
          "Error",
          style: context.textTheme.headlineSmall?.copyWith(
            color: context.customTheme.contentPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red, size: 60),
              SizedBox(height: 20),
              Text('Navigation Error', style: context.textTheme.headlineSmall),
              SizedBox(height: 20),
              Text(
                'Error: $error',
                style: context.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Failed location: $location',
                style: context.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Navigate back
                  context.pop();
                },
                child: Text('Go back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
