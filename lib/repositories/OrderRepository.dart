import 'package:inicio_sesion/models/order.dart';
import 'package:inicio_sesion/services/ApiService.dart';

class OrderRepository {
  final ApiService _apiService = ApiService();

  Future<List<Order>> listarOrdenes() async {
    try {
      final response = await _apiService.dio.get('/orders');
      return (response.data as List)
          .map((order) => Order.fromJson(order))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener las ordenes: $e');
    }
  }

  Future<void> agregarOrden(Order order) async {
    try {
      await _apiService.dio.post('/orders', data: order.toJson());
    } catch (e) {
      throw Exception('Error al agregar orden: $e');
    }
  }

  Future<void> modificarOrden(String id, Order order) async {
    try {
      await _apiService.dio.put('/orders/$id', data: order.toJson());
    } catch (e) {
      throw Exception('Error al actualizar orden: $e');
    }
  }

  Future<void> borrarOrden(String id) async {
    try {
      await _apiService.dio.delete('/orders/$id');
    } catch (e) {
      throw Exception('Error al eliminar orden: $e');
    }
  }
}
