import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_integrador/data/datasources/inventory_remote_datasource.dart';
import 'package:proyecto_integrador/data/datasources/issue_remote_datasource.dart';
import 'package:proyecto_integrador/data/repositories/inventory_repository_impl.dart';
import 'package:proyecto_integrador/data/repositories/issue_repository_impl.dart';
import 'package:proyecto_integrador/domain/repositories/inventory_repository.dart';
import 'package:proyecto_integrador/domain/repositories/issue_repository.dart';
import 'package:proyecto_integrador/domain/usecases/add_issue_usecase.dart';
import 'package:proyecto_integrador/domain/usecases/get_all_issues_usecase.dart';
import 'package:proyecto_integrador/presentation/blocs/issues/issue_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto_integrador/data/datasources/login_fake_datasource.dart';
import 'package:proyecto_integrador/data/repositories/login_repository_impl.dart';
import 'package:proyecto_integrador/domain/repositories/login_repository.dart';
import 'package:proyecto_integrador/domain/usecases/login_user_usecase.dart';
import 'package:proyecto_integrador/domain/usecases/get_all_inventories_usecase.dart';
import 'package:proyecto_integrador/presentation/blocs/inventory/inventory_bloc.dart';
import 'package:proyecto_integrador/presentation/blocs/login/login_bloc.dart';
import 'package:proyecto_integrador/presentation/blocs/themes/themes_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Cliente HTTP
  sl.registerLazySingleton(() => http.Client());

  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Data sources
  sl.registerLazySingleton<LoginFakeDatasource>(() => LoginFakeDatasourceImpl());
  sl.registerLazySingleton<InventoryRemoteDataSource>(() => InventoryRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<IssueRemoteDataSource>(() => IssueRemoteDataSourceImpl(sl()));

  // Repositorios
  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<InventoryRepository>(() => InventoryRepositoryImpl(sl()));
  sl.registerLazySingleton<IssueRepository>(() => IssueRepositoryImpl(sl()));

  // Casos de uso
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => GetAllInventories(sl<InventoryRepository>()));
  sl.registerLazySingleton(() => GetAllIssues(sl()));
  sl.registerLazySingleton(() => AddIssueUseCase(sl()));

  // BloC
  sl.registerFactory(() => LoginBloc(sl(), sl()));
  sl.registerFactory(() => ThemeBloc());
  sl.registerFactory(() => InventoryBloc(inventoryRepository: sl<InventoryRepository>()));
  sl.registerFactory(() => IssueBloc(sl<GetAllIssues>(), sl<AddIssueUseCase>()));
}