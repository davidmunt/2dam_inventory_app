import 'package:flutter/material.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_integrador/presentation/blocs/login/login_bloc.dart';
import 'package:proyecto_integrador/presentation/widgets/themes_log_out.dart';
import 'package:proyecto_integrador/presentation/widgets/crear_inventario.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Inicializa el TabController con el número de tabs y el TickerProvider
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // Asegúrate de limpiar el TabController al eliminar el widget
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
        controller: _tabController, // Asigna el TabController aquí también
        children: const [
          // Primer tab
          Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Apartat de Inventario",
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
          // Segundo tab
          Padding(
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
          // Llamar a CrearInventario como un diálogo y recibir el resultado
          final result = await showDialog<Map<String, dynamic>?>(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                title: Text('Crear inventario'),
                content: CrearInventario(),
              );
            },
          );
          if (result != null) {
            showDialog<void>(
              // ignore: use_build_context_synchronously
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Información de Inventario'),
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