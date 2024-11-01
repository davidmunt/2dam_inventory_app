import 'package:dartz/dartz.dart';
import 'package:proyecto_integrador/data/datasources/inventory_type_remote_datasource.dart';
import 'package:proyecto_integrador/domain/entities/inventory_type.dart';
import 'package:proyecto_integrador/domain/repositories/inventory_type_repository.dart';

class InventoryTypeRepositoryImpl implements InventoryTypeRepository {
 final InventoryTypeRemoteDataSource remoteDataSource;

 InventoryTypeRepositoryImpl(this.remoteDataSource);

 @override
 Future<Either<Exception, List<InventoryType>>> getAllInventoriesType() async {
   try {
     final inventoryTypeModels = await remoteDataSource.getAllInventoriesType();
     return Right(inventoryTypeModels
         .map((model) => InventoryType(
             idType: model.idType, 
             description: model.description,
          ))
         .toList());
   } catch (e) {
     return Left(Exception('Error al cargar los tipo de inventario'));
   }
 }
}