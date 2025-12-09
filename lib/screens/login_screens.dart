import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../screens/register_screens.dart';
import './main_navigation.dart';

// Definisi Warna
const Color primaryColor = Color.fromARGB(255, 13, 76, 154);
const Color accentColor = Color.fromARGB(255, 195, 86, 23);
const Color lightBlueColor = Color.fromARGB(255, 85, 150, 255);
const Color darkTextColor = Color(0xFF2C2C2C);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller untuk input form
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleSignIn? _googleSignIn;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Inisialisasi GoogleSignIn hanya jika bukan Web
    if (!kIsWeb) {
      _googleSignIn = GoogleSignIn();
    }
  }

  // Fungsi navigasi ke Home Screen (MainNavigation)
  void _goHome(User user) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MainNavigation(
          username: user.displayName ?? user.email ?? "User",
        ),
      ),
    );
  }

  // LOGIN EMAIL & PASSWORD
  Future<void> _login() async {
    setState(() => _isLoading = true);

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      _goHome(_auth.currentUser!);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login gagal: $e")),
      );
    }

    setState(() => _isLoading = false);
  }

  // LOGIN GOOGLE WEB (untuk browser)
  Future<void> _signInWithGoogleWeb() async {
    try {
      // Wajib Logout Firebase untuk membersihkan sesi lama
      await FirebaseAuth.instance.signOut(); 

      final provider = GoogleAuthProvider();
      
      // PERBAIKAN KRUSIAL WEB: Memaksa Google menampilkan dialog pemilihan akun
      provider.setCustomParameters({'prompt': 'select_account'}); 
      
      final credential = await FirebaseAuth.instance.signInWithPopup(provider);

      _goHome(credential.user!);
    } catch (e) {
      print("Google Web Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error Google Web: $e")),
      );
    }
  }

  // LOGIN GOOGLE MOBILE (untuk Android/iOS)
  Future<void> _signInWithGoogleMobile() async {
    try {
      // PERBAIKAN KRUSIAL MOBILE: Logout Firebase dan Google SDK secara agresif
      await FirebaseAuth.instance.signOut(); 
      await _googleSignIn!.signOut();     
      await _googleSignIn!.disconnect();  

      final googleUser = await _googleSignIn!.signIn();
      if (googleUser == null) return; // Batal jika pengguna menutup dialog

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final result =
          await FirebaseAuth.instance.signInWithCredential(credential);

      _goHome(result.user!);
    } catch (e) {
      print("Google Mobile Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error Google Mobile: $e")),
      );
    }
  }

  // Pemilihan platform (Web atau Mobile)
  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    if (kIsWeb) {
      await _signInWithGoogleWeb();
    } else {
      await _signInWithGoogleMobile();
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER: Area Biru dengan Judul dan Icon
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              decoration: const BoxDecoration(
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
                    Icon(Icons.settings, size: 80, color: accentColor),
                    SizedBox(height: 10),
                    Text(
                      'Mobile Bengkel',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // FORM LOGIN: Diatur sedikit ke atas (offset -50)
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
                    const Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: darkTextColor,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Input Email
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon:
                            const Icon(Icons.email, color: primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Input Password
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon:
                            const Icon(Icons.lock, color: primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Tombol Login (dengan loading indicator)
                    _isLoading
                        ? const CircularProgressIndicator(color: accentColor)
                        : ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              minimumSize:
                                  const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),

                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),

                    // GOOGLE LOGIN BUTTON
                    ElevatedButton.icon(
                      onPressed: _signInWithGoogle,
                      icon: Image.asset(
                        'assets/images/Google.jpg',
                        height: 20,
                      ),
                      label: const Text(
                        'Login with Google',
                        style: TextStyle(
                          fontSize: 16,
                          color: darkTextColor,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        side: BorderSide(color: Colors.grey),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Link ke Sign Up / Register
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: RichText(
                        text: const TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: Colors.grey),
                          children: [
                            TextSpan(
                              text: 'Sign Up',
                              style: TextStyle(
                                color: accentColor,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}