import 'package:flutter/material.dart';
import '../api/product_api.dart';
import '../screens/edit_product_screens.dart';

class ShopProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onRefresh;

  const ShopProductCard({
    super.key,
    required this.product,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            product['image'] ?? '',
            height: 130,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(
              height: 130,
              color: Colors.grey[300],
              child: const Center(child: Icon(Icons.broken_image)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product['name'], style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("Rp ${product['price']}", style: const TextStyle(fontSize: 15, color: Colors.deepOrange)),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    /// EDIT
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProductScreen(product: product),
                          ),
                        );
                        onRefresh();
                      },
                    ),

                    /// DELETE
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await ProductApi.deleteProduct(product['id']);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Produk dihapus")),
                        );

                        onRefresh();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
