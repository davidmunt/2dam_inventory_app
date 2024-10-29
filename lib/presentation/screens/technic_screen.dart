import 'package:flutter/material.dart';

class TechnicScreen extends StatelessWidget {
  const TechnicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pantalla Tecnico")),
      body: const Center(child: Text("Bienvenido, tecnico")),
    );
  }
}