import 'package:proyecto_integrador/data/models/user_model.dart';

abstract class LoginFakeDatasource {
 Future<UserModel> getValidUser(String email, String password);
}

class LoginFakeDatasourceImpl implements LoginFakeDatasource {
  @override
  Future<UserModel> getValidUser(String email, String password) async {
    if (email == 'admin@iestacio.com' && password == 'administrador') {
      return UserModel(email: email, password: password, name: 'admin', type: 1, id: 1);
    } else if (email == 'tecnico@iestacio.com' && password == 'tecnicoReparador') {
      return UserModel(email: email, password: password, name: 'tecnico', type: 2, id: 2);
    } else if (email == 'usuario@iestacio.com' && password == 'usuarioGenerico') {
      return UserModel(email: email, password: password, name: 'usuario', type: 3, id: 3);
    } else {
      throw Exception("Credenciales de usuario no válidas");
    }
  }
}
