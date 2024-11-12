import 'dart:convert';
import 'package:proyecto_integrador/data/models/issue_model.dart';
import 'package:http/http.dart' as http;

abstract class IssueRemoteDataSource {
 Future<List<IssueModel>> getAllIssues();
 Future<void> createIssue(IssueModel issue);
 Future<void> updateIssue(int idIssue, IssueModel issue);
 Future<void> deleteIssue(int idIssue);
}

class IssueRemoteDataSourceImpl implements IssueRemoteDataSource {
 final http.Client client;

 IssueRemoteDataSourceImpl(this.client);

 @override
 Future<List<IssueModel>> getAllIssues() async {
  const String token = 'admin';
    final response = await client.get(
      Uri.parse('http://localhost:8080/issues'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> issuesJson = json.decode(response.body);
      return issuesJson.map((json) => IssueModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar issues');
    }
 }

 @override
  Future<void> createIssue(IssueModel issue) async {
    const String token = 'admin';
    final response = await client.post(
      Uri.parse('http://localhost:8080/issues'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(issue.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Error al crear la issue');
    }
  }

  @override
  Future<void> updateIssue(int idIssue, IssueModel issue) async {
    const String token = 'admin';
    final response = await client.put(
      Uri.parse('http://localhost:8080/issues/$idIssue'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(issue.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar la issue');
    }
  }

 @override
  Future<void> deleteIssue(int idIssue) async {
  const String token = 'admin';
  final response = await client.delete(
    Uri.parse('http://localhost:8080/issues/$idIssue'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode != 200) {
    throw Exception('Error al eliminar la issue');
  }
 }
}