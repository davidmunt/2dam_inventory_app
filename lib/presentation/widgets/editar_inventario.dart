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
  final int gvaCodArticle;
  final String gvaDescriptionCodArticulo;

  const EditarInventario({
    super.key,
    required this.numSerie,
    required this.marca,
    required this.modelo,
    required this.idClassroom,
    required this.idType,
    required this.estado,
    required this.idInventory,
    required this.gvaCodArticle,
    required this.gvaDescriptionCodArticulo,
  });

  @override
  State<EditarInventario> createState() => _EditarInventarioState();
}

class _EditarInventarioState extends State<EditarInventario> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  late TextEditingController _numSerieController;
  late TextEditingController _marcaController;
  late TextEditingController _modeloController;
  late TextEditingController _gvaCodArticleController;
  late TextEditingController _gvaDescriptionCodArticuloController;
  
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
  _gvaCodArticleController = TextEditingController(text: widget.gvaCodArticle.toString());
  _gvaDescriptionCodArticuloController = TextEditingController(text: widget.gvaDescriptionCodArticulo);
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
    _gvaCodArticleController.dispose();
    _gvaDescriptionCodArticuloController.dispose();
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
              const SizedBox(height: 10),
              TextFormField(
                controller: _gvaCodArticleController,
                decoration: const InputDecoration(labelText: 'Cod Articulo'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El Cod Articulo es obligatorio';
                  }
                  return null;
                },
              ),
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
              const SizedBox(height: 10),
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
                        if (!aulas.any((aula) => aula.idClassroom == aulaSeleccionada)) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Error'),
                              content: const Text('El aula seleccionada no es válida.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                          return; 
                        }
                        if (!tipos2.any((tipo) => tipo.idType == tipoSeleccionado)) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Error'),
                              content: const Text('El tipo seleccionado no es válido.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                          return; 
                        }
                        Navigator.pop(context, {
                          'numSerie': _numSerieController.text,
                          'marca': _marcaController.text,
                          'modelo': _modeloController.text,
                          'aula': aulaSeleccionada,
                          'tipo': tipoSeleccionado, 
                          'estado': estadoSeleccionado,
                          'gvaCodArticle': int.tryParse(_gvaCodArticleController.text),
                          'gvaDescriptionCodArticulo': _gvaDescriptionCodArticuloController.text,
                          'idInventory': widget.idInventory, 
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
