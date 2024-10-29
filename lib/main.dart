import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:proyecto_integrador/presentation/blocs/login/login_bloc.dart';
import 'package:proyecto_integrador/presentation/blocs/themes/themes_bloc.dart';
import 'package:proyecto_integrador/presentation/blocs/themes/themes_state.dart';
import 'package:proyecto_integrador/config/theme/app_theme.dart';
import 'package:proyecto_integrador/config/router/routes.dart';
import 'injection_container.dart' as injection_container;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await injection_container.init(); 
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => injection_container.sl<LoginBloc>(),
        ),
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            theme: AppTheme(
              isDarkmode: state.darkMode,
              selectedColor: state.colorTheme,
            ).getTheme(),
          );
        },
      ),
    );
  }
}
