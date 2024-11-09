import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_integrador/presentation/blocs/login/login_bloc.dart';
import 'package:proyecto_integrador/presentation/widgets/filtrar_issue.dart';
import 'package:proyecto_integrador/presentation/widgets/themes_log_out.dart';

class TechnicScreen extends StatelessWidget {
  const TechnicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginState = context.read<LoginBloc>().state;
    final nombreUser = loginState.user?.name;
    final iniciales = nombreUser?.substring(0, 2).toUpperCase();
    final idTechnic = loginState.user?.id;

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
          ],
        ),
        centerTitle: true,
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
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Aquestes són les incidències que t'han asignat:",
                textAlign: TextAlign.center,
              ),
              const Divider(
                color: Color.fromARGB(255, 71, 71, 71), 
                thickness: 1, 
              ),
              Column(
                children: [
                  const Text("Filtrar: "),
                    IconButton(
                      icon: const Icon(Icons.filter_alt),
                      onPressed: () async {
                        final result = await showDialog<Map<String, dynamic>?>(context: context, builder: (BuildContext context) {
                          return const AlertDialog(
                            title: Text('Filtrar incidèncias'),
                            content: FiltrarIssue(),
                          );
                        });
                        if (result != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              final idStatus = result['idStatus'] != null ? result['idStatus'].toString() : 'No seleccionat';
                              final createdAt = result['createdAt'] ?? 'No seleccionat';

                              return AlertDialog(
                                title: const Text('Resultat del filtre'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    //estos datos se le van a enviar al bloc al hacer el filtro, en el screen del user solo enviara los parametros de idTechnic, idStatus y createdAt, para que el bloc devuelva solo los issues con idTechnic igual al envidao, idStatus igual al envidao y createdAt en el que sea del mismo dia
                                    Text('idTechnic: $idTechnic'),
                                    Text('idStatus: $idStatus'),
                                    Text('createdAt: $createdAt'),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                ],
              ),
              const Divider(
                color: Color.fromARGB(255, 71, 71, 71), 
                thickness: 1, 
              ),
              const Text("Aqui ira lo da incidèncias"),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Crea una incidència'),
                content: const Text('La funció de crear una incidència no funciona de moment...'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        },
        child: const Text("+"),
      ),
    );
  }
}