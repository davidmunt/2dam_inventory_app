import 'dart:convert';
import 'package:proyecto_integrador/data/models/inventory_model.dart';
import 'package:http/http.dart' as http;

abstract class InventoryRemoteDataSource {
  Future<List<InventoryModel>> getAllInventories();
  Future<void> createInventory(InventoryModel inventory);
  Future<void> updateInventory(InventoryModel inventory);
  Future<void> deleteInventory(int idInventory);
}

class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  final http.Client client;
  InventoryRemoteDataSourceImpl(this.client);

  @override
  Future<List<InventoryModel>> getAllInventories() async {
    const String token = 'admin';
    final response = await client.get(
      Uri.parse('https://dummyjson.com/c/4503-8dec-4f96-8c19'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> inventoriesJson = json.decode(response.body);
      return inventoriesJson.map((json) => InventoryModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar personajes');
    }
    // final response = await client.get(Uri.parse('http://localhost:8080/inventari'));
    // if (response.statusCode == 200) {
    //   final List<dynamic> inventoriesJson = json.decode(response.body);
    //   return inventoriesJson.map((json) => InventoryModel.fromJson(json)).toList();
    // } else {
    //   throw Exception('Error al cargar el inventario');
    // }
  }

  @override
  Future<void> createInventory(InventoryModel inventory) async {
    const String token = 'admin';
    final response = await client.post(
      Uri.parse('http://localhost:8080/inventari'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(inventory.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Error al crear el inventario: ${response.body}');
    }
  }

  @override
  Future<void> updateInventory(InventoryModel inventory) async {
    const String token = 'admin';
    final response = await client.put(
      Uri.parse('http://localhost:8080/inventari/${inventory.idInventory}'), 
      headers: {
        'Content-Type': 'application/json', 
        'Authorization': 'Bearer $token', 
      },
      body: json.encode(inventory.toJson()), 
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el inventario: ${response.body}');
    }
  }

  @override
  Future<void> deleteInventory(int idInventory) async {
    const String token = 'admin';
    final response = await client.delete(
      Uri.parse('http://localhost:8080/inventari/$idInventory'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el inventario: ${response.body}');
    }
  }
}