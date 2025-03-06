class Product {
  final int? id;
  final String nombre;
  final String descripcion;
  final String? imagenProducto;
  final int cantidad;
  final double precio;

  Product({
    this.id,
    required this.nombre,
    required this.descripcion,
    this.imagenProducto = "",
    required this.cantidad,
    required this.precio,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Intentar obtener el nombre de diferentes campos posibles
    final nombre =
        json["nombreProducto"]?.toString() ?? json["name"]?.toString() ?? '';

    return Product(
      id: json["id"] as int?,
      nombre: nombre,
      descripcion: json["descripcion"]?.toString() ?? '',
      imagenProducto: json["imagenProducto"]?.toString(),
      cantidad: (json["cantidad"] as num?)?.toInt() ?? 0,
      precio: (json["precio"] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "nombreProducto":
          nombre, // Enviamos como nombreProducto ya que así lo espera la API
      "descripcion": descripcion,
      "cantidad": cantidad,
      "precio": precio,
    };

    if (id != null) data["id"] = id;
    if (imagenProducto != null && imagenProducto!.isNotEmpty) {
      data["imagenProducto"] = imagenProducto;
    }

    return data;
  }

  @override
  String toString() {
    return 'Product(id: $id, nombre: $nombre, descripcion: $descripcion, imagenProducto: $imagenProducto, cantidad: $cantidad, precio: $precio)';
  }
}
