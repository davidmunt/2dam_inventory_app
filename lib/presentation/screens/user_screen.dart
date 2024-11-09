import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_integrador/presentation/blocs/inventory/inventory_event.dart';
import 'package:proyecto_integrador/presentation/blocs/issues/issue_bloc.dart';
import 'package:proyecto_integrador/presentation/blocs/issues/issue_event.dart';
import 'package:proyecto_integrador/presentation/blocs/issues/issue_state.dart';
import 'package:proyecto_integrador/presentation/blocs/login/login_bloc.dart';
import 'package:proyecto_integrador/presentation/widgets/crear_issue.dart';
import 'package:proyecto_integrador/presentation/widgets/filtrar_issue.dart';
import 'package:proyecto_integrador/presentation/widgets/themes_log_out.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginState = context.read<LoginBloc>().state;
    final nombreUser = loginState.user?.name;
    final iniciales = nombreUser?.substring(0, 2).toUpperCase();
    final idUser = loginState.user?.id;
    if (idUser != null) {
      context.read<IssueBloc>().add(FilterIssuesEvent(idUser: idUser));
    }

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
                "Aquestes són les incidències que has registrat:",
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
                          title: Text('Filtrar incidències'),
                          content: FiltrarIssue(),
                        );
                      });
                      if (result != null) {
                        final idStatus = result['idStatus'] ?? 1;
                        final createdAt = result['createdAt'] as DateTime?;
                        context.read<IssueBloc>().add(FilterIssuesEvent(idUser: idUser, idStatus: idStatus, createdAt: createdAt));
                      }
                    },
                  ),
                ],
              ),
              const Divider(
                color: Color.fromARGB(255, 71, 71, 71), 
                thickness: 1, 
              ),
              const Text("Aqui mostrara las incidencias"),
              //desde aqui
              Expanded(
                child: BlocBuilder<IssueBloc, IssueState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    else if (state.errorMessage.isNotEmpty) {
                      return Center(
                        child: Text(
                          'Error: ${state.errorMessage}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    else if (state.issues.isEmpty) {
                      return const Center(
                        child: Text('No hi ha incidències disponibles.'),
                      );
                    }
                    else {
                      return SingleChildScrollView(
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.issues.length,
                          itemBuilder: (context, index) {
                            final issue = state.issues[index];
                            return ListTile(
                              title: Text(issue.description),
                              subtitle: Text(
                                'Estado: ${issue.notes} \nFecha creacion: ${DateFormat('yyyy/MM/dd').format(issue.createdAt)}',
                              ),
                              isThreeLine: true,
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),

              // hasta aqui

              //crear
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
                    // context.read<IssueBloc>().add(FilterIssuesEvent(idUser: idUser, idStatus: idStatus, createdAt: createdAt));
                  }
                },
              ),

              //filtrar
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
                    context.read<IssueBloc>().add(FilterIssuesEvent(idUser: idUser, idStatus: idStatus, createdAt: createdAt));
                  }
                },
              ),
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