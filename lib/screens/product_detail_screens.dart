// lib/screens/product_detail_screens.dart

import 'package:flutter/material.dart';
import 'cart_data.dart';
import '../api/product_api.dart'; // Tambahkan untuk DELETE
import 'product_form_screen.dart'; // Tambahkan untuk EDIT

const Color primaryColor = Color.fromARGB(255, 240, 155, 27);

class ProductDetailScreen extends StatelessWidget {
  // ✅ FIX 1: Tambahkan ID dan Deskripsi
  final String id; // Wajib untuk Delete/Edit
  final String name;
  final int price;
  final String imagePath;
  final String description; // Ambil dari API

  const ProductDetailScreen({
    super.key,
    required this.id, // Wajib
    required this.name,
    required this.price,
    required this.imagePath,
    required this.description, // Wajib
  });
  
  // Fungsi yang dibuat untuk Delete
  void _deleteProduct(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Produk?'),
        content: Text('Anda yakin ingin menghapus produk $name?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus')),
        ],
      ),
    ) ?? false;

    if (confirmed) {
      try {
        await ProductApi.deleteProduct(id);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk berhasil dihapus!')),
        );
        // Setelah delete, kembali ke ShopScreen dan kirim sinyal refresh
        Navigator.pop(context, true); 
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus: $e')),
        );
      }
    }
  }

  // Fungsi yang dibuat untuk Edit
  void _editProduct(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductFormScreen(
          // Kirim semua data produk ke form edit
          productToEdit: {
            'id': id,
            'name': name,
            'price': price,
            'image': imagePath,
            'description': description,
          },
        ),
      ),
    );
    
    // Jika ada hasil (berhasil update), Pop dari Detail Screen dan kirim sinyal refresh
    if (result == true) {
      if (!context.mounted) return;
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Produk"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        // ✅ FIX 2: Tambahkan Tombol Edit dan Delete di AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => _editProduct(context), 
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () => _deleteProduct(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar (Menggunakan NetworkImage)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network( // ✅ FIX 3: Ganti Image.asset menjadi Image.network
                imagePath,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.broken_image, size: 80, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),

            // Nama & Harga
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Rp$price',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Deskripsi
            const Text(
              'Deskripsi Produk:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text( // ✅ FIX 4: Menggunakan deskripsi dari data API
              description.isEmpty ? 'Tidak ada deskripsi.' : description,
            ),

            const Spacer(),

            // Tombol tambah ke keranjang
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                // ... (Logic Add to Cart tetap sama)
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final index = cartItems.indexWhere((item) => item['name'] == name);
                  if (index != -1) {
                    cartItems[index]['quantity'] += 1;
                  } else {
                    cartItems.add({
                      'name': name,
                      'price': price,
                      'quantity': 1,
                    });
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$name ditambahkan ke keranjang!'),
                      backgroundColor: primaryColor,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: const Text(
                  'Tambah ke Keranjang',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}