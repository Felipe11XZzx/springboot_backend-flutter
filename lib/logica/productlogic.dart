import '../models/product.dart';

class ProductLogic {
  static final List<Product> productos = [
    Product(
      id: "p1",
      nombre: "Caldera Vaillant",
      descripcion: "Aire acondicionado elegante y eficiente con tecnología avanzada de control y purificación del aire.",
      imagen: "assets/images/caldera_vaillant.png",
      stock: 10,
      precio: 850.0,
    ),
    Product(
      id: "p2",
      nombre: "Aire Acondicionado Mitsubishi",
      descripcion: "Split premium con alta eficiencia energética, filtrado avanzado y control inteligente.",
      imagen: "assets/images/mitsubishi_aire.png",
      stock: 5,
      precio: 1500.0,
    ),
    Product(
      id: "p3",
      nombre: "Aire Acondicionado Daikin",
      descripcion: "Aire acondicionado elegante y eficiente con tecnología avanzada de control y purificación del aire.",
      imagen: "assets/images/daikin_aire.png",
      stock: 8,
      precio: 975.0,
    ),
  ];

  static void addProduct(Product product) {
    productos.add(product);
  }

  static void updateProduct(Product product) {
    int index = productos.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      productos[index] = product;
    }
  }

  static void deleteProduct(String id) {
    productos.removeWhere((p) => p.id == id);
  }
}
