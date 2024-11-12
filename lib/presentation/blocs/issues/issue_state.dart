import 'package:equatable/equatable.dart';
import 'package:proyecto_integrador/domain/entities/issue.dart';

class IssueState extends Equatable {
  final List<Issue> allIssues;
  final List<Issue> filteredIssues;
  final bool isLoading;
  final String errorMessage;

  const IssueState({
    required this.allIssues,
    required this.filteredIssues,
    required this.isLoading,
    required this.errorMessage,
  });

  factory IssueState.initial() {
    return const IssueState(
      allIssues: [],
      filteredIssues: [],
      isLoading: false,
      errorMessage: '',
    );
  }

  IssueState copyWith({
    List<Issue>? allIssues,
    List<Issue>? filteredIssues,
    bool? isLoading,
    String? errorMessage,
  }) {
    return IssueState(
      allIssues: allIssues ?? this.allIssues,
      filteredIssues: filteredIssues ?? this.filteredIssues,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [allIssues, filteredIssues, isLoading, errorMessage];
}
