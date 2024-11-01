import 'package:dartz/dartz.dart';
import 'package:proyecto_integrador/domain/entities/inventory.dart';
import 'package:proyecto_integrador/domain/repositories/inventory_repository.dart';

class GetAllInventories {
 final InventoryRepository repository;

 GetAllInventories(this.repository);

 Future<Either<Exception, List<Inventory>>> call() async {
   return await repository.getAllInventories();
 }
}