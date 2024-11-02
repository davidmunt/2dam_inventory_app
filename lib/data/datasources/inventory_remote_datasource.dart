import 'dart:convert';
import 'package:proyecto_integrador/data/models/inventory_model.dart';
import 'package:http/http.dart' as http;

abstract class InventoryRemoteDataSource {
 Future<List<InventoryModel>> getAllInventories();
}

class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
 final http.Client client;

 InventoryRemoteDataSourceImpl(this.client);

 @override
 Future<List<InventoryModel>> getAllInventories() async {
   final response = await client
       .get(Uri.parse('https://dummyjson.com/c/4503-8dec-4f96-8c19'));

   if (response.statusCode == 200) {
     final List<dynamic> inventoriesJson = json.decode(response.body);
     return inventoriesJson
         .map((json) => InventoryModel.fromJson(json))
         .toList();
   } else {
     throw Exception('Error al cargar el inventario');
   }
 }
}