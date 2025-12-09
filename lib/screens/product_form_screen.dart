import 'package:flutter/material.dart';
import '../api/product_api.dart'; // Pastikan path ke ProductApi.dart benar

// Definisi warna secara lokal
const Color primaryColor = Color.fromARGB(255, 10, 124, 211); 

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String image = '';
  String description = '';
  String priceStr = ''; 
  bool isSubmitting = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
        backgroundColor: const Color.fromARGB(255, 41, 154, 247),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (error != null) ...[
                Text('Error: $error', style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 8),
              ],
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nama produk'),
                validator: (v) => (v == null || v.isEmpty) ? 'Masukkan nama' : null,
                onSaved: (v) => name = v ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Harga (angka)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Masukkan harga';
                  final cleanStr = v.replaceAll(RegExp(r'[^\d]'), ''); 
                  final n = num.tryParse(cleanStr);
                  if (n == null) return 'Harga harus angka';
                  return null;
                },
                onSaved: (v) => priceStr = v ?? '0',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (v) => (v == null || v.isEmpty) ? 'Masukkan image URL' : null,
                onSaved: (v) => image = v ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 3,
                onSaved: (v) => description = v ?? '',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
                onPressed: isSubmitting ? null : () => _submit(context),
                child: isSubmitting
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext context) async {
    final form = _formKey.currentState!;
    if (!form.validate()) return;
    form.save(); 

    setState(() {
      isSubmitting = true;
      error = null;
    });

    try {
      final cleanPriceStr = priceStr.replaceAll(RegExp(r'[^\d]'), '');
      final price = num.tryParse(cleanPriceStr) ?? 0;
      
      // *** PERBAIKAN: Mengganti addProduct menjadi createProduct ***
      await ProductApi.createProduct( 
        name: name,
        price: price,
        image: image,
        description: description,
      );

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        error = e.toString();
        isSubmitting = false;
      });
    }
  }
}