import 'package:flutter/material.dart';
import 'package:inicio_sesion/logica/productlogic.dart';
import 'package:inicio_sesion/models/product.dart';
import 'package:inicio_sesion/commons/producto.dart';
import 'package:inicio_sesion/commons/validations.dart';
import 'package:inicio_sesion/commons/dialogs.dart';
import 'package:inicio_sesion/commons/images.dart';
import 'package:inicio_sesion/commons/constants.dart';
import 'dart:math' show Random;

class MyProductPage extends StatefulWidget {
  const MyProductPage({super.key});

  @override
  _MyProductPageState createState() => _MyProductPageState();
}

class _MyProductPageState extends State<MyProductPage> {
  void _nuevoProducto() {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController stockController = TextEditingController();
    String? PathImage;

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
                    controller: stockController,
                    decoration: const InputDecoration(labelText: "Stock"),
                    keyboardType: TextInputType.number,
                    validator: Validations.validateStock,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          PathImage ?? "No se ha seleccionado imagen",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          String? newPath = await Images.SelectImage();
                          if (newPath != null) {
                            setDialogState(() => PathImage = newPath);
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
                      Validations.validateStock(stockController.text) != null) {
                    Dialogs.showSnackBar(context,
                        "Por favor, complete todos los campos correctamente",
                        color: Constants.errorColor);
                    return;
                  }

                  await Dialogs.showLoadingSpinner(context);

                  String nuevoId = 'PROD${Random().nextInt(10000)}';
                  Product nuevoProducto = Product(
                    id: nuevoId,
                    nombre: nameController.text,
                    descripcion: descriptionController.text,
                    precio:
                        double.parse(priceController.text.replaceAll(',', '.')),
                    stock: int.parse(stockController.text),
                    imagen: PathImage ?? Images.getDefaultImage(false),
                  );

                  ProductLogic.addProduct(nuevoProducto);
                  Navigator.pop(dialogContext);
                  setState(() {});
                  Dialogs.showSnackBar(context, "Producto creado correctamente",
                      color: Constants.successColor);
                },
                style: ElevatedButton.styleFrom
                (backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                ),
                child: const Text("Crear"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _actualizarProducto(Product Pproduct) {
    TextEditingController nombreController =
        TextEditingController(text: Pproduct.nombre);
    TextEditingController descripcionController =
        TextEditingController(text: Pproduct.descripcion);
    TextEditingController precioController =
        TextEditingController(text: Pproduct.precio.toString());
    TextEditingController stockController =
        TextEditingController(text: Pproduct.stock.toString());
    String? imagenPath = Pproduct.imagen;

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
                    controller: stockController,
                    decoration: const InputDecoration(labelText: "Stock"),
                    keyboardType: TextInputType.number,
                    validator: Validations.validateStock,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          imagenPath ?? "No se ha seleccionado imagen",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          String? newPath = await Images.SelectImage();
                          if (newPath != null) {
                            setDialogState(() => imagenPath = newPath);
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
                      Validations.validateStock(stockController.text) != null) {
                    Dialogs.showSnackBar(context,
                        "Por favor, complete todos los campos correctamente",
                        color: Constants.errorColor);
                    return;
                  }

                  await Dialogs.showLoadingSpinner(context);

                  Pproduct.nombre = nombreController.text;
                  Pproduct.descripcion = descripcionController.text;
                  Pproduct.precio =
                      double.parse(precioController.text.replaceAll(',', '.'));
                  Pproduct.stock = int.parse(stockController.text);
                  Pproduct.imagen = imagenPath ?? Images.getDefaultImage(false);
                  ProductLogic.updateProduct(Pproduct);

                  Navigator.pop(dialogContext);
                  setState(() {});
                  Dialogs.showSnackBar(
                      context, "Producto actualizado correctamente",
                      color: Constants.successColor);
                },
                child: const Text("Guardar"),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Product> listProducts = ProductLogic.productos;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Productos"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: listProducts.length,
            itemBuilder: (context, index) {
              Product producto = listProducts[index];
              return CustomProducto(
                product: producto,
                onEdit: () => _actualizarProducto(producto),
                onDelete: () async {
                  bool? confirmar = await Dialogs.showConfirmDialog(
                      context: context,
                      title: "Confirmar eliminación",
                      content: "¿Está seguro de eliminar ${producto.nombre}?",
                      style: Text(''));

                  if (confirmar == true) {
                    await Dialogs.showLoadingSpinner(context);
                    ProductLogic.deleteProduct(producto.id);
                    setState(() {});
                    Dialogs.showSnackBar(
                        context, "Producto eliminado correctamente",
                        color: Constants.successColor);
                  }
                },
              );
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Constants.primaryColor,
              foregroundColor: Colors.white,
              onPressed: _nuevoProducto,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
