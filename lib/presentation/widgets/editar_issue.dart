import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_integrador/data/datasources/status_remote_datasource.dart';
import 'package:proyecto_integrador/data/models/status_model.dart';

class EditarIssue extends StatefulWidget {
  final int initialIdInventory;
  final int initialIdStatus;
  final String initialDescription;
  final String initialNotes;

  const EditarIssue({
    required this.initialIdInventory,
    required this.initialIdStatus,
    required this.initialDescription,
    required this.initialNotes,
    super.key,
  });

  @override
  State<EditarIssue> createState() => _EditarIssueState();
}

class _EditarIssueState extends State<EditarIssue> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _idInventoryController;
  late TextEditingController _descriptionController;
  late TextEditingController _notesController;
  List<StatusModel> status = [];
  int? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _idInventoryController = TextEditingController(text: widget.initialIdInventory.toString());
    _descriptionController = TextEditingController(text: widget.initialDescription);
    _notesController = TextEditingController(text: widget.initialNotes);
    _selectedStatus = widget.initialIdStatus;
    _fetchStatusTypes();
  }

  Future<void> _fetchStatusTypes() async {
    final dataSource = StatusRemoteDataSourceImpl(http.Client());
    final statusTypes = await dataSource.getAllStatus();
    setState(() {
      status = statusTypes;
    });
  }

  @override
  void dispose() {
    _idInventoryController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("Editar incidencia"),
              TextFormField(
                controller: _idInventoryController,
                decoration: const InputDecoration(labelText: 'ID Inventory'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  final id = int.tryParse(value);
                  if (id == null) {
                    return 'Debe ser un numero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notas'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: _selectedStatus,
                decoration: const InputDecoration(labelText: 'Estado'),
                items: status.map((statusItem) {
                  return DropdownMenuItem<int>(
                    value: statusItem.idStatus,
                    child: Text(statusItem.description),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedStatus = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
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
                          'idInventory': int.parse(_idInventoryController.text),
                          'idStatus': _selectedStatus,
                          'description': _descriptionController.text,
                          'notes': _notesController.text,
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
