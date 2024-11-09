import 'dart:convert';
import 'package:proyecto_integrador/data/models/issue_model.dart';
import 'package:http/http.dart' as http;

abstract class IssueRemoteDataSource {
 Future<List<IssueModel>> getAllIssues();
}

class IssueRemoteDataSourceImpl implements IssueRemoteDataSource {
 final http.Client client;

 IssueRemoteDataSourceImpl(this.client);

 @override
 Future<List<IssueModel>> getAllIssues() async {
  //https://dummyjson.com/c/f872-604d-4a22-8891
  const String token = 'admin';
    // https://dummyjson.com/c/4503-8dec-4f96-8c19
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
  //  final response = await client
  //      .get(Uri.parse('https://dummyjson.com/c/f872-604d-4a22-8891'));

  //  if (response.statusCode == 200) {
  //    final List<dynamic> issuesJson = json.decode(response.body);
  //    return issuesJson
  //        .map((json) => IssueModel.fromJson(json))
  //        .toList();
  //  } else {
  //    throw Exception('Error al cargar los problemas');
  //  }
 }
}