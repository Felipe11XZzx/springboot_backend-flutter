import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../commons/images.dart';
import '../commons/constants.dart';
import '../commons/priceformat.dart';
import '../repositories/ProductRepository.dart';
import 'package:logger/logger.dart';

class OrderListItem extends StatefulWidget {
  final Order pedido;
  final ValueChanged<String?>? onEstadoChanged;

  const OrderListItem({
    super.key,
    required this.pedido,
    this.onEstadoChanged,
  });

  @override
  State<OrderListItem> createState() => _OrderListItemState();
}

class _OrderListItemState extends State<OrderListItem> {
  final ProductRepository _productRepository = ProductRepository();
  final logger = Logger();
  Map<String, Product> _productosCache = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    try {
      setState(() => _isLoading = true);
      final productos = await _productRepository.listarProductos();
      setState(() {
        _productosCache = {for (var p in productos) p.id!.toString(): p};
        _isLoading = false;
      });
    } catch (e) {
      logger.e("Error al cargar productos: $e");
      setState(() => _isLoading = false);
    }
  }

  Product? _obtenerProducto(String id) => _productosCache[id];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: _isLoading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildProductList(),
                  const Divider(height: 24),
                  _buildFooter(),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Pedido #${widget.pedido.numeroPedido}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          "Comprador: ${widget.pedido.comprador}",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        if (widget.pedido.descripcion.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            widget.pedido.descripcion,
            style: const TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProductList() {
    if (widget.pedido.detalleProductos == null ||
        widget.pedido.detalleProductos!.isEmpty) {
      return const Center(
        child: Text(
          "No hay productos en este pedido",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Column(
      children: widget.pedido.detalleProductos!.entries.map((entry) {
        final detalles = entry.value as Map<String, dynamic>;
        return _buildProductItem(
          nombre: detalles['nombre'] as String,
          cantidad: detalles['cantidad'] as int,
          precio: (detalles['precio'] as num).toDouble(),
        );
      }).toList(),
    );
  }

  Widget _buildProductItem({
    required String nombre,
    required int cantidad,
    required double precio,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 70,
              height: 70,
              child: Image(
                image: Images.getImageProvider(
                    "assets/images/product_default.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Cantidad: $cantidad",
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  "Precio: ${PriceFormat.formatPrice(precio)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Constants.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Total: ${PriceFormat.formatPrice(widget.pedido.precio)}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        widget.onEstadoChanged != null
            ? _buildEstadoDropdown()
            : _buildEstadoText(),
      ],
    );
  }

  Widget _buildEstadoDropdown() {
    return DropdownButton<String>(
      value: widget.pedido.estado,
      underline: Container(
        height: 2,
        color: _getEstadoColor(widget.pedido.estado),
      ),
      onChanged: widget.onEstadoChanged,
      items: ["Pendiente", "En Proceso", "Completado", "Cancelado"]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              color: _getEstadoColor(value),
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEstadoText() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getEstadoColor(widget.pedido.estado).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        widget.pedido.estado,
        style: TextStyle(
          color: _getEstadoColor(widget.pedido.estado),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getEstadoColor(String estado) {
    switch (estado.toLowerCase()) {
      case "pendiente":
        return Colors.orange;
      case "en proceso":
        return Colors.blue;
      case "completado":
        return Colors.green;
      case "cancelado":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
