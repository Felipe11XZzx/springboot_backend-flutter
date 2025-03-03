import 'package:flutter/material.dart';
import '../widgets/orderlist.dart';
import '../models/user.dart';
import '../models/order.dart';
import '../logica/orderlogic.dart';


class OrdersPage extends StatelessWidget {
  final User usuario;

  const OrdersPage({
    super.key,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    List<Order> pedidos = OrderLogic.userOrder(usuario.nombre);

    if (pedidos.isEmpty) {
      return const Center(
        child: Text(
          "No haz realizado ningún pedido",
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: pedidos.length,
      itemBuilder: (context, index) {
        Order pedido = pedidos[index];
        return OrderListItem(
          pedido: pedido,
        );
      },
    );
  }
}
