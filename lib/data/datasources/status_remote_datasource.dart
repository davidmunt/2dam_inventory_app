import 'dart:convert';
import 'package:proyecto_integrador/data/models/status_model.dart';
import 'package:http/http.dart' as http;

abstract class StatusRemoteDataSource {
 Future<List<StatusModel>> getAllStatus();
}

class StatusRemoteDataSourceImpl implements StatusRemoteDataSource {
 final http.Client client;

 StatusRemoteDataSourceImpl(this.client);

 @override
 Future<List<StatusModel>> getAllStatus() async {
  const String token = 'admin';
    final response = await client.get(
      Uri.parse('http://localhost:8080/status'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> statusJson = json.decode(response.body);
      return statusJson.map((json) => StatusModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar personajes');
    }
 }
}