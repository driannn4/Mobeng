import 'package:flutter/material.dart';
import 'cart_data.dart';
import '../screens/product_detail_screens.dart';
import '../api/product_api.dart';
import '../screens/product_form_screen.dart';


const Color primaryColor = Color.fromARGB(255, 240, 155, 27); // WARNA ORANGE ASLI
const Color backgroundColor = Color(0xFFF5F5F5);

class ShopScreens extends StatefulWidget {
  final String username;

  const ShopScreens({super.key, required this.username});

  @override
  State<ShopScreens> createState() => _ShopScreensState();
}

class _ShopScreensState extends State<ShopScreens> {
  String query = '';
  String selectedCategory = 'Semua';

  // API DATA
  List<dynamic> apiProducts = [];
  bool isLoading = true;

  List<dynamic> get productList => apiProducts;

  final List<String> categories = [
    'Semua', 'Oli', 'Rem', 'Aki', 'Busi', 'Filter', 'Rantai'
  ];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    try {
      final data = await ProductApi.getProducts();
      setState(() {
        apiProducts = data;
        isLoading = false;
      });
    } catch (e) {
      print("API Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = productList.where((product) {
      final nameMatch =
          product['name'].toString().toLowerCase().contains(query.toLowerCase());
      final categoryMatch = selectedCategory == 'Semua' ||
          product['name']
              .toString()
              .toLowerCase()
              .contains(selectedCategory.toLowerCase());
      return nameMatch && categoryMatch;
    }).toList();

    return Scaffold(
      backgroundColor: backgroundColor,

        // 🔥 Floating Action Button (HANYA IKON '+')
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProductFormScreen()),
            );
            if (result == true) {
              loadProducts();
            }
          },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white), // HANYA IKON
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --------------------------------------------------------
              // SEARCH BAR
              // --------------------------------------------------------
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: TextField(
                  onChanged: (val) => setState(() => query = val),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.search, color: primaryColor),
                    hintText: 'Cari produk...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // --------------------------------------------------------
              // KATEGORI
              // --------------------------------------------------------
              const Text(
                'Kategori Produk',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: categories.map((cat) {
                    final selected = cat == selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: selected,
                        onSelected: (_) => setState(() => selectedCategory = cat),
                        selectedColor: primaryColor,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                '${filteredProducts.length} produk ditemukan',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),

              // --------------------------------------------------------
              // GRID PRODUK
              // --------------------------------------------------------
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      )
                    : filteredProducts.isEmpty
                        ? const Center(
                            child: Text(
                              'Produk tidak ditemukan',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : GridView.builder(
                            itemCount: filteredProducts.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 3 / 4,
                            ),
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];
                              return ShopProductCard(
                                name: product['name'],
                                price: product['price'],
                                imagePath: product['image'],
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// CARD PRODUK
// ============================================================================
class ShopProductCard extends StatelessWidget {
  final String name;
  final int price;
  final String imagePath;

  const ShopProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imagePath,
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 40),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Rp$price',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.green, // PERHATIAN: Warna harga masih hijau
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),

            // BUTTONS
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(
                            name: name,
                            price: price,
                            imagePath: imagePath,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Lihat Detail",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // ADD TO CART
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add_shopping_cart,
                        color: Colors.white, size: 20),
                    onPressed: () {
                      final index = cartItems.indexWhere(
                          (item) => item['name'] == name);
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
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}