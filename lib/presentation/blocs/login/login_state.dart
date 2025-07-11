import 'package:equatable/equatable.dart';
import 'package:proyecto_integrador/domain/entities/user.dart';

class LoginState extends Equatable {
 final User? user;
 final bool isLoading;
 final String errorMessage;

 const LoginState({
   this.user,
   this.isLoading = false,
   this.errorMessage = '',
 });

 LoginState copyWith({
   User? user,
   bool? isLoading,
   String? errorMessage,
 }) {
   return LoginState(
     user: user ?? this.user,
     isLoading: isLoading ?? this.isLoading,
     errorMessage: errorMessage ?? this.errorMessage,
   );
 }

 @override
 List<Object?> get props => [user, isLoading, errorMessage];
}