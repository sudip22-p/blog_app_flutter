import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/blogs/data/models/blog.dart';
import 'package:blog_app/modules/blogs/presentation/bloc/blog/blog_bloc.dart';
import 'package:blog_app/modules/blogs/presentation/screens/blog_preview_screen.dart';
import 'package:blog_app/modules/blogs/presentation/widgets/app_search_bar.dart';
import 'package:blog_app/modules/blogs/presentation/widgets/blog_card.dart';
import 'package:blog_app/modules/blogs/presentation/widgets/explore_empty_state.dart';
import 'package:blog_app/modules/blogs/presentation/widgets/filter_chip_bar.dart';
import 'package:blog_app/modules/blogs/presentation/widgets/pagination_controls.dart';
import 'package:blog_app/modules/blogs/presentation/widgets/results_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExploreBlogsScreen extends StatefulWidget {
  const ExploreBlogsScreen({super.key});

  @override
  State<ExploreBlogsScreen> createState() => _ExploreBlogsScreenState();
}

class _ExploreBlogsScreenState extends State<ExploreBlogsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedTag;
  int _currentPage = 1;
  final int _itemsPerPage = 8;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  bool _showPagination = false;

  late List<Blog> _allBlogs;
  late List<Blog> _filteredBlogs;

  @override
  void initState() {
    super.initState();
    _allBlogs = [];
    _filteredBlogs = _allBlogs;
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _currentPage = 1;
      _filterBlogs();
    });
  }

  void _openBlog(Blog blog) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BlogPreviewScreen(blog: blog)),
    );
  }

  void _onScroll() {
    // Show pagination when user scrolls near the bottom
    final scrollPosition = _scrollController.position;
    final showPagination =
        scrollPosition.pixels > (scrollPosition.maxScrollExtent * 0.7);

    if (showPagination != _showPagination) {
      setState(() {
        _showPagination = showPagination;
      });
    }
  }

  void _filterBlogs() {
    _filteredBlogs = _allBlogs.where((blog) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          blog.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          blog.content.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          blog.authorName.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesTag =
          _selectedTag == null || blog.tags.contains(_selectedTag);

      return matchesSearch && matchesTag;
    }).toList();
    _filteredBlogs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  void _selectTag(String? tag) {
    setState(() {
      _selectedTag = tag;
      _currentPage = 1;
      _filterBlogs();
    });
  }

  List<Blog> _getCurrentPageBlogs() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;

    if (startIndex >= _filteredBlogs.length) return [];

    return _filteredBlogs.sublist(
      startIndex,
      endIndex > _filteredBlogs.length ? _filteredBlogs.length : endIndex,
    );
  }

  int get _totalPages => (_filteredBlogs.length / _itemsPerPage).ceil();

  void _loadNextPage() async {
    if (_currentPage >= _totalPages || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      if (mounted) {
        setState(() {
          _currentPage++;
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load page: ${error.toString()}'),
            backgroundColor: context.customTheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  void _loadPreviousPage() {
    if (_currentPage <= 1 || _isLoading) return;

    setState(() {
      _currentPage--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme.background,
      body: BlocBuilder<BlogBloc, BlogState>(
        builder: (context, state) {
          // Handle initial state and trigger blog loading
          if (state is BlogInitial) {
            context.read<BlogBloc>().add(BlogsLoaded());
            return const Center(child: CircularProgressIndicator());
          }

          // Handle loading state
          if (state is BlogLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle error state
          if (state is BlogOperationFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: context.customTheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading blogs',
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.errorMessage,
                    style: context.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<BlogBloc>().add(BlogsLoaded());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Handle success states
          List<Blog> blogs = [];
          if (state is BlogLoadSuccess) {
            blogs = state.blogs;
          } else if (state is BlogOperationSuccess) {
            blogs = state.blogs;
          }

          // Update local data for filtering
          _allBlogs = blogs;
          _filterBlogs();

          final currentPageBlogs = _getCurrentPageBlogs();
          final availableTags = _getAvailableTags();

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 130,
                floating: true,
                pinned: true,
                automaticallyImplyLeading: false,
                backgroundColor: context.customTheme.background,
                elevation: 0,
                scrolledUnderElevation: 1,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding: const EdgeInsets.only(
                      top: kToolbarHeight + 12,
                      left: 16,
                      right: 16,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: context.customTheme.surface.withValues(
                                  alpha: 0.8,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.explore_rounded,
                                color: context.customTheme.secondary,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Explore Blogs',
                              style: context.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.3,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        AppSearchBar(
                          controller: _searchController,
                          searchQuery: _searchQuery,
                          onClear: () => _searchController.clear(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    FilterChipBar(
                      availableTags: availableTags,
                      selectedTag: _selectedTag,
                      onTagSelected: _selectTag,
                    ),
                  ],
                ),
              ),

              // Results Info
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: ResultsInfo(
                    totalResults: _filteredBlogs.length,
                    currentPage: _currentPage,
                    totalPages: _totalPages,
                    searchQuery: _searchQuery,
                    selectedTag: _selectedTag,
                  ),
                ),
              ),

              // Blog List or Empty State
              currentPageBlogs.isEmpty
                  ? SliverFillRemaining(
                      child: ExploreEmptyState(
                        searchQuery: _searchQuery,
                        selectedTag: _selectedTag,
                      ),
                    )
                  : _buildSliverBlogList(currentPageBlogs),

              // Dynamic Pagination - Only shown when scrolled to bottom
              if (_showPagination && _totalPages > 1)
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: PaginationControls(
                      currentPage: _currentPage,
                      totalPages: _totalPages,
                      isLoading: _isLoading,
                      onPreviousPage: _loadPreviousPage,
                      onNextPage: _loadNextPage,
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverBlogList(List<Blog> blogs) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final blog = blogs[index];
          return BlogCard(blog: blog, onTap: () => _openBlog(blog));
        }, childCount: blogs.length),
      ),
    );
  }

  List<String> _getAvailableTags() {
    return Set<String>.from(_allBlogs.expand((blog) => blog.tags)).toList()
      ..sort();
  }
}
