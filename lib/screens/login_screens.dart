import 'package:flutter/material.dart';
import 'main_navigation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background abu-abu
      backgroundColor: const Color.fromARGB(255, 48, 173, 235),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image (di-nonaktifkan)
          /*
          Image.asset(
            'assets/images/testt.jpg',
            fit: BoxFit.cover,
          ),
          */

          // Tombol Back di kiri atas
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/welcome');
              },
            ),
          ),

          // Konten Login
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Logo dan judul
                  Image.asset('assets/images/Logo.png', height: 120),
                  const SizedBox(height: 10),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(text: 'Mobile ', style: TextStyle(color: Colors.black)),
                        TextSpan(text: 'Bengkel', style: TextStyle(color: Colors.orange)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Card Login
                  Card(
                    color: Colors.white,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Welcome Back!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 30),
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Forgot Password"),
                                    content: const Text("Silakan hubungi admin untuk reset password."),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("OK"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              final username = _usernameController.text.trim();
                              final password = _passwordController.text.trim();

                              if (username.isEmpty || password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Username dan password tidak boleh kosong"),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                                return;
                              }

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainNavigation(username: username),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 27, 56, 244),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text('Login', style: TextStyle(color: Colors.white, fontSize: 18)),
                          ),
                          const SizedBox(height: 20),
                          const Center(
                            child: Text(
                              "Don't have an account?",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                          const SizedBox(height: 20),
                          OutlinedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Login with Google coming soon!'),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              side: const BorderSide(color: Colors.grey),
                              foregroundColor: const Color.fromARGB(221, 0, 0, 0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/Google.webp',
                                  height: 24,
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Login with Google',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
