import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_integrador/presentation/blocs/inventory/inventory_event.dart';
import 'package:proyecto_integrador/presentation/blocs/issues/issue_bloc.dart';
import 'package:proyecto_integrador/presentation/blocs/issues/issue_event.dart';
import 'package:proyecto_integrador/presentation/blocs/issues/issue_state.dart';
import 'package:proyecto_integrador/presentation/blocs/login/login_bloc.dart';
import 'package:proyecto_integrador/presentation/widgets/crear_issue.dart';
import 'package:proyecto_integrador/presentation/widgets/filtrar_issue.dart';
import 'package:proyecto_integrador/presentation/widgets/themes_log_out.dart';
import 'package:proyecto_integrador/presentation/widgets/mostrar_issues.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginState = context.read<LoginBloc>().state;
    final nombreUser = loginState.user?.name;
    final iniciales = nombreUser?.substring(0, 2).toUpperCase();
    final idUser = loginState.user?.id;
    context.read<IssueBloc>().add(LoadIssuesEvent());
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
              Expanded(child: MostrarIssues(idUser: idUser!)),
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
                        final idStatus = result['idStatus'];
                        final createdAt = result['createdAt'] as DateTime?;
                        context.read<IssueBloc>().add(FilterIssuesEvent(idUser: idUser, idStatus: idStatus, createdAt: createdAt));
                      }
                    },
                  ),
                ]
              ),
            ],
          ),
        ),
      ),
    );
  }
}