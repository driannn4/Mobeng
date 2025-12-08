import 'package:flutter/material.dart';
import 'cart_data.dart';

const Color primaryColor = Color.fromARGB(255, 20, 134, 255);

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double getTotal() {
    return cartItems.fold(0, (sum, item) => sum + item['price'] * item['quantity']);
  }

  void increaseQty(int index) {
    setState(() {
      cartItems[index]['quantity'] += 1;
    });
  }

  void decreaseQty(int index) {
    setState(() {
      if (cartItems[index]['quantity'] > 1) {
        cartItems[index]['quantity'] -= 1;
      } else {
        cartItems.removeAt(index);
      }
    });
  }

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Produk dihapus dari keranjang")),
    );
  }

  void handleCheckout() {
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Keranjang masih kosong")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi Checkout"),
        content: Text("Total belanja: Rp ${getTotal().toStringAsFixed(0)}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () {
              setState(() => cartItems.clear());
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Checkout berhasil!")),
              );
            },
            child: const Text("Lanjut"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Keranjang"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: cartItems.isEmpty
                  ? const Center(child: Text("Keranjang kosong"))
                  : ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 4,
                                color: Colors.black12,
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Kiri: Info produk
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['name'],
                                        style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text('Rp ${item['price']} x ${item['quantity']}',
                                        style: const TextStyle(color: Colors.grey)),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                                          onPressed: () => decreaseQty(index),
                                        ),
                                        Text('${item['quantity']}'),
                                        IconButton(
                                          icon: const Icon(Icons.add_circle, color: primaryColor),
                                          onPressed: () => increaseQty(index),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Kanan: Total dan hapus
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Rp ${item['price'] * item['quantity']}',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.grey),
                                    onPressed: () => removeItem(index),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
            ),
            // Footer Total & Checkout
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Rp ${getTotal().toStringAsFixed(0)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: primaryColor, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: handleCheckout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      minimumSize: const Size.fromHeight(45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Checkout",style: TextStyle(color: Colors.white),),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
