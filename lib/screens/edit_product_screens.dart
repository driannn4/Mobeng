import 'package:flutter/material.dart';
import '../api/product_api.dart';

class EditProductScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController imageController;
  late TextEditingController descriptionController;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product['name']);
    priceController = TextEditingController(text: widget.product['price'].toString());
    imageController = TextEditingController(text: widget.product['image']);
    descriptionController = TextEditingController(text: widget.product['description'] ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Produk"),
        backgroundColor: Color.fromARGB(255, 240, 155, 27),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nama Produk"),
                validator: (v) => v!.isEmpty ? "Nama tidak boleh kosong" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Harga"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Harga tidak boleh kosong" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: imageController,
                decoration: const InputDecoration(labelText: "URL Gambar"),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Deskripsi"),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: loading ? null : save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 240, 155, 27),
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Simpan Perubahan"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      await ProductApi.updateProduct(
        id: widget.product['id'],
        name: nameController.text,
        price: num.parse(priceController.text),
        image: imageController.text,
        description: descriptionController.text,
      );

      Navigator.pop(context, true); // <-- balik ke halaman sebelumnya
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal update: $e")),
      );
    }

    setState(() => loading = false);
  }
}
