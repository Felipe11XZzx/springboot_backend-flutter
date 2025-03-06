import 'package:flutter/material.dart';
import '../widgets/orderlist.dart';
import '../models/order.dart';
import '../commons/dialogs.dart';
import '../commons/constants.dart';
import '../commons/snacksbar.dart';
import '../repositories/OrderRepository.dart';
import 'package:logger/logger.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  final OrderRepository _orderRepository = OrderRepository();
  final logger = Logger();
  List<Order> _pedidos = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarPedidos();
  }

  Future<void> _cargarPedidos() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final pedidos = await _orderRepository.listarOrdenes();
      setState(() {
        _pedidos = pedidos;
        _isLoading = false;
      });
    } catch (e) {
      logger.e("Error al cargar pedidos: $e");
      setState(() {
        _error = "Error al cargar los pedidos";
        _isLoading = false;
      });
      if (mounted) {
        SnaksBar.showSnackBar(
          context,
          "Error al cargar los pedidos: $e",
          color: Constants.errorColor,
        );
      }
    }
  }

  Future<void> _actualizarEstadoPedido(Order pedido, String nuevoEstado) async {
    try {
      Order pedidoActualizado = Order(
        id: pedido.id,
        comprador: pedido.comprador,
        descripcion: pedido.descripcion,
        precio: pedido.precio,
        estado: nuevoEstado,
        numeroPedido: pedido.numeroPedido,
        detalleProductos: pedido.detalleProductos,
      );

      await _orderRepository.modificarOrden(
        pedido.id!.toString(),
        pedidoActualizado,
      );

      await _cargarPedidos();
      if (mounted) {
        SnaksBar.showSnackBar(
          context,
          "Estado actualizado a '$nuevoEstado'",
          color: Constants.estadoColores[nuevoEstado],
        );
      }
    } catch (e) {
      logger.e("Error al actualizar estado: $e");
      if (mounted) {
        SnaksBar.showSnackBar(
          context,
          "Error al actualizar el estado: $e",
          color: Constants.errorColor,
        );
      }
    }
  }

  Future<void> _confirmAndChangeEstado(
      Order pedido, String? nuevoEstado) async {
    if (nuevoEstado == null) return;

    bool? confirmado = await Dialogs.showConfirmDialog(
      context: context,
      title: "Confirmar cambio de estado",
      content: "¿Está seguro de cambiar el estado del pedido a '$nuevoEstado'?",
      style: const Text(''),
    );

    if (confirmado != true) return;

    await Dialogs.showLoadingSpinner(context);
    await _actualizarEstadoPedido(pedido, nuevoEstado);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Pedidos"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarPedidos,
            tooltip: "Recargar pedidos",
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Constants.errorColor,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _cargarPedidos,
                        icon: const Icon(Icons.refresh),
                        label: const Text("Reintentar"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Constants.primaryColor,
                        ),
                      ),
                    ],
                  ),
                )
              : _pedidos.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "No hay pedidos pendientes",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _cargarPedidos,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _pedidos.length,
                        itemBuilder: (context, index) {
                          Order pedido = _pedidos[index];
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
                    ),
    );
  }
}
