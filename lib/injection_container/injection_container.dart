import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_clean_architecture/core/network/network_info.dart';
import 'package:tdd_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tdd_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tdd_clean_architecture/features/number_trivia/data/repositorys/number_trivia_repository_impl.dart';
import 'package:tdd_clean_architecture/features/number_trivia/domain/repositorys/number_trivia_repository.dart';
import 'package:tdd_clean_architecture/features/number_trivia/presentation/utils/input_converter.dart';
import 'package:tdd_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:tdd_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPref = await SharedPreferences.getInstance();
  // bloc
  sl.registerFactory(() => NumberTriviaBloc(
      getConcretNumberTrivia: sl.call(),
      getRandomNumberTrivia: sl.call(),
      inputConverter: sl.call()));

  // usecase
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl.call()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(repository: sl.call()));
  sl.registerLazySingleton(() => InputConverter());

  // repository
  sl.registerLazySingleton<NumberTriviaRepository>(
      () => NumberTriviaRepositoryImpl(
            remoteDataSource: sl(),
            localDataSource: sl(),
            networkInfo: sl(),
          ));
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(() => NumberTriviaRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(() => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));

  // core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // external
  sl.registerLazySingleton<SharedPreferences>(() => sharedPref);
  sl.registerLazySingleton(() => Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
