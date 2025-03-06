import 'package:flutter/material.dart';
import '../commons/priceformat.dart';
import '../repositories/OrderRepository.dart';
import '../repositories/ProductRepository.dart';
import '../models/user.dart';
import '../models/product.dart';
import '../commons/snacksbar.dart';
import '../commons/constants.dart';
import '../commons/dialogs.dart';
import '../models/order.dart';
import '../widgets/productlist.dart';
import 'package:logger/logger.dart';
import 'pantallaprincipal.dart';

class ShoppingPage extends StatefulWidget {
  final User usuario;
  const ShoppingPage({super.key, required this.usuario});

  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  final ProductRepository _productRepository = ProductRepository();
  final OrderRepository _orderRepository = OrderRepository();
  final logger = Logger();

  List<Product> productos = [];
  Map<int, int> cantidades = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    try {
      setState(() => isLoading = true);
      final loadedProducts = await _productRepository.listarProductos();
      setState(() {
        productos = loadedProducts;
        isLoading = false;
      });
    } catch (e) {
      logger.e("Error al cargar productos: $e");
      setState(() => isLoading = false);
      if (mounted) {
        SnaksBar.showSnackBar(context, "Error al cargar productos: $e",
            color: Constants.errorColor);
      }
    }
  }

  double calcularTotal() {
    double total = 0;
    for (var producto in productos) {
      int cantidad = cantidades[producto.id!] ?? 0;
      total += cantidad * producto.precio;
    }
    return total;
  }

  void incrementarCantidad(Product producto) {
    if (producto.id == null) return;

    setState(() {
      int cantidadActual = cantidades[producto.id!] ?? 0;
      if (cantidadActual < producto.cantidad) {
        cantidades[producto.id!] = cantidadActual + 1;
      } else {
        SnaksBar.showSnackBar(context, "No hay suficiente stock disponible",
            color: Constants.warningColor);
      }
    });
  }

  void decrementarCantidad(Product producto) {
    if (producto.id == null) return;

    setState(() {
      int cantidadActual = cantidades[producto.id!] ?? 0;
      if (cantidadActual > 0) {
        cantidades[producto.id!] = cantidadActual - 1;
      }
    });
  }

  bool validarStock() {
    for (var producto in productos) {
      if (producto.id == null) continue;

      int cantidad = cantidades[producto.id!] ?? 0;
      if (cantidad > producto.cantidad) {
        SnaksBar.showSnackBar(context,
            "${producto.nombre}: No hay suficiente stock. Stock disponible: ${producto.cantidad}",
            color: Constants.errorColor);
        return false;
      }
    }
    return true;
  }

  void realizarCompra() {
    bool hayProductos = cantidades.values.any((cantidad) => cantidad > 0);
    if (!hayProductos) {
      SnaksBar.showSnackBar(context, "Seleccione al menos un producto",
          color: Constants.warningColor);
      return;
    }

    if (!validarStock()) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        double total = calcularTotal();
        return AlertDialog(
          title: const Text("Confirmar Compra"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Resumen del pedido:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...productos.map((producto) {
                  if (producto.id == null) return const SizedBox.shrink();

                  int cantidad = cantidades[producto.id!] ?? 0;
                  if (cantidad > 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                          "${producto.nombre}: $cantidad x ${PriceFormat.formatPrice(producto.precio)}"),
                    );
                  }
                  return const SizedBox.shrink();
                }),
                const Divider(),
                Text("Total: ${PriceFormat.formatPrice(total)}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                confirmarCompra();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Constants.primaryColor,
              ),
              child: const Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }

  Future<void> confirmarCompra() async {
    try {
      if (!mounted) return;
      await Dialogs.showLoadingSpinner(context);

      // Validar stock antes de proceder
      if (!validarStock()) {
        Navigator.of(context).pop(); // Cerrar el spinner
        return;
      }

      // Generar un número de pedido único basado en la marca de tiempo
      int numeroTemp = DateTime.now().millisecondsSinceEpoch % 1000000;
      Map<String, int> numeroPedido = {'numero': numeroTemp};

      // Convertir el mapa de productos a un formato más detallado
      Map<String, dynamic> detalleProductos = {};
      double total = 0.0;
      String descripcion = '';

      for (var producto in productos) {
        if (producto.id == null) continue;
        int cantidad = cantidades[producto.id!] ?? 0;
        if (cantidad > 0) {
          detalleProductos[producto.id.toString()] = {
            'cantidad': cantidad,
            'nombre': producto.nombre,
            'precio': producto.precio,
          };
          total += cantidad * producto.precio;
          descripcion += "${producto.nombre} x$cantidad, ";
        }
      }

      if (descripcion.isNotEmpty) {
        descripcion = descripcion.substring(0, descripcion.length - 2);
      }

      // Crear y guardar el pedido
      Order pedido = Order(
        id: null,
        comprador: widget.usuario.nombre,
        descripcion: descripcion,
        precio: total,
        estado: "Pendiente",
        numeroPedido: numeroPedido,
        detalleProductos: detalleProductos,
      );

      await _orderRepository.agregarOrden(pedido);

      // Actualizar el stock de los productos
      for (var producto in productos) {
        if (producto.id == null) continue;
        int cantidad = cantidades[producto.id!] ?? 0;
        if (cantidad > 0) {
          Product productoActualizado = Product(
            id: producto.id,
            nombre: producto.nombre,
            descripcion: producto.descripcion,
            precio: producto.precio,
            cantidad: producto.cantidad - cantidad,
            imagenProducto: producto.imagenProducto,
          );
          await _productRepository.modificarProducto(
              producto.id!.toString(), productoActualizado);
        }
      }

      // Recargar productos y limpiar cantidades
      await _cargarProductos();
      setState(() => cantidades.clear());

      if (mounted) {
        Navigator.of(context).pop(); // Cerrar el spinner
        SnaksBar.showSnackBar(
          context, 
          "Pedido #${numeroPedido['numero']} realizado con éxito",
          color: Constants.successColor
        );
      }
    } catch (e) {
      logger.e("Error al realizar la compra: $e");
      if (mounted) {
        SnaksBar.showSnackBar(context, "Error al realizar la compra: $e",
            color: Constants.errorColor);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.primaryColor,
        title: const Text(
          'Compras',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      if (productos.isEmpty)
                        const Center(
                          child: Text(
                            "No hay productos disponibles",
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      else
                        ...productos.map((producto) {
                          int currentQuantity = cantidades[producto.id!] ?? 0;
                          return ProductListItem(
                            producto: producto,
                            cantidad: currentQuantity,
                            onIncrement: () => incrementarCantidad(producto),
                            onDecrement: () => decrementarCantidad(producto),
                          );
                        }),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
                if (productos.isNotEmpty)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: ElevatedButton.icon(
                      onPressed: realizarCompra,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Constants.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.shopping_cart),
                      label: Text(
                        "Realizar Compra (${PriceFormat.formatPrice(calcularTotal())})",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
