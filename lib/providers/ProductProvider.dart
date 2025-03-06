import 'package:flutter/material.dart';
import 'package:inicio_sesion/models/product.dart';
import 'package:inicio_sesion/repositories/ProductRepository.dart';

class ProductProvider with ChangeNotifier {
  final ProductRepository _productRepository = ProductRepository();

  List<Product> _products = [];
  List<Product> get products => _products;

  Future<void> fetchProductos() async {
    _products = await _productRepository.listarProductos();
    notifyListeners();
  }

  Future<List<Product>> fetcListaProductos() async {
    return await _productRepository.listarProductos();
  }

  Future<void> agregarProducto(Product product) async {
    await _productRepository.agregarProducto(product);
    fetchProductos();
  }

  Future<void> modificarProducto(String id, Product product) async {
    await _productRepository.modificarProducto(id, product);
    fetchProductos();
  }

  Future<void> borrarProducto(String id) async {
    await _productRepository.borrarProducto(id);
    fetchProductos();
  }
}
