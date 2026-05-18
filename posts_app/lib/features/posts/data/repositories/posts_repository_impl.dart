import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/posts_repository.dart';
import '../datasources/posts_local_datasource.dart';
import '../datasources/posts_remote_datasource.dart';


class PostsRepositoryImpl implements PostsRepository {
  final PostsRemoteDatasource remoteDatasource;
  final PostsLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  PostsRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final posts = await remoteDatasource.getPosts();
        await localDatasource.cachePosts(posts); // Cache for offline
        return Right(posts);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      // Offline: return cached data
      final cached = localDatasource.getCachedPosts();
      if (cached.isNotEmpty) {
        return Right(cached);
      }
      return const Left(
        NetworkFailure(message: 'No internet and no cached data'),
      );
    }
  }

  @override
  Future<Either<Failure, PostEntity>> getPost(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final post = await remoteDatasource.getPost(id);
        await localDatasource.cachePost(post);
        return Right(post);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      final cached = localDatasource.getCachedPost(id);
      if (cached != null) return Right(cached);
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> createPost({
    required String title,
    required String body,
    int userId = 1,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final post = await remoteDatasource.createPost(
        title: title,
        body: body,
        userId: userId,
      );
      return Right(post);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}