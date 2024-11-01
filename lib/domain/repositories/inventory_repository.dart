import 'package:dartz/dartz.dart';
import 'package:proyecto_integrador/domain/entities/inventory.dart';

abstract class InventoryRepository {
 Future<Either<Exception, List<Inventory>>> getAllInventories();
}