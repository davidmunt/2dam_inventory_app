import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_integrador/presentation/blocs/login/login_bloc.dart';
import 'package:proyecto_integrador/presentation/blocs/login/login_event.dart';
import 'package:proyecto_integrador/presentation/blocs/themes/themes_bloc.dart';
import 'package:proyecto_integrador/presentation/blocs/themes/themes_event.dart';
import 'package:proyecto_integrador/presentation/blocs/themes/themes_state.dart';

void showLogoutDialog(BuildContext context) {
  final loginState = context.read<LoginBloc>().state;
  final emailUser = loginState.user?.email;
  final nombreUser = loginState.user?.name;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emailUser!),
            const SizedBox(height: 10),
            Text(
              nombreUser!,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 16),
            const Divider(
              color: Color.fromARGB(255, 96, 96, 96),
              thickness: 1,
            ),
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text("Settings: "),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.settings),
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return BlocBuilder<ThemeBloc, ThemeState>(
                          builder: (context, themeState) {
                            return AlertDialog(
                              title: const Text('Ajustes cambio tema'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text("Seleccionar color del tema"),
                                  Slider(
                                    value: themeState.colorTheme.toDouble(),
                                    max: 8,
                                    divisions: 8,
                                    label: themeState.colorTheme.round().toString(),
                                    onChanged: (double value) {
                                      context.read<ThemeBloc>().add(
                                        ThemeChanged(value.round(), themeState.darkMode, themeState.fontFamily)
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  const Text('Modo oscuro'),
                                  SwitchListTile(
                                    title: const Text('Modo oscuro'),
                                    value: themeState.darkMode,
                                    onChanged: (bool? value) {
                                      context.read<ThemeBloc>().add(ThemeChanged(themeState.colorTheme, value ?? false, themeState.fontFamily));
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  const Text("Seleccionar fuente"),
                                  DropdownButton<String>(
                                    value: themeState.fontFamily,
                                    onChanged: (String? newFont) {
                                      context.read<ThemeBloc>().add(
                                        ThemeChanged(themeState.colorTheme, themeState.darkMode, newFont!)
                                      );
                                    },
                                    items: ["Roboto", "Arimo", "Tinos", "Oswald"].map((font) {
                                      return DropdownMenuItem(
                                        value: font,
                                        child: Text(font, style: TextStyle(fontFamily: font)),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cerrar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(
              color: Color.fromARGB(255, 71, 71, 71),
              thickness: 1,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text("Logout: "),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Estas seguro de cerrar la sesion'),
                          content: const Column(
                            mainAxisSize: MainAxisSize.min,
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancelar'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context.read<LoginBloc>().add(LogoutButtonPressed());
                                Navigator.of(context).pop();
                                context.go('/login');
                              },
                              child: const Text('Cerrar Sesion'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
