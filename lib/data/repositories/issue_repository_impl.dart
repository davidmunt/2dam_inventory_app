import 'package:dartz/dartz.dart';
import 'package:proyecto_integrador/data/datasources/issue_remote_datasource.dart';
import 'package:proyecto_integrador/data/models/issue_model.dart';
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

 @override
 Future<Either<Exception, void>> createIssue(Issue issue) async {
    try {
      final issueModel = IssueModel(
        idIssue: issue.idIssue,
        createdAt: DateTime.now(),
        description: issue.description,
        lastUpdated: DateTime.now(),
        notes: issue.notes,
        idUser: issue.idUser,
        idTecnic: issue.idTecnic,
        idStatus: issue.idStatus,
        idInventory: issue.idInventory,
      );
      await remoteDataSource.createIssue(issueModel);
      return const Right(null);
    } catch (e) {
      return Left(Exception('Error al crear la issue'));
    }
  }

 @override
 Future<Either<Exception, void>> deleteIssue(int idIssue) async {
  try {
    await remoteDataSource.deleteIssue(idIssue);
    return const Right(null);
  } catch (e) {
    return Left(Exception('Error al eliminar la issue'));
  }
 }
}