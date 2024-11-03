import 'package:flutter/material.dart'; 
import 'package:proyecto_integrador/data/datasources/classroom_remote_datasource.dart';
import 'package:proyecto_integrador/data/models/classroom_model.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_integrador/data/datasources/inventory_type_remote_datasource.dart';
import 'package:proyecto_integrador/data/models/inventory_type_model.dart';

class EditarInventario extends StatefulWidget {
  final String numSerie;
  final String marca;
  final String modelo;
  final int idClassroom;
  final int idType;
  final String estado;
  final int idInventory;

  const EditarInventario({
    super.key,
    required this.numSerie,
    required this.marca,
    required this.modelo,
    required this.idClassroom,
    required this.idType,
    required this.estado,
    required this.idInventory,
  });

  @override
  State<EditarInventario> createState() => _EditarInventarioState();
}

class _EditarInventarioState extends State<EditarInventario> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  late TextEditingController _numSerieController;
  late TextEditingController _marcaController;
  late TextEditingController _modeloController;
  
  List<ClassroomModel> aulas = [];
  List<InventoryTypeModel> tipos2 = [];
  int? aulaSeleccionada;
  int? tipoSeleccionado;
  String? estadoSeleccionado;
  int? idInventory;

  final List<String> estados = ['Correcto', 'Usando', 'Disponible', 'Reparacion'];

  @override
  void initState() {
    super.initState();
    _numSerieController = TextEditingController(text: widget.numSerie);
    _marcaController = TextEditingController(text: widget.marca);
    _modeloController = TextEditingController(text: widget.modelo);
    aulaSeleccionada = widget.idClassroom;
    tipoSeleccionado = widget.idType;
    estadoSeleccionado = widget.estado;

    _fetchClassrooms();
    _fetchInventoryTypes();
  }

  @override
  void dispose() {
    _numSerieController.dispose();
    _marcaController.dispose();
    _modeloController.dispose();
    super.dispose();
  }

  Future<void> _fetchClassrooms() async {
    final dataSource = ClassroomRemoteDataSourceImpl(http.Client());
    final classrooms = await dataSource.getAllClassrooms();
    setState(() {
      aulas = classrooms;
    });
  }

  Future<void> _fetchInventoryTypes() async {
    final dataSource2 = InventoryTypeRemoteDataSourceImpl(http.Client());
    final inventoryTypes = await dataSource2.getAllInventoriesType();
    setState(() {
      tipos2 = inventoryTypes;
    });
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
              // Campo para número de serie
              TextFormField(
                controller: _numSerieController,
                decoration: const InputDecoration(labelText: 'Número de Serie'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El número de serie es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Campo para marca
              TextFormField(
                controller: _marcaController,
                decoration: const InputDecoration(labelText: 'Marca'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La marca es obligatoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Campo para modelo
              TextFormField(
                controller: _modeloController,
                decoration: const InputDecoration(labelText: 'Modelo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El modelo es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Dropdown para aula
              DropdownButtonFormField<int>(
                value: aulaSeleccionada,
                decoration: const InputDecoration(labelText: 'Aula'),
                items: aulas.map((ClassroomModel aula) {
                  return DropdownMenuItem<int>(
                    value: aula.idClassroom,
                    child: Text('${aula.idClassroom}'),
                  );
                }).toList(),
                onChanged: (value) => setState(() {
                  aulaSeleccionada = value;
                }),
                validator: (value) => value == null ? 'Selecciona un aula' : null,
              ),
              const SizedBox(height: 10),

              // Dropdown para tipo
              DropdownButtonFormField<int>(
                value: tipoSeleccionado,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: tipos2.map((InventoryTypeModel tipo) {
                  return DropdownMenuItem<int>(
                    value: tipo.idType,
                    child: Text(tipo.description),
                  );
                }).toList(),
                onChanged: (value) => setState(() {
                  tipoSeleccionado = value;
                }),
                validator: (value) => value == null ? 'Selecciona un tipo' : null,
              ),
              const SizedBox(height: 10),

              // Dropdown para estado
              DropdownButtonFormField<String>(
                value: estadoSeleccionado,
                decoration: const InputDecoration(labelText: 'Estado'),
                items: estados.map((String estado) {
                  return DropdownMenuItem<String>(
                    value: estado,
                    child: Text(estado),
                  );
                }).toList(),
                onChanged: (value) => setState(() {
                  estadoSeleccionado = value;
                }),
                validator: (value) => value == null ? 'Selecciona un estado' : null,
              ),
              const SizedBox(height: 10),

              // Botones de cancelar y guardar
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
                          'numSerie': _numSerieController.text,
                          'marca': _marcaController.text,
                          'modelo': _modeloController.text,
                          'aula': aulaSeleccionada,
                          'tipo': tipoSeleccionado, 
                          'estado': estadoSeleccionado,
                          'idInventory': idInventory,
                        });
                      }
                    },
                    child: const Text('Guardar'),
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
