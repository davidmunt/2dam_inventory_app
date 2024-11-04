import 'package:equatable/equatable.dart';
import 'package:proyecto_integrador/domain/entities/issue.dart';

class IssueState extends Equatable {
  final List<Issue> issues;
  final bool isLoading;
  final String errorMessage;
  final String filter;

  const IssueState({
    required this.issues,
    required this.isLoading,
    required this.errorMessage,
    required this.filter,
  });

  factory IssueState.initial() {
    return const IssueState(
      issues: [],
      isLoading: false,
      errorMessage: '',
      filter: '',
    );
  }

  IssueState copyWith({
    List<Issue>? issues,
    bool? isLoading,
    String? errorMessage,
    String? filter,
  }) {
    return IssueState(
      issues: issues ?? this.issues,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [issues, isLoading, errorMessage, filter];
}
