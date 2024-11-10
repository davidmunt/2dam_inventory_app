import 'package:flutter/material.dart';

class CrearIssue extends StatefulWidget {
  const CrearIssue({super.key});

  @override
  State<CrearIssue> createState() => _CrearIssueState();
}

class _CrearIssueState extends State<CrearIssue> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _idInventoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

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
              const Text("Crea una incidencia"),
              // Campo para idInventory
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
                    return 'Debe ser un número entero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Campo para description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  if (value.length < 3) {
                    return 'La descripción debe tener al menos 3 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Campo para notes
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
              const SizedBox(height: 20),

              // Botones
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, null); // Cancelar y cerrar
                    },
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Si es válido, devuelve los datos
                        Navigator.pop(context, {
                          'idInventory': int.parse(_idInventoryController.text),
                          'description': _descriptionController.text,
                          'notes': _notesController.text,
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
