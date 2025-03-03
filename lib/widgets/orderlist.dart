import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../logica/productlogic.dart';
import '../commons/images.dart';
import '../commons/constants.dart';
import '../commons/priceformat.dart';

class OrderListItem extends StatelessWidget {
  final Order pedido;
  final ValueChanged<String?>? onEstadoChanged;

  const OrderListItem({
    super.key,
    required this.pedido,
    this.onEstadoChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pedido: ${pedido.id}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Usuario: ${pedido.usuario}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            ...pedido.productos.entries.map((entry) {
              final producto = ProductLogic.productos.firstWhere(
                (p) => p.id == entry.key,
                orElse: () => ProductLogic.productos.first,
              );
              return buildProductoItem(producto, entry.value);
            }),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: ${PriceFormat.formatPrice(pedido.total)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (onEstadoChanged != null)
                  buildEstadoDropdown()
                else
                  buildEstadoText(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductoItem(Product producto, int cantidad) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Image(
              image: Images.getImageProvider(producto.imagen),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto.nombre
                ),
                Text(
                  "Cantidad: $cantidad"
                ),
                Text(
                    "Precio unitario: ${PriceFormat.formatPrice(producto.precio)}"
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEstadoDropdown() {
    return DropdownButton<String>(
      value: pedido.estado,
      items: Constants.estadoIconos.keys.map((estado) {
        return DropdownMenuItem<String>(
          value: estado,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Constants.estadoIconos[estado],
                color: Constants.estadoColores[estado],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                estado,
                style: TextStyle(color: Constants.estadoColores[estado]),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: onEstadoChanged,
    );
  }

  Widget buildEstadoText() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Constants.estadoIconos[pedido.estado],
          color: Constants.estadoColores[pedido.estado],
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          pedido.estado,
          style: TextStyle(
            color: Constants.estadoColores[pedido.estado],
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
