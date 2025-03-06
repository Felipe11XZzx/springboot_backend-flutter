import 'package:inicio_sesion/models/user.dart';
import 'package:inicio_sesion/services/ApiService.dart';
import 'package:logger/logger.dart';

class UserRepository {
  final ApiService _apiService = ApiService();
  final logger = Logger();

  Future<List<User>> listarUsuarios() async {
    try {
      final response = await _apiService.dio.get('/users/getall');
      logger.d('Respuesta de la API: ${response.data}');
      return (response.data as List)
          .map((user) => User.fromJson(user))
          .toList();
    } catch (e, stackTrace) {
      logger.e('Error en la API al obtener los usuarios:', error: e, stackTrace: stackTrace);
      throw Exception("Error en la API al obtener los usuarios: $e");
    }
  }

  Future<void> anadirUsuario(User user) async {
    try {
      final data = user.toJson();
      logger.d('Enviando datos de usuario: $data');
      await _apiService.dio.post('/users', data: data);
    } catch (e, stackTrace) {
      logger.e('Error al añadir usuario:', error: e, stackTrace: stackTrace);
      throw Exception("Error al añadir usuario: $e");
    }
  }

  Future<void> actualizarUsuario(String id, User user) async {
    try {
      final data = user.toJson();
      logger.d('Actualizando usuario $id con datos: $data');
      await _apiService.dio.put('/users/$id', data: data);
    } catch (e, stackTrace) {
      logger.e('Error al actualizar usuario:', error: e, stackTrace: stackTrace);
      throw Exception("Error al actualizar usuario: $e");
    }
  }

  Future<void> eliminarUsuario(String id) async {
    try {
      await _apiService.dio.delete('/users/$id');
    } catch (e, stackTrace) {
      logger.e('Error al eliminar usuario:', error: e, stackTrace: stackTrace);
      throw Exception("Error al eliminar usuario: $e");
    }
  }
}
