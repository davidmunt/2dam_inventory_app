import 'package:dartz/dartz.dart';
import 'package:proyecto_integrador/domain/entities/user.dart';
import 'package:proyecto_integrador/domain/repositories/login_repository.dart';

class LoginUser {
 final LoginRepository repository;

 LoginUser(this.repository);

 Future<Either<Exception, User>> call(String email, String password) async {
   return await repository.login(email, password);
 }
}