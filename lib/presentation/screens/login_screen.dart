import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_integrador/presentation/blocs/login/login_bloc.dart';
import 'package:proyecto_integrador/presentation/blocs/login/login_event.dart';
import 'package:proyecto_integrador/presentation/blocs/login/login_state.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
 const LoginScreen({super.key});

 @override
 State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 final _emailController = TextEditingController();
 final _passwordController = TextEditingController();

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: const Text('Incidències'),
     centerTitle: true,),
     body: Padding(
       padding: const EdgeInsets.all(16.0),
       child: Column(
         children: [
          const Center(child: Text("IES Estació"),
          ),
           TextField(
             controller: _emailController,
             decoration: const InputDecoration(labelText: 'Email'),
           ),
           TextField(
             controller: _passwordController,
             decoration: const InputDecoration(labelText: 'Password'),
             obscureText: true,
           ),
           const SizedBox(height: 20),
           BlocConsumer<LoginBloc, LoginState>(
             listener: (context, state) {
               if (state.user != null) {
                 context.go('/home');
               } else if (state.errorMessage.isNotEmpty) {
                 ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(content: Text(state.errorMessage)),
                 );
               }
             },
             builder: (context, state) {
               if (state.isLoading) {
                 return const CircularProgressIndicator();
               }
               return ElevatedButton(
                 onPressed: () {
                   context.read<LoginBloc>().add(
                         LoginButtonPressed(
                           _emailController.text,
                           _passwordController.text,
                         ),
                       );
                 },
                 child: const Text('Acceder'),
               );
             },
           ),
         ],
       ),
     ),
   );
 }
}