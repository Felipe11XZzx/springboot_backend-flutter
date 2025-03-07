import 'package:logger/logger.dart';
import 'dart:convert';

class Order {
  final int? id;
  final String descripcion;
  final String comprador;
  final int? numeroPedido;
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
    
    // Convertir detalleProductos de String a Map si es necesario
    Map<String, dynamic> detalleProd = {};
    if (json['detalleProductos'] != null) {
      if (json['detalleProductos'] is String) {
        try {
          detalleProd = Map<String, dynamic>.from(
              jsonDecode(json['detalleProductos']));
        } catch (e) {
          logger.e("Error parsing detalleProductos: $e");
        }
      } else if (json['detalleProductos'] is Map) {
        detalleProd = Map<String, dynamic>.from(json['detalleProductos']);
      }
    }
    
    // Asegurarse de que numeroPedido no sea nulo
    int? numPedido = json['numeroPedido'] as int?;
    if (numPedido == null || numPedido == 0) {
      // Generar un número de pedido basado en el timestamp si es nulo o cero
      numPedido = DateTime.now().millisecondsSinceEpoch % 900000 + 100000;
    }
    
    final order = Order(
      id: json['id'] as int?,
      comprador: json['comprador']?.toString().trim() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      precio: (json['precio'] is int)
          ? (json['precio'] as int).toDouble()
          : json['precio'] as double? ?? 0.0,
      estado: json['estado']?.toString() ?? '',
      numeroPedido: numPedido,
      detalleProductos: detalleProd,
    );
    logger.d("Parsed order: $order");
    return order;
  }

  Map<String, dynamic> toJson() {
    // Asegurarse de que numeroPedido no sea nulo
    int numPedido = numeroPedido ?? DateTime.now().millisecondsSinceEpoch % 900000 + 100000;
    
    final Map<String, dynamic> data = {
      "comprador": comprador,
      "descripcion": descripcion,
      "precio": precio,
      "estado": estado,
      "numeroPedido": numPedido,
      // Convertir el mapa a una cadena JSON para el backend
      "detalleProductos": jsonEncode(detalleProductos),
    };

    if (id != null) data["id"] = id;
    return data;
  }

  @override
  String toString() {
    return 'Order(id: $id, comprador: $comprador, descripcion: $descripcion, precio: $precio, estado: $estado, numeroPedido: $numeroPedido, detalleProductos: $detalleProductos)';
  }
}
