import 'package:flutter/material.dart';

class CrearInventario extends StatefulWidget {
  const CrearInventario({super.key});

  @override
  State<CrearInventario> createState() => _CrearInventarioState();
}

class _CrearInventarioState extends State<CrearInventario> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _numSerieController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final List<int> aulas = List<int>.generate(12, (index) => index + 1);
  final List<String> tipos = ['Ordenador', 'Portatil', 'Pantalla', 'Proyector'];
  final List<String> estados = ['Correcto', 'Usando', 'Por usar'];

  int? aulaSeleccionada;
  String? tipoSeleccionado;
  String? estadoSeleccionado;

  @override
  void dispose() {
    _numSerieController.dispose();
    _marcaController.dispose();
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
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Aula'),
                items: aulas.map((int aula) {
                  return DropdownMenuItem<int>(
                    value: aula,
                    child: Text('Aula $aula'),
                  );
                }).toList(),
                onChanged: (value) => setState(() {
                  aulaSeleccionada = value;
                }),
                validator: (value) => value == null ? 'Selecciona un aula' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: tipos.map((String tipo) {
                  return DropdownMenuItem<String>(
                    value: tipo,
                    child: Text(tipo),
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
                          'aula': aulaSeleccionada,
                          'tipo': tipoSeleccionado,
                          'estado': estadoSeleccionado,
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Completa todos los campos')),
                        );
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
