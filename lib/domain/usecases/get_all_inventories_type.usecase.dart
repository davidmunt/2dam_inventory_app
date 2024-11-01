import 'package:dartz/dartz.dart';
import 'package:proyecto_integrador/domain/entities/inventory_type.dart';
import 'package:proyecto_integrador/domain/repositories/inventory_type_repository.dart';

class GetAllInventoriesType {
 final InventoryTypeRepository repository;

 GetAllInventoriesType(this.repository);

 Future<Either<Exception, List<InventoryType>>> call() async {
   return await repository.getAllInventoriesType();
 }
}