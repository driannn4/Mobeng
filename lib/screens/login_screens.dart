import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'register_screens.dart'; 
import 'main_navigation.dart'; 

// --- DEFINISI WARNA (Konsisten dengan MainNavigation yang baru) ---
const Color primaryColor = Color.fromARGB(255, 13, 76, 154); // Navy Blue
const Color accentColor = Color.fromARGB(255, 195, 86, 23); // Burnt Orange
const Color lightBlueColor = Color.fromARGB(255, 85, 150, 255);
const Color darkTextColor = Color(0xFF2C2C2C); 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  final _auth = FirebaseAuth.instance;
  
  // ✅ PERBAIKAN FINAL: Client ID untuk Web sudah dimasukkan
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '574598429263-27pco15239i4d2324e9g05e42d6f09e6.apps.googleusercontent.com',
  ); 
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navigateToHome(String username) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainNavigation(username: username),
      ),
    );
  }

  // 1. LOGIC LOGIN EMAIL/PASSWORD
  Future<void> _login() async {
    setState(() => _isLoading = true);
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan Password harus diisi.'), backgroundColor: accentColor),
      );
      setState(() => _isLoading = false);
      return;
    }
    
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      final username = userCredential.user?.email?.split('@')[0] ?? 'User';
      _navigateToHome(username);
      
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        message = 'Akun tidak ditemukan atau email tidak valid.';
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        message = 'Password salah.';
      } else {
        message = 'Gagal Login: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: accentColor),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // 2. LOGIC LOGIN GOOGLE
  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; 

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      final username = userCredential.user?.displayName ?? userCredential.user?.email?.split('@')[0] ?? 'User';
      _navigateToHome(username);
      
    } catch (e) {
      print('Google Login Error: $e'); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi error saat Login Google.'), backgroundColor: accentColor),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section (Blue Background)
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [lightBlueColor, primaryColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Ganti dengan logo yang kamu gunakan
                    Icon(Icons.settings, size: 80, color: accentColor), 
                    SizedBox(height: 10),
                    Text('Mobile Bengkel', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
            ),
            
            // Form Section
            Transform.translate(
              offset: const Offset(0, -50),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text('Welcome Back!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: darkTextColor)),
                    const SizedBox(height: 25),
                    
                    // Email Field
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email', 
                        prefixIcon: const Icon(Icons.email, color: primaryColor), 
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Password Field
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock, color: primaryColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Implementasi Forgot Password (Firebase provides this function)
                        },
                        child: Text('Forgot Password?', style: TextStyle(color: accentColor)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Login Button
                    _isLoading
                        ? const CircularProgressIndicator(color: accentColor)
                        : ElevatedButton(
                            onPressed: _login, // Memanggil fungsi _login() Firebase
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('Login', style: TextStyle(fontSize: 18)),
                          ),
                    const SizedBox(height: 15),

                    // Sign Up Link
                    GestureDetector(
                      onTap: _navigateToRegister,
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(color: Colors.grey),
                          children: [
                            TextSpan(
                              text: 'Sign Up',
                              style: TextStyle(fontWeight: FontWeight.bold, color: accentColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    const Divider(),
                    const SizedBox(height: 15),

                    // Google Login Button
                    ElevatedButton.icon(
                      onPressed: _signInWithGoogle, // Memanggil fungsi _signInWithGoogle()
                      icon: Image.asset('assets/images/google_logo.webp', height: 20), 
                      label: const Text('Login with Google', style: TextStyle(fontSize: 16, color: darkTextColor)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}