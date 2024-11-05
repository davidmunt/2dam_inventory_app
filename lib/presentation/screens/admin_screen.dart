import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_integrador/domain/entities/inventory.dart';
import 'package:proyecto_integrador/presentation/blocs/inventory/inventory_bloc.dart';
import 'package:proyecto_integrador/presentation/blocs/inventory/inventory_event.dart';
import 'package:proyecto_integrador/presentation/blocs/inventory/inventory_state.dart';
import 'package:proyecto_integrador/presentation/blocs/issue/issue_bloc.dart';
import 'package:proyecto_integrador/presentation/blocs/issue/issue_event.dart';
// ignore: unused_import
import 'package:proyecto_integrador/presentation/blocs/issue/issue_state.dart';
import 'package:proyecto_integrador/presentation/blocs/login/login_bloc.dart';
import 'package:proyecto_integrador/presentation/widgets/editar_inventario.dart';
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
    context.read<InventoryBloc>().add(const LoadInventoriesEvent(''));
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
    final List<Color> colores = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.cyan,
  ];

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
                                String idInventario = inventory.idInventory.toString();
                                context.read<IssueBloc>().add(LoadIssuesEvent(filter: idInventario));
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
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 4.0,
                                        height: 90.0,
                                        color: colores[inventory.idInventory],
                                        child: const Text(" "),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          title: Text('Modelo: ${inventory.model} ( ${inventory.brand} )'),
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
                                      const Spacer(),
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
                                          showDialog<void>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Informacion de la edicion del inventario'),
                                                content: Text(
                                                  'id del inventario: ${result['idInventory']}\n'
                                                  'Número de serie: ${result['numSerie']}\n'
                                                  'Marca: ${result['marca']}\n'
                                                  'Modelo: ${result['modelo']}\n'
                                                  'Aula: ${result['aula']}\n'
                                                  'Tipo: ${result['tipo']}\n'
                                                  'gvaCodArticle: ${result['gvaCodArticle']}\n'
                                                  'gvaDescriptionCodArticulo: ${result['gvaDescriptionCodArticulo']}\n'
                                                  'Estado: ${result['estado']}\n',
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
            context.read<InventoryBloc>().add(
              CreateInventoryEvent(
                idInventory: result['numSerie'],
                numSerie: result['numSerie'],
                marca: result['marca'],
                modelo: result['modelo'],
                aula: result['aula'],
                tipo: result['tipo'],
                estado: result['estado'],
                gvaCodArticle: result['gvaCodArticle'],
                gvaDescriptionCodArticulo: result['gvaDescriptionCodArticulo'],
              ),
            );
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Información del inventario nuevo'),
                  content: Text(
                    'Número de serie: ${result['numSerie']}\n'
                    'Marca: ${result['marca']}\n'
                    'Modelo: ${result['modelo']}\n'
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
