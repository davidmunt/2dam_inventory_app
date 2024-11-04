import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
import 'package:proyecto_integrador/domain/entities/inventory.dart';
import 'package:proyecto_integrador/domain/repositories/inventory_repository.dart';
import 'inventory_event.dart';
import 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final InventoryRepository inventoryRepository;

  InventoryBloc({required this.inventoryRepository}) : super(InventoryState.initial()) {
    on<LoadInventoriesEvent>(_onLoadInventories);
    on<CreateInventoryEvent>(_onCreateInventory);
    on<UpdateInventoryEvent>(_onUpdateInventory);
    on<DeleteInventoryEvent>(_onDeleteInventory);
  }

  Future<void> _onLoadInventories(
      LoadInventoriesEvent event, Emitter<InventoryState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await inventoryRepository.getAllInventories();
    result.fold(
      (error) => emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Error al cargar el inventario',
      )),
      (inventories) => emit(state.copyWith(
        isLoading: false,
        inventories: inventories,
      )),
    );
  }

  Future<void> _onCreateInventory(
      CreateInventoryEvent event, Emitter<InventoryState> emit) async {
    emit(state.copyWith(isLoading: true));
    final inventory = Inventory(
      idInventory: event.idInventory,
      numSerie: event.numSerie,
      brand: event.marca,
      model: event.modelo,
      idClassroom: event.aula,
      idType: event.tipo,
      status: event.estado,
      gvaCodArticle: event.gvaCodArticle,
      gvaDescriptionCodArticulo: event.gvaDescriptionCodArticulo,
    );
    final result = await inventoryRepository.createInventory(inventory);
    result.fold(
      (error) => emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Error al crear el inventario',
      )),
      (_) => add(const LoadInventoriesEvent('')),
    );
  }


  Future<void> _onUpdateInventory(
      UpdateInventoryEvent event, Emitter<InventoryState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await inventoryRepository.updateInventory(event.inventory);
    result.fold(
      (error) => emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Error al actualizar el inventario',
      )),
      (_) => add(const LoadInventoriesEvent('')),
    );
  }

  Future<void> _onDeleteInventory(
      DeleteInventoryEvent event, Emitter<InventoryState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await inventoryRepository.deleteInventory(event.idInventory);
    result.fold(
      (error) => emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Error al eliminar el inventario',
      )),
      (_) => add(const LoadInventoriesEvent('')),
    );
  }
}
