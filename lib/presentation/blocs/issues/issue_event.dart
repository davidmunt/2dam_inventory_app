import 'package:equatable/equatable.dart';

abstract class IssueEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadIssuesEvent extends IssueEvent {}

class FilterIssuesEvent extends IssueEvent {
  final int? idUser;
  final int? idTechnic;
  final int? idStatus;
  final DateTime? createdAt;

  FilterIssuesEvent({
    this.idUser,
    this.idTechnic,
    this.idStatus,
    this.createdAt,
  });

  @override
  List<Object?> get props => [idUser, idTechnic, idStatus, createdAt];
}

class DeleteIssueEvent extends IssueEvent {
  final int idIssue;

  DeleteIssueEvent(this.idIssue);

  @override
  List<Object?> get props => [idIssue];
}

class AddIssueEvent extends IssueEvent {
  final String description;
  final String notes;
  final int idUser;
  final int idTecnic;
  final int idStatus;
  final int idInventory;

  AddIssueEvent({
    required this.description,
    required this.notes,
    required this.idUser,
    required this.idTecnic,
    required this.idStatus,
    required this.idInventory,
  });

  @override
  List<Object?> get props => [description, notes, idUser, idTecnic, idStatus, idInventory];
}
