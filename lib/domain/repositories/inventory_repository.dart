import 'package:dartz/dartz.dart';
import 'package:proyecto_integrador/domain/entities/inventory.dart';

abstract class InventoryRepository {
  Future<Either<Exception, List<Inventory>>> getAllInventories();
  Future<Either<Exception, void>> createInventory(Inventory inventory);
  Future<Either<Exception, void>> updateInventory(Inventory inventory);
  Future<Either<Exception, void>> deleteInventory(int idInventory);
}