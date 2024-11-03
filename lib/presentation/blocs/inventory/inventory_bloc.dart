import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_integrador/domain/usecases/get_all_inventories_usecase.dart';
import 'package:proyecto_integrador/presentation/blocs/inventory/inventory_event.dart';
import 'package:proyecto_integrador/presentation/blocs/inventory/inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final GetAllInventories getAllInventories;

  InventoryBloc(this.getAllInventories) : super(InventoryState.initial()) {
    on<LoadInventoriesEvent>(_onLoadInventories);
  }

  Future<void> _onLoadInventories(
    LoadInventoriesEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await getAllInventories();
    result.fold(
      (error) => emit(
          state.copyWith(isLoading: false, errorMessage: error.toString())),
      (inventories) {
        emit(state.copyWith(isLoading: false, inventories: inventories));
      },
    );
  }
}
