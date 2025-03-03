import 'dart:io';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../commons/priceformat.dart';

class CustomProducto extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CustomProducto({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: SizedBox(
          width: 50,
          height: 50,
          child: product.imagen.startsWith('assets')
              ? Image.asset(product.imagen, fit: BoxFit.cover)
              : Image.file(File(product.imagen), fit: BoxFit.cover),
        ),
        title: Text(product.nombre),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "Precio: ${PriceFormat.formatPrice(product.precio)} - Stock: ${product.stock}"),
            Text(product.descripcion,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
