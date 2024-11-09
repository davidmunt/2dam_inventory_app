import 'package:dartz/dartz.dart';
import 'package:proyecto_integrador/domain/entities/status.dart';

abstract class StatusRepository {
 Future<Either<Exception, List<Status>>> getAllStatus();
}