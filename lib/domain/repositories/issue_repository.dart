import 'package:dartz/dartz.dart';
import 'package:proyecto_integrador/domain/entities/issue.dart';

abstract class IssueRepository {
 Future<Either<Exception, List<Issue>>> getAllIssues();
 Future<Either<Exception, void>> deleteIssue(int idIssue);
 Future<Either<Exception, void>> createIssue(Issue issue);
 Future<Either<Exception, void>> updateIssue(Issue issue);
}