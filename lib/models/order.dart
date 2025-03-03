class Order {
  String id;
  String usuario;
  Map<String, int> productos;
  double total;
  String estado;

  Order({
    required this.id,
    required this.usuario,
    required this.productos,
    required this.total,
    required this.estado,
  });
}
