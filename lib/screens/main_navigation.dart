import 'package:flutter/material.dart';
import 'home_screens.dart';
import 'shop_screens.dart';
import 'cart_screens.dart';
import 'profile_screens.dart';

const Color primaryColor = Color.fromARGB(255, 240, 155, 27);

class MainNavigation extends StatefulWidget {
  final String username;

  const MainNavigation({super.key, required this.username});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    // Pastikan halaman yang membutuhkan username dikirim dengan benar
    _screens = [
      HomeScreens(username: widget.username),
      ShopScreens(username: widget.username),
      const CartScreen(),
      ProfileScreen(username: widget.username),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        elevation: 10,
        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
