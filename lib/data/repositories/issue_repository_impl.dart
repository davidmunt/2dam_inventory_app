import 'package:dartz/dartz.dart';
import 'package:proyecto_integrador/data/datasources/issue_remote_datasource.dart';
import 'package:proyecto_integrador/domain/entities/issue.dart';
import 'package:proyecto_integrador/domain/repositories/issue_repository.dart';

class IssueRepositoryImpl implements IssueRepository {
 final IssueRemoteDataSource remoteDataSource;

 IssueRepositoryImpl(this.remoteDataSource);

 @override
 Future<Either<Exception, List<Issue>>> getAllIssues() async {
   try {
     final issueModels = await remoteDataSource.getAllIssues();
     return Right(issueModels
         .map((model) => Issue(
             idIssue: model.idIssue, 
             createdAt: model.createdAt, 
             description: model.description, 
             lastUpdated: model.lastUpdated, 
             notes: model.notes,
             idUser: model.idUser,
             idTecnic: model.idTecnic,
             idStatus: model.idStatus,
             idInventory: model.idInventory,
        ))
         .toList());
   } catch (e) {
     return Left(Exception('Error al cargar personajes'));
   }
 }
}