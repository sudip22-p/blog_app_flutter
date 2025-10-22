import 'package:blog_app/common/common.dart';
import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/blogs/data/models/blog.dart';
import 'package:blog_app/modules/blogs/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/modules/blogs/features/explore_all_blogs/presentation/widgets/app_search_bar.dart';
import 'package:blog_app/modules/blogs/features/blog_card/presentation/view/blog_card.dart';
import 'package:blog_app/modules/blogs/features/explore_all_blogs/presentation/widgets/filter_chip_bar.dart';
import 'package:blog_app/modules/blogs/features/explore_all_blogs/presentation/widgets/pagination_controls.dart';
import 'package:blog_app/modules/blogs/features/explore_all_blogs/presentation/widgets/results_info.dart';
import 'package:blog_app/modules/blogs/presentation/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ExploreBlogsScreen extends StatefulWidget {
  const ExploreBlogsScreen({super.key});

  @override
  State<ExploreBlogsScreen> createState() => _ExploreBlogsScreenState();
}

class _ExploreBlogsScreenState extends State<ExploreBlogsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Blog> _allBlogs = [];
  List<Blog> _filteredBlogs = [];

  String _searchQuery = '';
  String? _selectedTag;
  int _currentPage = 1;
  final int _itemsPerPage = 8;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.trim();
      _currentPage = 1;
      _filterBlogs();
    });
  }

  void _selectTag(String? tag) {
    setState(() {
      _selectedTag = tag;
      _currentPage = 1;
      _filterBlogs();
    });
  }

  void _filterBlogs() {
    _filteredBlogs = _allBlogs.where((blog) {
      final q = _searchQuery.toLowerCase();
      final matchesSearch =
          q.isEmpty ||
          blog.title.toLowerCase().contains(q) ||
          blog.content.toLowerCase().contains(q) ||
          blog.authorName.toLowerCase().contains(q);
      final matchesTag =
          _selectedTag == null || blog.tags.contains(_selectedTag);
      return matchesSearch && matchesTag;
    }).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<Blog> _getCurrentPageBlogs() {
    final start = (_currentPage - 1) * _itemsPerPage;
    final end = start + _itemsPerPage;
    return _filteredBlogs.sublist(start, end.clamp(0, _filteredBlogs.length));
  }

  int get _totalPages => (_filteredBlogs.length / _itemsPerPage).ceil();

  void _loadNextPage() async {
    if (_currentPage >= _totalPages || _isLoading) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() {
      _currentPage++;
      _isLoading = false;
    });
  }

  void _loadPreviousPage() {
    if (_currentPage > 1) setState(() => _currentPage--);
  }

  List<String> _getAvailableTags() {
    // counting frequency of each tag
    final tagCount = <String, int>{};
    for (var blog in _allBlogs) {
      for (var tag in blog.tags) {
        tagCount[tag] = (tagCount[tag] ?? 0) + 1;
      }
    }
    // sorting by frequency (descending)
    final sortedTags = tagCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    // taking top 8
    final topTags = sortedTags.take(8).map((e) => e.key).toList();
    return topTags;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: Text(
          "Explore Blogs",
          style: context.textTheme.titleLarge?.copyWith(
            color: context.customTheme.primary,
          ),
        ),
        backgroundColor: context.customTheme.surface,
      ),
      backgroundColor: context.customTheme.background,
      body: BlocBuilder<BlogBloc, BlogState>(
        builder: (context, state) {
          if (state is BlogInitial) {
            context.read<BlogBloc>().add(BlogsLoaded());
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BlogLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BlogOperationFailure) {
            return EmptyState(
              icon: Icons.error,
              title: 'Failed to Fetch Blogs!',
              message: state.errorMessage,
              buttonText: 'Retry',
              onButtonPressed: () {
                context.read<BlogBloc>().add(BlogsLoaded());
              },
            );
          }

          if (state is BlogLoadSuccess) {
            _allBlogs = state.blogs;
            _filterBlogs();
          }
          if (state is BlogOperationSuccess) {
            _allBlogs = state.blogs;
            _filterBlogs();
          }

          final visibleBlogs = _getCurrentPageBlogs();
          final tags = _getAvailableTags();

          return Column(
            children: [
              AppSearchBar(
                controller: _searchController,
                searchQuery: _searchQuery,
                onClear: () => _searchController.clear(),
              ),

              AppGaps.gapH8,

              FilterChipBar(
                availableTags: tags,
                selectedTag: _selectedTag,
                onTagSelected: _selectTag,
              ),

              AppGaps.gapH4,

              ResultsInfo(
                totalResults: _filteredBlogs.length,
                currentPage: _currentPage,
                totalPages: _totalPages,
                searchQuery: _searchQuery,
                selectedTag: _selectedTag,
              ),

              AppGaps.gapH8,

              Expanded(
                child: visibleBlogs.isEmpty
                    ? EmptyState(
                        icon: Icons.error,
                        title: 'Blogs Not Found',
                        message:
                            "Blogs are not available for '$_searchQuery'.Search sth different or clear filter for blogs.",
                        buttonText: 'Clear Filter',
                        onButtonPressed: () {
                          _searchController.clear();
                        },
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        itemCount: visibleBlogs.length,
                        itemBuilder: (context, index) {
                          final blog = visibleBlogs[index];
                          return BlogCard(
                            blog: blog,
                            onTap: () => {
                              context.pushNamed(
                                Routes.blogDetails.name,
                                extra: blog,
                              ),
                            },
                          );
                        },
                      ),
              ),

              if (_totalPages > 1)
                PaginationControls(
                  currentPage: _currentPage,
                  totalPages: _totalPages,
                  isLoading: _isLoading,
                  onPreviousPage: _loadPreviousPage,
                  onNextPage: _loadNextPage,
                ),
            ],
          );
        },
      ),
    );
  }
}
