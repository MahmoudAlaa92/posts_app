import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/post_entity.dart';

abstract class PostsRepository {
  Future<Either<Failure, List<PostEntity>>> getPosts();
  Future<Either<Failure, PostEntity>> getPost(int id);
  Future<Either<Failure, PostEntity>> createPost({
    required String title,
    required String body,
    int userId = 1,
  });
}