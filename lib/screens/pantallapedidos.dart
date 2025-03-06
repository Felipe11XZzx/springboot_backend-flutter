import 'package:flutter/material.dart';
import '../widgets/orderlist.dart';
import '../models/user.dart';
import '../models/order.dart';
import '../repositories/OrderRepository.dart';
import '../commons/constants.dart';
import '../commons/snacksbar.dart';
import 'package:logger/logger.dart';

class OrdersPage extends StatefulWidget {
  final User usuario;

  const OrdersPage({
    super.key,
    required this.usuario,
  });

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
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
      logger.d("Pedidos recibidos del servidor: ${pedidos.length}");
      logger.d("Usuario actual: ${widget.usuario.nombre}");

      setState(() {
        _pedidos = pedidos.where((pedido) {
          logger.d(
              "Comparando pedido.comprador: '${pedido.comprador}' con usuario.nombre: '${widget.usuario.nombre}'");
          return pedido.comprador == widget.usuario.nombre;
        }).toList();
        logger.d("Pedidos filtrados para el usuario: ${_pedidos.length}");
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
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
      );
    }

    if (_pedidos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              "No has realizado ningún pedido",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.shopping_cart),
              label: const Text("Ir a Comprar"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Constants.primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _cargarPedidos,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _pedidos.length,
        itemBuilder: (context, index) {
          Order pedido = _pedidos[index];
          return OrderListItem(
            pedido: pedido,
            onEstadoChanged: (newEstado) async {
              if (newEstado == null) return;
              try {
                Order pedidoActualizado = Order(
                  id: pedido.id,
                  comprador: pedido.comprador,
                  descripcion: pedido.descripcion,
                  precio: pedido.precio,
                  estado: newEstado,
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
                    "Estado actualizado correctamente",
                    color: Constants.successColor,
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
            },
          );
        },
      ),
    );
  }
}
