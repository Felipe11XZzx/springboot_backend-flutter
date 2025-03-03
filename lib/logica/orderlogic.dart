import '../models/order.dart';

class OrderLogic {
  static final List<Order> pedidos = [];

  static void addOrder(Order pedido) {
    pedidos.add(pedido);
  }

  static List<Order> userOrder(String usuario) {
    return pedidos.where((p) => p.usuario == usuario).toList();
  }
}
