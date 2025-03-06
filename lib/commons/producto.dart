import 'package:flutter/material.dart';
import '../models/product.dart';
import '../commons/priceformat.dart';
import '../commons/images.dart';
import '../commons/constants.dart';

class CustomProducto extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final defaultImage = "assets/images/product_default.png";

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
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image(
              image: Images.getImageProvider(
                product.imagenProducto ?? defaultImage,
              ),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  defaultImage,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ),
        title: Text(
          product.nombre.isNotEmpty ? product.nombre : 'Sin nombre',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Precio: ${PriceFormat.formatPrice(product.precio)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Stock: ${product.cantidad}",
                  style: TextStyle(
                    color: product.cantidad > 0
                        ? Constants.successColor
                        : Constants.errorColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Text(
              product.descripcion,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              color: Colors.blue,
              onPressed: onEdit,
              tooltip: 'Editar producto',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              onPressed: onDelete,
              tooltip: 'Eliminar producto',
            ),
          ],
        ),
      ),
    );
  }
}
