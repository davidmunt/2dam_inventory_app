import 'package:dartz/dartz.dart';
import 'package:proyecto_integrador/domain/entities/status.dart';
import 'package:proyecto_integrador/domain/repositories/status_repository.dart';

class GetAllStatus {
 final StatusRepository repository;

 GetAllStatus(this.repository);

 Future<Either<Exception, List<Status>>> call() async {
   return await repository.getAllStatus();
 }
}