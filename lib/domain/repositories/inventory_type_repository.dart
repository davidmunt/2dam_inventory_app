import 'package:dartz/dartz.dart';
import 'package:proyecto_integrador/domain/entities/inventory_type.dart';

abstract class InventoryTypeRepository {
 Future<Either<Exception, List<InventoryType>>> getAllInventoriesType();
}