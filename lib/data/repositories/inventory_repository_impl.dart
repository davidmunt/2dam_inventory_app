import 'package:dartz/dartz.dart';
import 'package:proyecto_integrador/data/datasources/inventory_remote_datasource.dart';
import 'package:proyecto_integrador/data/models/inventory_model.dart';
import 'package:proyecto_integrador/domain/entities/inventory.dart';
import 'package:proyecto_integrador/domain/repositories/inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDataSource remoteDataSource;

  InventoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Exception, List<Inventory>>> getAllInventories() async {
    try {
      final inventoryModels = await remoteDataSource.getAllInventories();
      final inventories = inventoryModels.map((model) => Inventory(
        idInventory: model.idInventory,
        numSerie: model.numSerie,
        idType: model.idType,
        brand: model.brand,
        model: model.model,
        gvaCodArticle: model.gvaCodArticle,
        gvaDescriptionCodArticulo: model.gvaDescriptionCodArticulo,
        status: model.status,
        idClassroom: model.idClassroom,
      )).toList();
      return Right(inventories);
    } catch (e) {
      return Left(Exception('Error al cargar el inventario'));
    }
  }

  @override
  Future<Either<Exception, void>> createInventory(Inventory inventory) async {
    try {
      final inventoryModel = InventoryModel(
        idInventory: inventory.idInventory,
        numSerie: inventory.numSerie,
        idType: inventory.idType,
        brand: inventory.brand,
        model: inventory.model,
        gvaCodArticle: inventory.gvaCodArticle,
        gvaDescriptionCodArticulo: inventory.gvaDescriptionCodArticulo,
        status: inventory.status,
        idClassroom: inventory.idClassroom,
      );
      await remoteDataSource.createInventory(inventoryModel);
      return const Right(null);
    } catch (e) {
      return Left(Exception('Error al crear el inventario'));
    }
  }

  @override
  Future<Either<Exception, void>> updateInventory(Inventory inventory) async {
    try {
      final inventoryModel = InventoryModel(
        idInventory: inventory.idInventory,
        numSerie: inventory.numSerie,
        idType: inventory.idType,
        brand: inventory.brand,
        model: inventory.model,
        gvaCodArticle: inventory.gvaCodArticle,
        gvaDescriptionCodArticulo: inventory.gvaDescriptionCodArticulo,
        status: inventory.status,
        idClassroom: inventory.idClassroom,
      );
      await remoteDataSource.updateInventory(inventoryModel);
      return const Right(null);
    } catch (e) {
      return Left(Exception('Error al actualizar el inventario'));
    }
  }

  @override
  Future<Either<Exception, void>> deleteInventory(int idInventory) async {
    try {
      await remoteDataSource.deleteInventory(idInventory);
      return const Right(null);
    } catch (e) {
      return Left(Exception('Error al eliminar el inventario'));
    }
  }
}
