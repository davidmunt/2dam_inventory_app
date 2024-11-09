import 'package:flutter/material.dart';
import 'package:proyecto_integrador/data/datasources/issue_remote_datasource.dart'; 
import 'package:proyecto_integrador/data/datasources/status_remote_datasource.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:proyecto_integrador/data/models/issue_model.dart';
import 'package:proyecto_integrador/data/models/status_model.dart';

class FiltrarIssue extends StatefulWidget {
  const FiltrarIssue({super.key});

  @override
  State<FiltrarIssue> createState() => _FiltrarIssueState();
}

class _FiltrarIssueState extends State<FiltrarIssue> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); 
  List<StatusModel> estados = [];
  int? estadoSeleccionado;
  List<IssueModel> issues = [];
  List<DateTime> diasUnicos = [];
  DateTime? diaSeleccionado;

  @override
  void initState() {
    super.initState();
    _fetchStatus();
    _fetchIssue();
  }

  Future<void> _fetchStatus() async {
    final dataSource = StatusRemoteDataSourceImpl(http.Client());
    final states = await dataSource.getAllStatus();
    setState(() {
      estados = states; 
    });
  }

  Future<void> _fetchIssue() async {
    final dataSource = IssueRemoteDataSourceImpl(http.Client());
    final problemas = await dataSource.getAllIssues();
    setState(() {
      issues = problemas; 
      _obtenerDiasUnicos();
    });
  }

  void _obtenerDiasUnicos() {
    final diasSet = <DateTime>{}; 
    for (var issue in issues) {
      final fecha = issue.createdAt.toLocal();
      final fechaSinHora = DateTime(fecha.year, fecha.month, fecha.day);
      diasSet.add(fechaSinHora);
        }
    diasUnicos = diasSet.toList()..sort();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Estado'),
                items: estados.map((StatusModel estado) {
                  return DropdownMenuItem<int>(
                    value: estado.idStatus,
                    child: Text(estado.description),
                  );
                }).toList(),
                onChanged: (value) => setState(() {
                  estadoSeleccionado = value;
                }),
                validator: (value) => value == null ? 'Selecciona un estado' : null,
              ),

              const SizedBox(height: 10),
              DropdownButtonFormField<DateTime>(
                decoration: const InputDecoration(labelText: 'Día'),
                items: diasUnicos.map((DateTime dia) {
                  final formattedDate = DateFormat('yyyy/MM/dd').format(dia);
                  return DropdownMenuItem<DateTime>(
                    value: dia, 
                    child: Text(formattedDate),
                  );
                }).toList(),
                onChanged: (value) => setState(() {
                  diaSeleccionado = value;
                }),
                validator: (value) => value == null ? 'Selecciona un día' : null,
              ),
              
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, null); 
                    },
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton( 
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context, {
                        'idStatus': estadoSeleccionado,
                        'createdAt': diaSeleccionado,
                      });
                    }
                  },
                  child: const Text('Filtrar'),
                ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
