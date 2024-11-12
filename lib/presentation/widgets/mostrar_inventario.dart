import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_integrador/domain/entities/inventory.dart';
import 'package:proyecto_integrador/presentation/blocs/inventory/inventory_bloc.dart';
import 'package:proyecto_integrador/presentation/blocs/inventory/inventory_state.dart';
import 'package:proyecto_integrador/presentation/blocs/inventory/inventory_event.dart';
import 'package:proyecto_integrador/presentation/widgets/editar_inventario.dart';

class MostrarInventario extends StatelessWidget {
  final List<Color> colores;

  const MostrarInventario({super.key, required this.colores});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryBloc, InventoryState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.inventories.isEmpty) {
          return const Center(child: Text('No hay inventarios disponibles'));
        } else {
          return SingleChildScrollView(
  child: Column(
    children: List.generate(state.inventories.length, (index) {
      final inventory = state.inventories[index];
      int numColor = inventory.idType;
      return Dismissible(
        key: Key(inventory.idInventory.toString()),
        onDismissed: (direction) {
          context.read<InventoryBloc>().add(DeleteInventoryEvent(inventory.idInventory));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Inventario eliminado'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        background: Container(color: Colors.red),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(12), // Radio del borde
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 4.0,
                height: 90.0,
                color: colores[numColor],
              ),
              Expanded(
                child: ListTile(
                  title: Text('Modelo: ${inventory.model} (${inventory.brand})'),
                  subtitle: Text(
                    'Num_Serie: ${inventory.numSerie} \nAula: ${inventory.idClassroom} \n${inventory.gvaDescriptionCodArticulo}',
                  ),
                ),
              ),
              const Spacer(),
              if (inventory.status == 'reparación') 
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red, width: 1),
                  ),
                  child: const Text(
                    'Incidencia',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () async {
                  final result = await showDialog<Map<String, dynamic>?>(context: context, builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Editar inventario'),
                      content: EditarInventario(
                        numSerie: inventory.numSerie,
                        marca: inventory.brand,
                        modelo: inventory.model,
                        idClassroom: inventory.idClassroom,
                        idType: inventory.idType,
                        estado: inventory.status,
                        idInventory: inventory.idInventory,
                        gvaCodArticle: inventory.gvaCodArticle,
                        gvaDescriptionCodArticulo: inventory.gvaDescriptionCodArticulo,
                      ),
                    );
                  });
                  if (result != null) {
                    final updatedInventory = Inventory(
                      idInventory: result['idInventory'],
                      numSerie: result['numSerie'],
                      brand: result['marca'],
                      model: result['modelo'],
                      idClassroom: result['aula'],
                      idType: result['tipo'],
                      status: result['estado'],
                      gvaCodArticle: result['gvaCodArticle'],
                      gvaDescriptionCodArticulo: result['gvaDescriptionCodArticulo'],
                    );
                    context.read<InventoryBloc>().add(UpdateInventoryEvent(updatedInventory));
                  }
                },
              ),
            ],
          ),
        ),
      );
    }),
  ),
);

        }
      },
    );
  }
}