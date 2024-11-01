import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_integrador/presentation/blocs/login/login_bloc.dart';
import 'package:proyecto_integrador/presentation/widgets/themes_log_out.dart';

class TechnicScreen extends StatelessWidget {
  const TechnicScreen({super.key});

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
          ],
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // Llama a la función que muestra el diálogo de cierre de sesión
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
      body: const Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Aquestes són les teues incidències assignades:",
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