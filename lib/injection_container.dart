
import 'package:proyecto_integrador/data/datasources/login_fake_datasource.dart';
import 'package:proyecto_integrador/data/repositories/login_repository_impl.dart';
import 'package:proyecto_integrador/domain/repositories/login_repository.dart';
import 'package:proyecto_integrador/domain/usecases/login_user_usecase.dart';
import 'package:proyecto_integrador/presentation/blocs/login/login_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
 // BloC
 sl.registerFactory(() => LoginBloc(sl(), sl()));

 // Casos de uso
 sl.registerLazySingleton(() => LoginUser(sl()));

 // Repositorios
 sl.registerLazySingleton<LoginRepository>(
   () => LoginRepositoryImpl(sl(), sl()),
 );

 // Data sources
 sl.registerLazySingleton<LoginFakeDatasource>(
   () => LoginFakeDatasourceImpl(),
 );

 // Cliente HTTP
 sl.registerLazySingleton(() => http.Client());
 final sharedPreferences = await SharedPreferences.getInstance();
 sl.registerLazySingleton(() => sharedPreferences);
}