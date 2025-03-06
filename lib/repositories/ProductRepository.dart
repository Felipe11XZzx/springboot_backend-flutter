import 'package:inicio_sesion/models/product.dart';
import 'package:inicio_sesion/services/ApiService.dart';

class ProductRepository {
  final ApiService _apiService = ApiService();

  Future<List<Product>> listarProductos() async {
    try {
      final response = await _apiService.dio.get('/products/getallproducts');
      print('API Response: ${response.data}');
      final products = (response.data as List).map((product) {
        print('Procesando producto: $product');
        return Product.fromJson(product);
      }).toList();
      print('Productos procesados: $products');
      return products;
    } catch (e) {
      print('Error en listarProductos: $e');
      throw Exception('Error al obtener los productos: $e');
    }
  }

  Future<void> agregarProducto(Product product) async {
    try {
      final data = product.toJson();
      print('Enviando producto a la API: $data');
      final response = await _apiService.dio.post('/products', data: data);
      print('Respuesta de la API al crear: ${response.data}');
    } catch (e) {
      print('Error al agregar producto: $e');
      throw Exception('Error al agregar producto: $e');
    }
  }

  Future<void> modificarProducto(String id, Product product) async {
    try {
      final data = product.toJson();
      print('Actualizando producto en la API: $data');
      final response = await _apiService.dio.put('/products/$id', data: data);
      print('Respuesta de la API al actualizar: ${response.data}');
    } catch (e) {
      print('Error al actualizar producto: $e');
      throw Exception('Error al actualizar producto: $e');
    }
  }

  Future<void> borrarProducto(String id) async {
    try {
      await _apiService.dio.delete('/products/$id');
    } catch (e) {
      throw Exception('Error al eliminar producto: $e');
    }
  }
}
