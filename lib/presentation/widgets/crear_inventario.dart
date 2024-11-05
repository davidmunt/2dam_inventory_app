import 'package:flutter/material.dart'; 
import 'package:proyecto_integrador/data/datasources/classroom_remote_datasource.dart';
import 'package:proyecto_integrador/data/models/classroom_model.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_integrador/data/datasources/inventory_type_remote_datasource.dart';
import 'package:proyecto_integrador/data/models/inventory_type_model.dart';

class CrearInventario extends StatefulWidget {
  const CrearInventario({super.key});

  @override
  State<CrearInventario> createState() => _CrearInventarioState();
}

class _CrearInventarioState extends State<CrearInventario> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _numSerieController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _gvaCodArticleController = TextEditingController();
  final TextEditingController _gvaDescriptionCodArticuloController = TextEditingController();
  List<ClassroomModel> aulas = []; 
  List<InventoryTypeModel> tipos2 = []; 
  int? aulaSeleccionada;
  int? tipoSeleccionado; 
  String? estadoSeleccionado;
  
  final List<String> estados = ['correcto', 'usando', 'disponible', 'reparacion'];

  @override
  void initState() {
    super.initState();
    _fetchClassrooms(); 
    _fetchInventoryTypes(); 
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
  void dispose() {
    _numSerieController.dispose();
    _marcaController.dispose();
    _modeloController.dispose();
    _gvaCodArticleController.dispose();
    _gvaDescriptionCodArticuloController.dispose();
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
              //
              const SizedBox(height: 10),
              TextFormField(
                controller: _gvaDescriptionCodArticuloController,
                decoration: const InputDecoration(labelText: 'Descripcion Cod Articulo gva'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La Descripcion es obligatoria';
                  }
                  return null;
                },
              ),
              //
              TextFormField(
                controller: _gvaCodArticleController,
                decoration: const InputDecoration(labelText: 'Cod Articulo'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El Cod Articulo es obligatorio';
                  }
                  if (int.tryParse(value) == null) {
                    return 'El Cod Articulo debe ser un número';
                  }
                  return null;
                },
              ),
              //
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
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
              DropdownButtonFormField<int>(
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
              DropdownButtonFormField<String>(
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
                        'gvaCodArticle': int.parse(_gvaCodArticleController.text),
                        'gvaDescriptionCodArticulo': _gvaDescriptionCodArticuloController.text,
                      });
                    }
                  },
                  child: const Text('Crear'),
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
