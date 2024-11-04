import 'package:equatable/equatable.dart';

abstract class IssueEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadIssuesEvent extends IssueEvent {
  final String filter; 

  LoadIssuesEvent({this.filter = ''});

  @override
  List<Object?> get props => [filter];
}