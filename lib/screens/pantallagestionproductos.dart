import 'package:flutter/material.dart';
import 'package:inicio_sesion/commons/snacksbar.dart';
import 'package:inicio_sesion/models/product.dart';
import 'package:inicio_sesion/commons/producto.dart';
import 'package:inicio_sesion/commons/validations.dart';
import 'package:inicio_sesion/commons/dialogs.dart';
import 'package:inicio_sesion/commons/images.dart';
import 'package:inicio_sesion/commons/constants.dart';
import 'package:inicio_sesion/repositories/ProductRepository.dart';
import 'package:inicio_sesion/screens/pantallaprincipal.dart';
import 'package:logger/logger.dart';

class MyProductPage extends StatefulWidget {
  const MyProductPage({super.key});

  @override
  _MyProductPageState createState() => _MyProductPageState();
}

class _MyProductPageState extends State<MyProductPage> {
  final ProductRepository _productRepository = ProductRepository();
  final logger = Logger();
  List<Product> products = [];
  final defaultImage = "assets/images/default_product.png";
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
        products = loadedProducts;
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

  void _nuevoProducto() {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController cantidadController = TextEditingController();
    String? selectedImage;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return AlertDialog(
            title: const Text("Crear Nuevo Producto"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Nombre"),
                    validator: Validations.validateRequired,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: "Descripción"),
                  ),
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: "Precio"),
                    keyboardType: TextInputType.number,
                    validator: Validations.validatePrice,
                  ),
                  TextFormField(
                    controller: cantidadController,
                    decoration: const InputDecoration(labelText: "Cantidad"),
                    keyboardType: TextInputType.number,
                    validator: Validations.validateStock,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedImage ?? "No se ha seleccionado imagen",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          String? newPath = await Images.SelectImage();
                          if (newPath != null) {
                            setDialogState(() => selectedImage = newPath);
                          }
                        },
                        icon: const Icon(Icons.image),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () async {
                  if (Validations.validateRequired(nameController.text) !=
                          null ||
                      Validations.validatePrice(priceController.text) != null ||
                      Validations.validateStock(cantidadController.text) !=
                          null) {
                    SnaksBar.showSnackBar(
                      context,
                      "Por favor, complete todos los campos correctamente",
                      color: Constants.errorColor,
                    );
                    return;
                  }

                  await Dialogs.showLoadingSpinner(context);

                  final nombre = nameController.text.trim();
                  print('Nombre del producto a crear: "$nombre"');

                  Product nuevoProducto = Product(
                    nombre: nombre,
                    descripcion: descriptionController.text.trim(),
                    precio:
                        double.parse(priceController.text.replaceAll(',', '.')),
                    cantidad: int.parse(cantidadController.text),
                    imagenProducto: selectedImage ?? defaultImage,
                  );

                  print('Nuevo producto creado localmente: $nuevoProducto');
                  print('JSON a enviar: ${nuevoProducto.toJson()}');

                  try {
                    print(
                        'Producto antes de enviarlo: ${nuevoProducto.toJson()}');
                    await _productRepository.agregarProducto(nuevoProducto);
                    print('Producto enviado exitosamente');
                    await _cargarProductos();
                    if (mounted) {
                      Navigator.pop(dialogContext);
                      SnaksBar.showSnackBar(
                        context,
                        "Producto creado correctamente",
                        color: Constants.successColor,
                      );
                    }
                  } catch (e) {
                    logger.e("Error al crear producto: $e");
                    if (mounted) {
                      SnaksBar.showSnackBar(
                        context,
                        "Error al crear el producto: $e",
                        color: Constants.errorColor,
                      );
                    }
                  }
                },
                child: const Text("Crear"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _actualizarProducto(Product producto) {
    TextEditingController nombreController =
        TextEditingController(text: producto.nombre);
    TextEditingController descripcionController =
        TextEditingController(text: producto.descripcion);
    TextEditingController precioController =
        TextEditingController(text: producto.precio.toString());
    TextEditingController cantidadController =
        TextEditingController(text: producto.cantidad.toString());
    String? selectedImage = producto.imagenProducto;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return AlertDialog(
            title: const Text("Editar Producto"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nombreController,
                    decoration: const InputDecoration(labelText: "Nombre"),
                    validator: Validations.validateRequired,
                  ),
                  TextFormField(
                    controller: descripcionController,
                    decoration: const InputDecoration(labelText: "Descripción"),
                  ),
                  TextFormField(
                    controller: precioController,
                    decoration: const InputDecoration(labelText: "Precio"),
                    keyboardType: TextInputType.number,
                    validator: Validations.validatePrice,
                  ),
                  TextFormField(
                    controller: cantidadController,
                    decoration: const InputDecoration(labelText: "Cantidad"),
                    keyboardType: TextInputType.number,
                    validator: Validations.validateStock,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedImage ?? "No se ha seleccionado imagen",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          String? newPath = await Images.SelectImage();
                          if (newPath != null) {
                            setDialogState(() => selectedImage = newPath);
                          }
                        },
                        icon: const Icon(Icons.image),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () async {
                  if (Validations.validateRequired(nombreController.text) !=
                          null ||
                      Validations.validatePrice(precioController.text) !=
                          null ||
                      Validations.validateStock(cantidadController.text) !=
                          null) {
                    SnaksBar.showSnackBar(
                      context,
                      "Por favor, complete todos los campos correctamente",
                      color: Constants.errorColor,
                    );
                    return;
                  }

                  await Dialogs.showLoadingSpinner(context);

                  final nombre = nombreController.text.trim();
                  print('Nombre del producto a actualizar: "$nombre"');

                  Product productoActualizado = Product(
                    id: producto.id,
                    nombre: nombre,
                    descripcion: descripcionController.text.trim(),
                    precio: double.parse(
                        precioController.text.replaceAll(',', '.')),
                    cantidad: int.parse(cantidadController.text),
                    imagenProducto: selectedImage ?? producto.imagenProducto,
                  );

                  print(
                      'Producto antes de actualizarlo: ${productoActualizado.toJson()}');
                  print('JSON a enviar: ${productoActualizado.toJson()}');

                  try {
                    await _productRepository.modificarProducto(
                      producto.id!.toString(),
                      productoActualizado,
                    );
                    print('Producto actualizado exitosamente');
                    await _cargarProductos();
                    if (mounted) {
                      Navigator.pop(dialogContext);
                      SnaksBar.showSnackBar(
                        context,
                        "Producto actualizado correctamente",
                        color: Constants.successColor,
                      );
                    }
                  } catch (e) {
                    logger.e("Error al actualizar producto: $e");
                    if (mounted) {
                      SnaksBar.showSnackBar(
                        context,
                        "Error al actualizar el producto: $e",
                        color: Constants.errorColor,
                      );
                    }
                  }
                },
                child: const Text("Actualizar"),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _eliminarProducto(Product producto) async {
    bool? confirmado = await Dialogs.showConfirmDialog(
      context: context,
      title: "Confirmar eliminación",
      content: "¿Está seguro de eliminar el producto '${producto.nombre}'?",
      style: const Text(''),
    );

    if (confirmado != true) return;

    await Dialogs.showLoadingSpinner(context);

    try {
      await _productRepository.borrarProducto(producto.id!.toString());
      await _cargarProductos();
      if (mounted) {
        SnaksBar.showSnackBar(
          context,
          "Producto eliminado correctamente",
          color: Constants.successColor,
        );
      }
    } catch (e) {
      logger.e("Error al eliminar producto: $e");
      if (mounted) {
        SnaksBar.showSnackBar(
          context,
          "Error al eliminar el producto: $e",
          color: Constants.errorColor,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Productos"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const MyHomePage(title: 'Pantalla Principal'),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarProductos,
            tooltip: "Recargar productos",
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? const Center(
                  child: Text(
                    "No hay productos disponibles",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: products.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    Product producto = products[index];
                    return CustomProducto(
                      product: producto,
                      onEdit: () => _actualizarProducto(producto),
                      onDelete: () => _eliminarProducto(producto),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _nuevoProducto,
        backgroundColor: Constants.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
