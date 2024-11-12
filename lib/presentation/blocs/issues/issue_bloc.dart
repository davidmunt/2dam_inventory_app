import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:proyecto_integrador/domain/entities/issue.dart';
import 'package:proyecto_integrador/domain/usecases/add_issue_usecase.dart';
import 'package:proyecto_integrador/domain/usecases/get_all_issues_usecase.dart';
import 'package:proyecto_integrador/domain/usecases/update_issue_usecase.dart';
import 'issue_event.dart';
import 'issue_state.dart';

class IssueBloc extends Bloc<IssueEvent, IssueState> {
  final GetAllIssues getAllIssues;
  final AddIssueUseCase addIssueUseCase;
  final UpdateIssueUseCase updateIssueUseCase;

  IssueBloc(this.getAllIssues, this.addIssueUseCase, this.updateIssueUseCase) : super(IssueState.initial()) {
    on<LoadIssuesEvent>(_onLoadIssues);
    on<FilterIssuesEvent>(_onFilterIssues);
    on<AddIssueEvent>(_onAddIssue);
    on<DeleteIssueEvent>(_onDeleteIssue);
    on<UpdateIssueEvent>(_onUpdateIssue);
  }

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

  Future<void> _onAddIssue(
    AddIssueEvent event,
    Emitter<IssueState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final newIssue = Issue(
      idIssue: 100, //me obliga introducir un numero, le pongo 100 pero al crearse ya se pone bien
      createdAt: DateTime.now(),
      description: event.description,
      lastUpdated: DateTime.now(),
      notes: event.notes,
      idUser: event.idUser,
      idTecnic: event.idTecnic,
      idStatus: event.idStatus,
      idInventory: event.idInventory,
    );

    final result = await addIssueUseCase(newIssue);
    result.fold(
      (error) => emit(state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      )),
      (_) {
        final updatedIssues = List<Issue>.from(state.allIssues)..add(newIssue);
        emit(state.copyWith(
          isLoading: false,
          allIssues: updatedIssues,
          filteredIssues: updatedIssues,
        ));
      },
    );
  }

  Future<void> _onUpdateIssue(
    UpdateIssueEvent event,
    Emitter<IssueState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final updatedIssue = Issue(
      idIssue: event.idIssue,
      createdAt: event.createdAt,
      description: event.description,
      lastUpdated: DateTime.now(),
      notes: event.notes,
      idUser: event.idUser,
      idTecnic: event.idTecnic,
      idStatus: event.idStatus,
      idInventory: event.idInventory,
    );

    final result = await updateIssueUseCase(updatedIssue);
    result.fold(
      (error) => emit(state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      )),
      (_) {
        final updatedIssues = state.allIssues.map((issue) {
          return issue.idIssue == event.idIssue ? updatedIssue : issue;
        }).toList();
        emit(state.copyWith(
          isLoading: false,
          allIssues: updatedIssues,
          filteredIssues: updatedIssues,
        ));
      },
    );
  }

  Future<void> _onDeleteIssue(
    DeleteIssueEvent event,
    Emitter<IssueState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await getAllIssues.repository.deleteIssue(event.idIssue);
    result.fold(
      (error) => emit(state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      )),
      (_) {
        final updatedIssues = state.allIssues.where((issue) => issue.idIssue != event.idIssue).toList();
        emit(state.copyWith(
          isLoading: false,
          allIssues: updatedIssues,
          filteredIssues: updatedIssues,
        ));
      },
    );
  }
}
