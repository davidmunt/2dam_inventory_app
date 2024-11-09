import 'package:dartz/dartz.dart';
import 'package:proyecto_integrador/data/datasources/status_remote_datasource.dart';
import 'package:proyecto_integrador/domain/entities/status.dart';
import 'package:proyecto_integrador/domain/repositories/status_repository.dart';

class StatusRepositoryImpl implements StatusRepository {
 final StatusRemoteDataSource remoteDataSource;

 StatusRepositoryImpl(this.remoteDataSource);

 @override
 Future<Either<Exception, List<Status>>> getAllStatus() async {
   try {
     final statusModels = await remoteDataSource.getAllStatus();
     return Right(statusModels
         .map((model) => Status(
             idStatus: model.idStatus, description: model.description))
         .toList());
   } catch (e) {
     return Left(Exception('Error al cargar las clases'));
   }
 }
}