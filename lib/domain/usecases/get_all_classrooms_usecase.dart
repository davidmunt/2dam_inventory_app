import 'package:dartz/dartz.dart';
import 'package:proyecto_integrador/domain/entities/classroom.dart';
import 'package:proyecto_integrador/domain/repositories/classroom_repository.dart';

class GetAllClassrooms {
 final ClassroomRepository repository;

 GetAllClassrooms(this.repository);

 Future<Either<Exception, List<Classroom>>> call() async {
   return await repository.getAllClassrooms();
 }
}