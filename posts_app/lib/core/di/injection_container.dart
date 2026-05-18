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

import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../utils/hive_helper.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Open Hive boxes first
  await HiveHelper.openBoxes();

  //==========================
  // External
  //==========================
  sl.registerLazySingleton<Dio>(() => DioClient.getInstance());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  //==========================
  // Core
  //==========================
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<Connectivity>()),
  );

  //==========================
  // Auth Feature
  //==========================
  // Datasources
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDatasource: sl<AuthRemoteDatasource>(),
      localDatasource: sl<AuthLocalDatasource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Usecases
  sl.registerLazySingleton(() => LoginUsecase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUsecase(sl<AuthRepository>()));

  // Bloc
  sl.registerFactory(() => AuthBloc(
        loginUsecase: sl<LoginUsecase>(),
        logoutUsecase: sl<LogoutUsecase>(),
      ));

  //==========================
  // Posts Feature
  //==========================
  // Datasources
  sl.registerLazySingleton<PostsRemoteDatasource>(
    () => PostsRemoteDatasourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<PostsLocalDatasource>(
    () => PostsLocalDatasourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<PostsRepository>(
    () => PostsRepositoryImpl(
      remoteDatasource: sl<PostsRemoteDatasource>(),
      localDatasource: sl<PostsLocalDatasource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Usecases
  sl.registerLazySingleton(() => GetPostsUsecase(sl<PostsRepository>()));
  sl.registerLazySingleton(() => GetPostUsecase(sl<PostsRepository>()));
  sl.registerLazySingleton(() => CreatePostUsecase(sl<PostsRepository>()));

  // Bloc
  sl.registerFactory(() => PostsBloc(
        getPostsUsecase: sl<GetPostsUsecase>(),
        getPostUsecase: sl<GetPostUsecase>(),
        createPostUsecase: sl<CreatePostUsecase>(),
      ));
}