import 'package:dartz/dartz.dart';
import 'package:proyecto_integrador/domain/entities/issue.dart';
import 'package:proyecto_integrador/domain/repositories/issue_repository.dart';

class UpdateIssueUseCase {
  final IssueRepository repository;

  UpdateIssueUseCase(this.repository);

  Future<Either<Exception, void>> call(Issue issue) async {
    return await repository.updateIssue(issue);
  }
}
