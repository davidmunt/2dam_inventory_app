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
  const String token = 'admin';
    final response = await client.get(
      Uri.parse('http://localhost:8080/classroom'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> classromsJson = json.decode(response.body);
      return classromsJson.map((json) => ClassroomModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar personajes');
    }
 }
}