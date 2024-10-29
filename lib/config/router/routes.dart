import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_integrador/domain/repositories/login_repository.dart';
import 'package:proyecto_integrador/presentation/blocs/login/login_bloc.dart';
import 'package:proyecto_integrador/presentation/screens/login_screen.dart';
import 'package:proyecto_integrador/presentation/screens/admin_screen.dart';
import 'package:proyecto_integrador/presentation/screens/technic_screen.dart';
import 'package:proyecto_integrador/presentation/screens/user_screen.dart';
import 'package:proyecto_integrador/injection_container.dart' as di;

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => BlocProvider(
        create: (context) => di.sl<LoginBloc>(),
        child: const LoginScreen(),
      ),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(
            create: (BuildContext context) => di.sl<LoginBloc>(),
          ),
        ],
        child: const AdminScreen(),
      ),
    ),
    GoRoute(
      path: '/technic',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(
            create: (BuildContext context) => di.sl<LoginBloc>(),
          ),
        ],
        child: const TechnicScreen(),
      ),
    ),
    GoRoute(
      path: '/user',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(
            create: (BuildContext context) => di.sl<LoginBloc>(),
          ),
        ],
        child: const UserScreen(),
      ),
    ),
  ],
  redirect: (context, state) async {
    final isLoggedIn = await di.sl<LoginRepository>().isLoggedIn();
    return isLoggedIn.fold((_) => '/login', (loggedIn) {
        if (!loggedIn && !state.matchedLocation.contains("/login")) {
          return "/login";
        } else {
          final loginState = context.read<LoginBloc>().state;
          if (loginState.user != null) {
            switch (loginState.user!.type) {
              case 1:
                return '/admin';
              case 2:
                return '/technic';
              case 3:
                return '/user';
              default:
                return '/login';
            }
          }
          return '/login';
        }
      },
    );
  },
);
