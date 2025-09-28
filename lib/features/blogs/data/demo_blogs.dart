import 'package:blog_app/features/blogs/data/models/blog.dart';

// final List<Blog> demoBlogs = [];
final List<Blog> demoBlogs = [
  Blog(
    id: '1',
    title: 'Getting Started with Flutter',
    content:
        'Flutter is Google’s UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase. In this blog, we’ll cover the basics of setting up your first Flutter project...',
    authorId: 'u101',
    authorName: 'Sudip Paudel',
    coverImageUrl: 'https://picsum.photos/seed/flutter/600/300',
    tags: ['flutter', 'mobile', 'beginner'],
    createdAt: DateTime(2025, 9, 1, 10, 30),
    lastUpdatedAt: DateTime(2025, 9, 1, 12, 0),
  ),
  Blog(
    id: '2',
    title: 'State Management in Flutter',
    content:
        'Choosing the right state management approach is crucial in Flutter apps. Options like Provider, Riverpod, and Bloc all serve different needs. In this article, we’ll compare them with examples...',
    authorId: 'u102',
    authorName: 'Aarav Shrestha',
    coverImageUrl: 'https://picsum.photos/seed/state/600/300',
    tags: ['flutter', 'state-management'],
    createdAt: DateTime(2025, 9, 5, 14, 0),
    lastUpdatedAt: DateTime(2025, 9, 6, 9, 15),
  ),
  Blog(
    id: '3',
    title: 'Firebase Integration Made Easy',
    content:
        'Integrating Firebase with Flutter provides authentication, cloud storage, real-time database, and more. In this blog, we’ll set up Firebase step-by-step with code snippets...',
    authorId: 'u101',
    authorName: 'Sudip Paudel',
    coverImageUrl: 'https://picsum.photos/seed/firebase/600/300',
    tags: ['firebase', 'flutter', 'backend'],
    createdAt: DateTime(2025, 9, 10, 8, 45),
    lastUpdatedAt: DateTime(2025, 9, 10, 10, 20),
  ),
];
