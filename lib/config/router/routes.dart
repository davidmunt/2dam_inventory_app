import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
// ignore: unused_import
import 'package:proyecto_integrador/domain/repositories/login_repository.dart';
import 'package:proyecto_integrador/presentation/blocs/login/login_bloc.dart';
import 'package:proyecto_integrador/presentation/screens/login_screen.dart';
import 'package:proyecto_integrador/presentation/screens/admin_screen.dart';
import 'package:proyecto_integrador/presentation/screens/technic_screen.dart';
import 'package:proyecto_integrador/presentation/screens/user_screen.dart';
// ignore: unused_import
import 'package:proyecto_integrador/injection_container.dart' as di;

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/admin',
      builder: (BuildContext context, GoRouterState state) {
        return const AdminScreen();
      },
    ),
    GoRoute(
      path: '/technic',
      builder: (BuildContext context, GoRouterState state) {
        return const TechnicScreen();
      },
    ),
    GoRoute(
      path: '/user',
      builder: (BuildContext context, GoRouterState state) {
        return const UserScreen();
      },
    ),
  ],
  redirect: (context, state) async {
  final loginBloc = context.read<LoginBloc>().state;
  if (loginBloc.user == null && !state.matchedLocation.contains("/login")) {
    return "/login";
  } else if (loginBloc.user != null) {
    switch (loginBloc.user!.type) {
      case 1:
        return '/admin';
      case 2:
        return '/technic';
      case 3:
        return '/user';
    }
  }
  return null;
},

);
