import 'package:flutter/material.dart';
import 'package:inicio_sesion/models/user.dart';
import 'package:inicio_sesion/repositories/UserRepository.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  List<User> _users = [];

  List<User> get usuarios => _users;

  Future<void> fetchUsuarios() async {
    _users = await _userRepository.listarUsuarios();
    notifyListeners();
  }

  Future<List<User>> fetchListaUsuarios() async {
    return await _userRepository.listarUsuarios();
  }

  Future<void> anadirUsuario(User user) async {
    await _userRepository.anadirUsuario(user);
    fetchUsuarios();
  }

  Future<void> actualizarUsuario(String id, User user) async {
    await _userRepository.actualizarUsuario(id, user);
    fetchUsuarios();
  }

  Future<void> eliminarUsuario(String id) async {
    await _userRepository.eliminarUsuario(id);
    fetchUsuarios();
  }
}