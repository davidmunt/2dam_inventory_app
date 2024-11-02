import 'package:equatable/equatable.dart';

abstract class InventoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadInventoriesEvent extends InventoryEvent {
  final String filter; 

  LoadInventoriesEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}
