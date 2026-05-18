import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/empty_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/posts_bloc.dart';
import '../widgets/post_card.dart';

class PostsListScreen extends StatefulWidget {
  const PostsListScreen({super.key});

  @override
  State<PostsListScreen> createState() => _PostsListScreenState();
}

class _PostsListScreenState extends State<PostsListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<PostsBloc>().add(FetchPostsRequested());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      context.read<AuthBloc>().add(LogoutRequested());
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.posts),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: AppStrings.logout,
            onPressed: _logout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(AppRoutes.createPost),
        icon: const Icon(Icons.add),
        label: const Text('New Post'),
      ),
      body: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          if (state is PostsLoading) {
            return const LoadingWidget(message: 'Loading posts...');
          }

          if (state is PostsError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () =>
                  context.read<PostsBloc>().add(FetchPostsRequested()),
            );
          }

          if (state is PostsLoaded) {
            final filteredPosts = _searchQuery.isEmpty
                ? state.posts
                : state.posts
                    .where((p) =>
                        p.title
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()) ||
                        p.body
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()))
                    .toList();

            return Column(
              children: [
                // Offline banner
                if (state.isOffline) const OfflineBanner(),

                // Search bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Search posts...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                    ),
                  ),
                ),

                // Posts count
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        '${filteredPosts.length} posts',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Colors.grey,
                                ),
                      ),
                    ],
                  ),
                ),

                // List
                Expanded(
                  child: filteredPosts.isEmpty
                      ? const EmptyWidget(
                          message: AppStrings.noPostsFound,
                          icon: Icons.article_outlined,
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            context
                                .read<PostsBloc>()
                                .add(FetchPostsRequested());
                          },
                          child: ListView.builder(
                            itemCount: filteredPosts.length,
                            padding: const EdgeInsets.only(bottom: 80),
                            itemBuilder: (context, index) {
                              final post = filteredPosts[index];
                              return PostCard(
                                post: post,
                                onTap: () => context.go(
                                  '/posts/${post.id}',
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            );
          }

          return const EmptyWidget(message: AppStrings.noPostsFound);
        },
      ),
    );
  }
}