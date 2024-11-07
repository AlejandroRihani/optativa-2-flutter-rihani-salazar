import 'package:flutter/material.dart';
import 'package:proyecto_alejandro_rihani/modules/login/domain/dto/product/product_dto.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Imagen del producto con tamaño reducido
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
              child: Image.network(
                product.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenedor de información de producto
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre del producto con tamaño de texto reducido
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,  // Tamaño de texto más pequeño
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Texto de detalles con tamaño de texto reducido
                GestureDetector(
                  onTap: () {
                    // Aquí puedes agregar la acción para ver detalles del producto
                    print("Ver detalles de ${product.name}");
                  },
                  child: const Text(
                    "Detalles",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,  // Tamaño de texto reducido
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
