import 'package:logger/logger.dart';

class Order {
  final int? id;
  final String descripcion;
  final String comprador;
  final Map<String, int> numeroPedido;
  final double precio;
  final String estado;
  final Map<String, dynamic> detalleProductos;
  static final logger = Logger();

  Order({
    required this.id,
    required this.comprador,
    required this.descripcion,
    required this.precio,
    required this.estado,
    required this.numeroPedido,
    required this.detalleProductos,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    logger.d("Parsing order from JSON: $json");
    final order = Order(
      id: json['id'] as int?,
      comprador: json['comprador']?.toString().trim() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      precio: (json['precio'] is int)
          ? (json['precio'] as int).toDouble()
          : json['precio'] as double? ?? 0.0,
      estado: json['estado']?.toString() ?? '',
      numeroPedido: json['numeroPedido'] is Map 
          ? Map<String, int>.from(json['numeroPedido'])
          : {'numero': json['numeroPedido'] as int? ?? 0},
      detalleProductos: Map<String, dynamic>.from(json['detalleProductos'] ?? {}),
    );
    logger.d("Parsed order: $order");
    return order;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "comprador": comprador,
      "descripcion": descripcion,
      "precio": precio,
      "estado": estado,
      "numeroPedido": numeroPedido,
      "detalleProductos": detalleProductos,
    };

    if (id != null) data["id"] = id;
    return data;
  }

  @override
  String toString() {
    return 'Order(id: $id, comprador: $comprador, descripcion: $descripcion, precio: $precio, estado: $estado, numeroPedido: $numeroPedido, detalleProductos: $detalleProductos)';
  }
}
