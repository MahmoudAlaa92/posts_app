import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

import '../../features/posts/data/datasources/posts_local_datasource.dart';
import '../../features/posts/data/datasources/posts_remote_datasource.dart';
import '../../features/posts/data/repositories/posts_repository_impl.dart';
import '../../features/posts/domain/repositories/posts_repository.dart';
import '../../features/posts/domain/usecases/create_post_usecase.dart';
import '../../features/posts/domain/usecases/get_post_usecase.dart';
import '../../features/posts/domain/usecases/get_posts_usecase.dart';
import '../../features/posts/presentation/bloc/posts_bloc.dart';

import '../mock/mock_service.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../utils/hive_helper.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await HiveHelper.openBoxes();

  // ── External ────────────────────────────────────────────────
  sl.registerLazySingleton<Dio>(() => DioClient.getInstance());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<MockService>(() => MockService()); // ← NEW

  // ── Core ────────────────────────────────────────────────────
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<Connectivity>()),
  );

  // ── Auth ────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(
      dio: sl<Dio>(),
      mockService: sl<MockService>(), // ← NEW
    ),
  );
  sl.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasourceImpl(),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDatasource: sl<AuthRemoteDatasource>(),
      localDatasource: sl<AuthLocalDatasource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  sl.registerLazySingleton(() => LoginUsecase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUsecase(sl<AuthRepository>()));
  sl.registerFactory(() => AuthBloc(
        loginUsecase: sl<LoginUsecase>(),
        logoutUsecase: sl<LogoutUsecase>(),
      ));

  // ── Posts ───────────────────────────────────────────────────
  sl.registerLazySingleton<PostsRemoteDatasource>(
    () => PostsRemoteDatasourceImpl(
      dio: sl<Dio>(),
      mockService: sl<MockService>(), // ← NEW
    ),
  );
  sl.registerLazySingleton<PostsLocalDatasource>(
    () => PostsLocalDatasourceImpl(),
  );
  sl.registerLazySingleton<PostsRepository>(
    () => PostsRepositoryImpl(
      remoteDatasource: sl<PostsRemoteDatasource>(),
      localDatasource: sl<PostsLocalDatasource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  sl.registerLazySingleton(() => GetPostsUsecase(sl<PostsRepository>()));
  sl.registerLazySingleton(() => GetPostUsecase(sl<PostsRepository>()));
  sl.registerLazySingleton(() => CreatePostUsecase(sl<PostsRepository>()));
  sl.registerFactory(() => PostsBloc(
        getPostsUsecase: sl<GetPostsUsecase>(),
        getPostUsecase: sl<GetPostUsecase>(),
        createPostUsecase: sl<CreatePostUsecase>(),
      ));
}