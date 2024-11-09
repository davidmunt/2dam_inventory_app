import 'package:equatable/equatable.dart';

abstract class IssueEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Evento para cargar todas las incidencias
class LoadIssuesEvent extends IssueEvent {}

// Evento para filtrar las incidencias
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
