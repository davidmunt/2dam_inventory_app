import 'package:dartz/dartz.dart';
import 'package:proyecto_integrador/domain/entities/issue.dart';
import 'package:proyecto_integrador/domain/repositories/issue_repository.dart';

class GetAllIssues {
 final IssueRepository repository;

 GetAllIssues(this.repository);

 Future<Either<Exception, List<Issue>>> call() async {
   return await repository.getAllIssues();
 }
}