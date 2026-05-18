import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/splash_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/posts/presentation/pages/posts_list_screen.dart';
import '../../features/posts/presentation/pages/post_detail_screen.dart';
import '../../features/posts/presentation/pages/create_post_screen.dart';
import '../utils/hive_helper.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const posts = '/posts';
  static const postDetail = '/posts/:id';
  static const createPost = '/posts/create';
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final isLoggedIn = HiveHelper.isLoggedIn;
      final isOnAuth = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.splash;

      if (!isLoggedIn && !isOnAuth) return AppRoutes.login;
      if (isLoggedIn && state.matchedLocation == AppRoutes.login) {
        return AppRoutes.posts;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.posts,
        builder: (context, state) => const PostsListScreen(),
        routes: [
          GoRoute(
            path: 'create',
            builder: (context, state) => const CreatePostScreen(),
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return PostDetailScreen(postId: id);
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route not found: ${state.error}'),
      ),
    ),
  );
}