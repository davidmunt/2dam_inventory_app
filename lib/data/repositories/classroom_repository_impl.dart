import 'package:dartz/dartz.dart';
import 'package:proyecto_integrador/data/datasources/classroom_remote_datasource.dart';
import 'package:proyecto_integrador/domain/entities/classroom.dart';
import 'package:proyecto_integrador/domain/repositories/classroom_repository.dart';

class ClassroomRepositoryImpl implements ClassroomRepository {
 final ClassroomRemoteDataSource remoteDataSource;

 ClassroomRepositoryImpl(this.remoteDataSource);

 @override
 Future<Either<Exception, List<Classroom>>> getAllClassrooms() async {
   try {
     final classroomModels = await remoteDataSource.getAllClassrooms();
     return Right(classroomModels
         .map((model) => Classroom(
             idClassroom: model.idClassroom, description: model.description))
         .toList());
   } catch (e) {
     return Left(Exception('Error al cargar las clases'));
   }
 }
}