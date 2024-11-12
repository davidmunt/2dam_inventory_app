import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_integrador/presentation/blocs/inventory/inventory_bloc.dart';
import 'package:proyecto_integrador/presentation/blocs/inventory/inventory_event.dart';
import 'package:proyecto_integrador/presentation/blocs/issues/issue_bloc.dart';
import 'package:proyecto_integrador/presentation/blocs/issues/issue_event.dart';
// ignore: unused_import
import 'package:proyecto_integrador/presentation/blocs/issues/issue_state.dart';
import 'package:proyecto_integrador/presentation/blocs/login/login_bloc.dart';
import 'package:proyecto_integrador/presentation/widgets/crear_issue.dart';
import 'package:proyecto_integrador/presentation/widgets/filtrar_issue.dart';
import 'package:proyecto_integrador/presentation/widgets/mostrar_inventario.dart';
import 'package:proyecto_integrador/presentation/widgets/mostrar_issues.dart';
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
    context.read<IssueBloc>().add(LoadIssuesEvent());
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
    final idUser = loginState.user?.id;
    final List<Color> colores = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.cyan,
    Colors.black,
    Colors.amber,
    Colors.indigo,
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
                  Expanded(child: MostrarInventario(colores: colores)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Apartat de Incidències",
                    textAlign: TextAlign.center,
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 71, 71, 71),
                    thickness: 1,
                  ),
                  const Expanded(child: MostrarIssues()),
                  const Divider(
                    color: Color.fromARGB(255, 71, 71, 71), 
                    thickness: 1, 
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          final result = await showModalBottomSheet<Map<String, dynamic>?>(context: context, isScrollControlled: true, builder: (BuildContext context) {
                              return const SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CrearIssue(),
                                ),
                              );
                            },
                          );
                          if (result != null) {
                            final idInventory = result['idInventory'];
                            final description = result['description'];
                            final notes = result['notes'];
                            context.read<IssueBloc>().add(AddIssueEvent(description: description, notes: notes, idInventory: idInventory, idUser: idUser ?? 1, idTecnic: 2, idStatus: 1,));
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_alt),
                        onPressed: () async {
                          final result = await showDialog<Map<String, dynamic>?>(context: context, builder: (BuildContext context) {
                            return const AlertDialog(
                              title: Text('Filtrar incidències'),
                              content: FiltrarIssue(),
                            );
                          });
                          if (result != null) {
                            final idStatus = result['idStatus'] ?? 1;
                            final createdAt = result['createdAt'] as DateTime?;
                            context.read<IssueBloc>().add(FilterIssuesEvent(idStatus: idStatus, createdAt: createdAt));
                          }
                        },
                      ),
                    ]
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
