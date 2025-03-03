import 'package:inicio_sesion/models/user.dart';
import 'package:inicio_sesion/services/ApiService.dart';

class UserRepository {
  final ApiService _apiService = ApiService();

  Future<List<User>> listarUsuarios() async {
    try {
      final response = await _apiService.dio.get('/users/getall');
      return (response.data as List)
          .map((user) => User.fromJson(user))
          .toList();
    } catch (e) {
      throw Exception("Error en la API al obtener los usuarios: $e");
    }
  }

  Future<void> anadirUsuario(User user) async {
    await _apiService.dio.post('/users', data: user.toJson());
  }

  Future<void> actualizarUsuario(String id, User user) async {
    await _apiService.dio.put('/users/$id', data: user.toJson());
  }

  Future<void> eliminarUsuario(String id) async {
    await _apiService.dio.delete('/users/$id');
  }
}
