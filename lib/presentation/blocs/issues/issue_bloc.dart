import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:proyecto_integrador/domain/entities/issue.dart';
import 'package:proyecto_integrador/domain/usecases/get_all_issues_usecase.dart';
import 'issue_event.dart';
import 'issue_state.dart';

class IssueBloc extends Bloc<IssueEvent, IssueState> {
  final GetAllIssues getAllIssues;

  IssueBloc(this.getAllIssues) : super(IssueState.initial()) {
    on<LoadIssuesEvent>(_onLoadIssues);
    on<FilterIssuesEvent>(_onFilterIssues);
  }

  // Manejar la carga inicial de las incidencias
  Future<void> _onLoadIssues(
    LoadIssuesEvent event,
    Emitter<IssueState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await getAllIssues();
    result.fold(
      (error) => emit(state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      )),
      (issues) => emit(state.copyWith(
        isLoading: false,
        allIssues: issues,
        filteredIssues: issues,
      )),
    );
  }

  // Manejar el filtro de incidencias
  void _onFilterIssues(
    FilterIssuesEvent event,
    Emitter<IssueState> emit,
  ) {
    final filtered = state.allIssues.where((issue) {
      final matchesIdUser = event.idUser == null || issue.idUser == event.idUser;
      final matchesIdTechnic = event.idTechnic == null || issue.idTecnic == event.idTechnic;
      final matchesIdStatus = event.idStatus == null || issue.idStatus == event.idStatus;
      final matchesCreatedAt = event.createdAt == null ||
          (issue.createdAt.year == event.createdAt!.year &&
           issue.createdAt.month == event.createdAt!.month &&
           issue.createdAt.day == event.createdAt!.day);
      return matchesIdUser && matchesIdTechnic && matchesIdStatus && matchesCreatedAt;
    }).toList();
    emit(state.copyWith(filteredIssues: filtered));
  }
}
