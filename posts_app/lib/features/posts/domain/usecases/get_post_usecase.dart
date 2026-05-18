import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/post_entity.dart';
import '../repositories/posts_repository.dart';

class GetPostUsecase {
  final PostsRepository repository;
  GetPostUsecase(this.repository);

  Future<Either<Failure, PostEntity>> call(int id) {
    return repository.getPost(id);
  }
}