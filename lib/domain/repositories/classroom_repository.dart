import 'package:dartz/dartz.dart';
import 'package:proyecto_integrador/domain/entities/classroom.dart';

abstract class ClassroomRepository {
 Future<Either<Exception, List<Classroom>>> getAllClassrooms();
}