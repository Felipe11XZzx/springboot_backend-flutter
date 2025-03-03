import 'package:flutter/material.dart';
import 'package:inicio_sesion/logica/orderlogic.dart';
import 'package:inicio_sesion/widgets/orderlist.dart';
import 'package:inicio_sesion/models/order.dart';
import 'package:inicio_sesion/commons/dialogs.dart';
import 'package:inicio_sesion/commons/constants.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  Future<void> _confirmAndChangeEstado(
      Order pedido, String? nuevoEstado) async {
    if (nuevoEstado == null) return;

    bool? confirmado = await Dialogs.showConfirmDialog(
        context: context,
        title: "Confirmar cambio de estado",
        content:
            "¿Está seguro de cambiar el estado del pedido a '$nuevoEstado'?", style: Text(''));

    if (confirmado != true) return;

    await Dialogs.showLoadingSpinner(context);

    setState(() {
      pedido.estado = nuevoEstado;
    });

    Dialogs.showSnackBar(context, "Estado actualizado a '$nuevoEstado'",
        color: Constants.estadoColores[nuevoEstado]);
  }

  @override
  Widget build(BuildContext context) {

    List<Order> listOrders = OrderLogic.pedidos; 
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Pedidos"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        itemCount: listOrders.length,
        itemBuilder: (context, index) {
          Order pedido = listOrders[index];
          return OrderListItem(
            pedido: pedido,
            onEstadoChanged: (nuevoEstado) {
              if (nuevoEstado != pedido.estado) {
                _confirmAndChangeEstado(pedido, nuevoEstado);
              }
            },
          );
        },
      ),
    );
  }
}