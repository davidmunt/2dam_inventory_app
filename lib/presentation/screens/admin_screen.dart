import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_integrador/presentation/blocs/inventory/inventory_bloc.dart';
import 'package:proyecto_integrador/presentation/blocs/inventory/inventory_event.dart';
import 'package:proyecto_integrador/presentation/blocs/inventory/inventory_state.dart';
import 'package:proyecto_integrador/presentation/blocs/login/login_bloc.dart';
import 'package:proyecto_integrador/presentation/widgets/themes_log_out.dart';
import 'package:proyecto_integrador/presentation/widgets/crear_inventario.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  AdminScreenState createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<InventoryBloc>().add(LoadInventoriesEvent(''));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = context.read<LoginBloc>().state;
    final nombreUser = loginState.user?.name;
    final iniciales = nombreUser?.substring(0, 2).toUpperCase();

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Incidències"),
            SizedBox(height: 4),
            Text(
              "IES Estació",
              style: TextStyle(fontSize: 12),
            ),
            Divider(
              color: Color.fromARGB(255, 71, 71, 71),
              thickness: 1,
            ),
          ],
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.computer),
              text: "Inventari",
            ),
            Tab(
              icon: Icon(Icons.warning),
              text: "Incidències",
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              showLogoutDialog(context);
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                iniciales!,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Apartat de Inventario",
                    textAlign: TextAlign.center,
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 71, 71, 71),
                    thickness: 1,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: BlocBuilder<InventoryBloc, InventoryState>(
                        builder: (context, state) {
                          if (state.isLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state.inventories.isEmpty) {
                            return const Center(child: Text('No hay inventarios disponibles'));
                          } else {
                            return Column(
                              children: List.generate(state.inventories.length, (index) {
                                final inventory = state.inventories[index];
                                return Dismissible(
                                  key: Key(inventory.idInventory.toString()),
                                  onDismissed: (direction) {
                                    // de momento no hace nada
                                  },
                                  background: Container(color: Colors.red),
                                  child: Row(
                                    children: [
                                      //lo de la franja de color
                                      Container(
                                        width: 3.0,
                                        color: Colors.blue,
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          title: Text('Modelo: ${inventory.model} - Marca: ${inventory.brand}'),
                                          subtitle: Text(
                                            'Num_Serie: ${inventory.numSerie} - Aula: ${inventory.idClassroom} \n - ${inventory.gvaDescriptionCodArticulo}',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Apartat de Incidències",
                    textAlign: TextAlign.center,
                  ),
                  Divider(
                    color: Color.fromARGB(255, 71, 71, 71),
                    thickness: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog<Map<String, dynamic>?>(context: context, builder: (BuildContext context) {
            return const AlertDialog(
              title: Text('Crear inventario'),
              content: CrearInventario(),
            );
          });
          if (result != null) {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Informacion del inventario nuevo'),
                  content: Text(
                    'Número de serie: ${result['numSerie']}\n'
                    'Marca: ${result['marca']}\n'
                    'Aula: ${result['aula']}\n'
                    'Tipo: ${result['tipo']}\n'
                    'Estado: ${result['estado']}',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Aceptar'),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
