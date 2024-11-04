import 'package:equatable/equatable.dart';
import 'package:proyecto_integrador/domain/entities/inventory.dart';

class InventoryState extends Equatable {
  final List<Inventory> inventories;
  final bool isLoading;
  final String? errorMessage;

  const InventoryState({
    required this.inventories,
    required this.isLoading,
    this.errorMessage,
  });

  factory InventoryState.initial() {
    return const InventoryState(
      inventories: [],
      isLoading: false,
      errorMessage: null,
    );
  }

  InventoryState copyWith({
    List<Inventory>? inventories,
    bool? isLoading,
    String? errorMessage,
  }) {
    return InventoryState(
      inventories: inventories ?? this.inventories,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [inventories, isLoading, errorMessage];
}
