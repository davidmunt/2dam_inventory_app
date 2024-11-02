import 'package:equatable/equatable.dart';
import 'package:proyecto_integrador/domain/entities/inventory.dart';

class InventoryState extends Equatable {
  final List<Inventory> inventories;
  final bool isLoading;
  final String errorMessage;
  final String filter;

  const InventoryState({
    required this.inventories,
    required this.isLoading,
    required this.errorMessage,
    required this.filter,
  });

  factory InventoryState.initial() {
    return const InventoryState(
      inventories: [],
      isLoading: false,
      errorMessage: '',
      filter: '',
    );
  }

  InventoryState copyWith({
    List<Inventory>? inventories,
    bool? isLoading,
    String? errorMessage,
    String? filter,
  }) {
    return InventoryState(
      inventories: inventories ?? this.inventories,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [inventories, isLoading, errorMessage, filter];
}
