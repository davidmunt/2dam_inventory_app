import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_integrador/domain/usecases/get_all_issues_usecase.dart';
import 'package:proyecto_integrador/presentation/blocs/issue/issue_event.dart';
import 'package:proyecto_integrador/presentation/blocs/issue/issue_state.dart';

class IssueBloc extends Bloc<IssueEvent, IssueState> {
  final GetAllIssues getAllIssues;

  IssueBloc(this.getAllIssues) : super(IssueState.initial()) {
    on<LoadIssuesEvent>(_onLoadIssues);
  }

  Future<void> _onLoadIssues(
    LoadIssuesEvent event,
    Emitter<IssueState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, filter: event.filter));

    final result = await getAllIssues();
    result.fold(
      (error) => emit(
        state.copyWith(isLoading: false, errorMessage: error.toString())),
      (issues) {
        final filterAsInt = int.tryParse(event.filter);
        final filteredIssues = issues.where((issue) {
          return filterAsInt == null || issue.idInventory == filterAsInt;
        }).toList();
        emit(state.copyWith(isLoading: false, issues: filteredIssues));
      },
    );
  }
}
