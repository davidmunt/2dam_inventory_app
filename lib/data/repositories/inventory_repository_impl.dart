import 'package:dartz/dartz.dart';
import 'package:proyecto_integrador/data/datasources/inventory_remote_datasource.dart';
import 'package:proyecto_integrador/domain/entities/inventory.dart';
import 'package:proyecto_integrador/domain/repositories/inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository {
 final InventoryRemoteDataSource remoteDataSource;

 InventoryRepositoryImpl(this.remoteDataSource);

 @override
 Future<Either<Exception, List<Inventory>>> getAllInventories() async {
   try {
     final inventoryModels = await remoteDataSource.getAllInventories();
     return Right(inventoryModels
         .map((model) => Inventory(
             idInventory: model.idInventory, 
             numSerie: model.numSerie,
             idType: model.idType,
             brand: model.brand,
             model: model.model,
             gvaCodArticle: model.gvaCodArticle,
             gvaDescriptionCodArticulo: model.gvaDescriptionCodArticulo,
             status: model.status,
             idClassroom: model.idClassroom
          ))
         .toList());
   } catch (e) {
     return Left(Exception('Error al cargar el inventario'));
   }
 }
}