import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_integrador/presentation/blocs/issues/issue_bloc.dart';
import 'package:proyecto_integrador/presentation/blocs/issues/issue_event.dart';
import 'package:proyecto_integrador/presentation/blocs/issues/issue_state.dart';
import 'package:proyecto_integrador/presentation/widgets/crear_issue.dart';
import 'package:proyecto_integrador/presentation/widgets/editar_issue.dart';

class MostrarIssues extends StatelessWidget {
  final int? idUser;
  final int? idTechnic;

  const MostrarIssues({super.key, this.idUser, this.idTechnic});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IssueBloc, IssueState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              'Error: ${state.errorMessage}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (state.allIssues.isEmpty) {
          return const Center(
            child: Text('No hi ha incidències disponibles.'),
          );
        } else {
          return SingleChildScrollView(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.filteredIssues.length,
              itemBuilder: (context, index) {
                if (idUser != null) {
                  context.read<IssueBloc>().add(FilterIssuesEvent(idUser: idUser));
                }
                if (idTechnic != null) {
                  context.read<IssueBloc>().add(FilterIssuesEvent(idTechnic: idTechnic));
                }
                final issue = state.filteredIssues[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    title: Text(issue.description),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Id Issue: ${issue.idIssue}'),
                        Text('Id Inventario: ${issue.idInventory}'),
                        Text('Nota: ${issue.notes}'),
                        Text('Fecha creación: ${DateFormat('yyyy/MM/dd').format(issue.createdAt)}'),
                        Text('Ultima edicion: ${DateFormat('yyyy/MM/dd').format(issue.lastUpdated)}'),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () async {
                                  final result = await showModalBottomSheet<Map<String, dynamic>?>(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: EditarIssue(
                                            initialIdInventory: issue.idInventory,
                                            initialIdStatus: issue.idStatus,
                                            initialDescription: issue.description,
                                            initialNotes: issue.notes,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                  if (result != null) {
                                    context.read<IssueBloc>().add(UpdateIssueEvent(
                                      idIssue: issue.idIssue,
                                      description: result['description'],
                                      notes: result['notes'],
                                      idUser: issue.idUser,
                                      idTecnic: issue.idTecnic,
                                      idStatus: result['idStatus'],
                                      idInventory: result['idInventory'],
                                      createdAt: issue.createdAt,
                                    ));
                                  }
                                },
                                child: const Text("Modificar"),
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("¿Estas seguro de eliminar esta incidencia?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Cancelar"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              context.read<IssueBloc>().add(DeleteIssueEvent(issue.idIssue));
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Eliminando la incidencia'),
                                                ),
                                              );
                                            },
                                            child: const Text("Continuar"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text("Eliminar"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (issue.idStatus != 4)
                          Chip(
                            label: const Text(
                              'Oberta',
                              style: TextStyle(color: Colors.redAccent, fontSize: 12),
                            ),
                            backgroundColor: Colors.red.withOpacity(0.2),
                            shape: const StadiumBorder(
                              side: BorderSide(
                                color: Colors.redAccent,
                                width: 1.5,
                              ),
                            ),
                          ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
