import 'dart:convert';
import 'package:proyecto_integrador/data/models/classroom_model.dart';
import 'package:http/http.dart' as http;

abstract class ClassroomRemoteDataSource {
 Future<List<ClassroomModel>> getAllClassrooms();
}

class ClassroomRemoteDataSourceImpl implements ClassroomRemoteDataSource {
 final http.Client client;

 ClassroomRemoteDataSourceImpl(this.client);

 @override
 Future<List<ClassroomModel>> getAllClassrooms() async {
   final response = await client
       .get(Uri.parse('http://localhost:8080/classroom'));

   if (response.statusCode == 200) {
     final List<dynamic> classroomsJson = json.decode(response.body);
     return classroomsJson
         .map((json) => ClassroomModel.fromJson(json))
         .toList();
   } else {
     throw Exception('Error al cargar las clases');
   }
 }
}