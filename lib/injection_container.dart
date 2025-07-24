import 'package:get_it/get_it.dart';
import 'package:inc_project/core/cache/hive_local_storage.dart';
import 'package:inc_project/core/cache/local_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/network/network_checker.dart';
import 'features/articles/data/datasources/article_local_data_source.dart';
import 'features/articles/data/datasources/article_remote_data_source.dart';
import 'features/articles/data/models/article_hive_model.dart';
import 'features/articles/data/repositories/article_repository_impl.dart';
import 'features/articles/domain/repositories/article_repository.dart';
import 'features/articles/domain/usecases/get_articles.dart';
import 'features/articles/domain/usecases/toggle_favorite.dart';
import 'features/articles/presentation/bloc/article_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ArticleHiveModelAdapter());

  // Create a single instance of HiveLocalStorage
  final hiveLocalStorage = HiveLocalStorage();
  sl.registerLazySingleton<LocalStorage>(() => hiveLocalStorage);
  sl.registerLazySingleton(() => hiveLocalStorage);

  // Pre-open commonly used boxes to avoid race conditions
  try {
    await Hive.openBox('articles');
  } catch (e) {
    // Box might already be open, which is fine
    print('Hive box was already open: $e');
  }
  //! Features - Articles
  // Bloc
  sl.registerFactory(
    () => ArticleBloc(getArticles: sl(), toggleFavorite: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetArticles(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));

  // Repository
  sl.registerLazySingleton<ArticleRepository>(
    () => ArticleRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ArticleRemoteDataSource>(
    () => ArticleRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<ArticleLocalDataSource>(
    () =>
        ArticleLocalDataSourceImpl(sharedPreferences: sl(), localStorage: sl()),
  );

  //! Core
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfo(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
