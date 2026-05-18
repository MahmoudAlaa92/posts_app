import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/post_entity.dart';
import '../repositories/posts_repository.dart';

class CreatePostParams {
  final String title;
  final String body;
  final int userId;

  const CreatePostParams({
    required this.title,
    required this.body,
    this.userId = 1,
  });
}

class CreatePostUsecase {
  final PostsRepository repository;
  CreatePostUsecase(this.repository);

  Future<Either<Failure, PostEntity>> call(CreatePostParams params) {
    return repository.createPost(
      title: params.title,
      body: params.body,
      userId: params.userId,
    );
  }
}