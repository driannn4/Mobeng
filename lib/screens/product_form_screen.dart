import 'package:flutter/material.dart';
import '../api/product_api.dart'; 

// Menggunakan warna oranye yang konsisten dari ShopScreen
const Color primaryColor = Color.fromARGB(255, 240, 155, 27); 
const Color secondaryColor = Color(0xFFFDECDA); // Warna oranye muda untuk background/accent

class ProductFormScreen extends StatefulWidget {
  final Map<String, dynamic>? productToEdit; 

  const ProductFormScreen({
    super.key,
    this.productToEdit, 
  });

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _imageController;
  late final TextEditingController _descriptionController;

  bool isSubmitting = false;
  String? error;
  
  bool get isEditMode => widget.productToEdit != null; 

  @override
  void initState() {
    super.initState();
    final product = widget.productToEdit;

    _nameController = TextEditingController(text: product?['name'] ?? '');
    _priceController = TextEditingController(text: product?['price']?.toString() ?? ''); 
    _imageController = TextEditingController(text: product?['image'] ?? '');
    _descriptionController = TextEditingController(text: product?['description'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Widget untuk membuat TextFormField yang lebih keren
  Widget _buildProductFormField({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: primaryColor),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor, // Background yang lebih lembut
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Produk' : 'Tambah Produk', 
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                if (error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('Gagal: $error', style: const TextStyle(color: Colors.red)),
                  ),
                ],
                
                _buildProductFormField(
                  controller: _nameController,
                  labelText: 'Nama produk',
                  validator: (v) => (v == null || v.isEmpty) ? 'Masukkan nama produk' : null,
                ),
                
                _buildProductFormField(
                  controller: _priceController,
                  labelText: 'Harga (angka)',
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Masukkan harga';
                    final cleanStr = v.replaceAll(RegExp(r'[^\d]'), ''); 
                    final n = num.tryParse(cleanStr);
                    if (n == null) return 'Harga harus angka yang valid';
                    return null;
                  },
                ),
                
                _buildProductFormField(
                  controller: _imageController,
                  labelText: 'Image URL',
                  validator: (v) => (v == null || v.isEmpty) ? 'Masukkan URL gambar' : null,
                ),
                
                _buildProductFormField(
                  controller: _descriptionController,
                  labelText: 'Deskripsi',
                  maxLines: 3,
                ),

                const SizedBox(height: 20),
                
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor, 
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    onPressed: isSubmitting ? null : () => _submit(context),
                    child: isSubmitting
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                        : Text(isEditMode ? 'Update Produk' : 'Simpan Produk Baru',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext context) async {
    final form = _formKey.currentState!;
    if (!form.validate()) return;
    
    setState(() {
      isSubmitting = true;
      error = null;
    });

    try {
      final cleanPriceStr = _priceController.text.replaceAll(RegExp(r'[^\d]'), '');
      final price = num.tryParse(cleanPriceStr) ?? 0;
      
      final name = _nameController.text;
      final image = _imageController.text;
      final description = _descriptionController.text;

      if (isEditMode) {
        await ProductApi.updateProduct(
          id: widget.productToEdit!['id'], 
          name: name,
          price: price,
          image: image,
          description: description,
        );
      } else {
        await ProductApi.createProduct( 
          name: name,
          price: price,
          image: image,
          description: description,
        );
      }

      if (!mounted) return;
      
      Navigator.of(context).pop(true); 
    } catch (e) {
      // Menampilkan error di SnackBar juga agar lebih jelas
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        error = e.toString();
        isSubmitting = false;
      });
    }
  }
}