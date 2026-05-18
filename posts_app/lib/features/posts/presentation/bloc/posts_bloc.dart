import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/create_post_usecase.dart';
import '../../domain/usecases/get_post_usecase.dart';
import '../../domain/usecases/get_posts_usecase.dart';

// ── Events ──────────────────────────────────────────────────────
abstract class PostsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchPostsRequested extends PostsEvent {}

class FetchPostRequested extends PostsEvent {
  final int id;
  FetchPostRequested(this.id);

  @override
  List<Object> get props => [id];
}

class CreatePostRequested extends PostsEvent {
  final String title;
  final String body;

  CreatePostRequested({required this.title, required this.body});

  @override
  List<Object> get props => [title, body];
}

// ── States ──────────────────────────────────────────────────────
abstract class PostsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostsInitial extends PostsState {}

// Posts list states
class PostsLoading extends PostsState {}

class PostsLoaded extends PostsState {
  final List<PostEntity> posts;
  final bool isOffline;

  PostsLoaded({required this.posts, this.isOffline = false});

  @override
  List<Object?> get props => [posts, isOffline];
}

class PostsError extends PostsState {
  final String message;
  PostsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Single post states
class PostDetailLoading extends PostsState {}

class PostDetailLoaded extends PostsState {
  final PostEntity post;
  PostDetailLoaded(this.post);

  @override
  List<Object?> get props => [post];
}

class PostDetailError extends PostsState {
  final String message;
  PostDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

// Create post states
class CreatePostLoading extends PostsState {}

class CreatePostSuccess extends PostsState {
  final PostEntity post;
  CreatePostSuccess(this.post);

  @override
  List<Object?> get props => [post];
}

class CreatePostError extends PostsState {
  final String message;
  CreatePostError(this.message);

  @override
  List<Object?> get props => [message];
}

// ── BLoC ─────────────────────────────────────────────────────────
class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetPostsUsecase getPostsUsecase;
  final GetPostUsecase getPostUsecase;
  final CreatePostUsecase createPostUsecase;

  PostsBloc({
    required this.getPostsUsecase,
    required this.getPostUsecase,
    required this.createPostUsecase,
  }) : super(PostsInitial()) {
    on<FetchPostsRequested>(_onFetchPosts);
    on<FetchPostRequested>(_onFetchPost);
    on<CreatePostRequested>(_onCreatePost);
  }

  Future<void> _onFetchPosts(
    FetchPostsRequested event,
    Emitter<PostsState> emit,
  ) async {
    emit(PostsLoading());
    final result = await getPostsUsecase();

    result.fold(
      (failure) {
        // Check if it's a network failure — maybe we have cached data
        if (failure.message.contains('No internet') ||
            failure.message.contains('network')) {
          emit(PostsError(failure.message));
        } else {
          emit(PostsError(failure.message));
        }
      },
      (posts) => emit(PostsLoaded(posts: posts)),
    );
  }

  Future<void> _onFetchPost(
    FetchPostRequested event,
    Emitter<PostsState> emit,
  ) async {
    emit(PostDetailLoading());
    final result = await getPostUsecase(event.id);

    result.fold(
      (failure) => emit(PostDetailError(failure.message)),
      (post) => emit(PostDetailLoaded(post)),
    );
  }

  Future<void> _onCreatePost(
    CreatePostRequested event,
    Emitter<PostsState> emit,
  ) async {
    emit(CreatePostLoading());
    final result = await createPostUsecase(
      CreatePostParams(title: event.title, body: event.body),
    );

    result.fold(
      (failure) => emit(CreatePostError(failure.message)),
      (post) => emit(CreatePostSuccess(post)),
    );
  }
}