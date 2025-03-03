import '../models/user.dart';
import '../services/user_service.dart';

class UserLogic {
  final UserService _userService = UserService();

  Future<List<User>> listarUsuarios() async {
    return await _userService.getAllUsers();
  }

  Future<void> aniadirUser(User user) async {
    await _userService.createUser(user);
  }

  Future<void> updateUser(User user) async {
    await _userService.updateUser(user.id, user);
  }

  Future<User?> findUser(String nombre) async {
    try {
      final users = await _userService.getAllUsers();
      return users.firstWhere((u) => u.nombre == nombre);
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteUser(int id) async {
    await _userService.deleteUser(id);
  }

  Future<String?> validarUser(String nombre, String password) async {
    try {
      final user = await _userService.login(nombre, password);
      if (user.bloqueado) {
        return "Usuario bloqueado, por favor contacta con el administrador";
      }
      return null;
    } catch (e) {
      return "Datos introducidos no son correctos";
    }
  }
}