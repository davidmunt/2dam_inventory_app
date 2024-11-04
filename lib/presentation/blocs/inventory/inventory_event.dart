import 'package:equatable/equatable.dart';
import 'package:proyecto_integrador/domain/entities/inventory.dart';

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object> get props => [];
}

class LoadInventoriesEvent extends InventoryEvent {
  final String filter;
  const LoadInventoriesEvent(this.filter);
}

class CreateInventoryEvent extends InventoryEvent {
  final int idInventory;
  final String numSerie;
  final String marca;
  final String modelo;
  final int aula;
  final int tipo;
  final String estado;
  final int gvaCodArticle;
  final String gvaDescriptionCodArticulo;

  const CreateInventoryEvent({
    required this.idInventory,
    required this.numSerie,
    required this.marca,
    required this.modelo,
    required this.aula,
    required this.tipo,
    required this.estado,
    required this.gvaCodArticle,
    required this.gvaDescriptionCodArticulo,
  });
}


class UpdateInventoryEvent extends InventoryEvent {
  final Inventory inventory;
  const UpdateInventoryEvent(this.inventory);
}

class DeleteInventoryEvent extends InventoryEvent {
  final int idInventory;
  const DeleteInventoryEvent(this.idInventory);
}
