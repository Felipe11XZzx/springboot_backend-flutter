import 'package:inicio_sesion/models/order.dart';
import 'package:inicio_sesion/services/ApiService.dart';
import 'package:logger/logger.dart';

class OrderRepository {
  final ApiService _apiService = ApiService();
  final logger = Logger();

  Future<List<Order>> listarOrdenes() async {
    try {
      final response = await _apiService.dio.get('/orders/getallorders');
      logger.d("Respuesta de listarOrdenes: ${response.data}");
      return (response.data as List)
          .map((order) => Order.fromJson(order))
          .toList();
    } catch (e) {
      logger.e("Error al obtener las ordenes: $e");
      throw Exception('Error al obtener las ordenes: $e');
    }
  }

  Future<void> agregarOrden(Order order) async {
    try {
      final orderJson = order.toJson();
      logger.d("Enviando orden al servidor: $orderJson");
      
      // Verificar que los campos críticos no sean nulos
      if (orderJson["numeroPedido"] == null) {
        throw Exception("El número de pedido no puede ser nulo");
      }
      
      if (orderJson["descripcion"] == null || orderJson["descripcion"].toString().isEmpty) {
        throw Exception("La descripción no puede estar vacía");
      }
      
      final response = await _apiService.dio.post('/orders', data: orderJson);
      logger.d("Respuesta al agregar orden: ${response.data}");
    } catch (e) {
      logger.e("Error al agregar orden: $e");
      throw Exception('Error al agregar orden: $e');
    }
  }

  Future<void> modificarOrden(String id, Order order) async {
    try {
      final orderJson = order.toJson();
      logger.d("Modificando orden $id: $orderJson");
      final response = await _apiService.dio.put('/orders/$id', data: orderJson);
      logger.d("Respuesta al modificar orden: ${response.data}");
    } catch (e) {
      logger.e("Error al actualizar orden: $e");
      throw Exception('Error al actualizar orden: $e');
    }
  }

  Future<void> borrarOrden(String id) async {
    try {
      logger.d("Borrando orden: $id");
      final response = await _apiService.dio.delete('/orders/$id');
      logger.d("Respuesta al borrar orden: ${response.data}");
    } catch (e) {
      logger.e("Error al eliminar orden: $e");
      throw Exception('Error al eliminar orden: $e');
    }
  }
}
