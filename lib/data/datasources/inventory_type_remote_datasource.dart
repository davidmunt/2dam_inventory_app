import 'dart:convert';
import 'package:proyecto_integrador/data/models/inventory_type_model.dart';
import 'package:http/http.dart' as http;

abstract class InventoryTypeRemoteDataSource {
 Future<List<InventoryTypeModel>> getAllInventoriesType();
}

class InventoryTypeRemoteDataSourceImpl implements InventoryTypeRemoteDataSource {
 final http.Client client;

 InventoryTypeRemoteDataSourceImpl(this.client);

 @override
 Future<List<InventoryTypeModel>> getAllInventoriesType() async {
  const String token = 'admin';

    final response = await client.get(
      Uri.parse('https://dummyjson.com/c/c785-ae1b-4686-adfa'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> inventoriestypeJson = json.decode(response.body);
      return inventoriestypeJson.map((json) => InventoryTypeModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar personajes');
    }
  //  final response = await client
  //      .get(Uri.parse('http://localhost:8080/inventari_type'));

  //  if (response.statusCode == 200) {
  //    final List<dynamic> inventoriestypeJson = json.decode(response.body);
  //    return inventoriestypeJson
  //        .map((json) => InventoryTypeModel.fromJson(json))
  //        .toList();
  //  } else {
  //    throw Exception('Error al cargar los tipos de inventario');
  //  }
 }
}