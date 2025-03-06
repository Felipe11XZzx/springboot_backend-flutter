import 'package:flutter/material.dart';
import 'package:inicio_sesion/models/order.dart';
import 'package:inicio_sesion/repositories/OrderRepository.dart';

class OrderProvider with ChangeNotifier {
  final OrderRepository _orderRepository = OrderRepository();

  List<Order> _orders = [];
  List<Order> get orders => _orders;

  Future<void> fetchOrdenes() async {
    _orders = await _orderRepository.listarOrdenes();
    notifyListeners();
  }

  Future<List<Order>> fetcListaOrdenes() async {
    return await _orderRepository.listarOrdenes();
  }

  Future<void> agregarOrden(Order order) async {
    await _orderRepository.agregarOrden(order);
    fetchOrdenes();
  }

  Future<void> modificarOrden(String id, Order order) async {
    await _orderRepository.modificarOrden(id, order);
    fetchOrdenes();
  }

  Future<void> borrarOrden(String id) async {
    await _orderRepository.borrarOrden(id);
    fetchOrdenes();
  }
}
