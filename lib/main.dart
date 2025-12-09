// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // ✅ WAJIB: Untuk inisialisasi Firebase
import 'firebase_options.dart'; // ✅ WAJIB: File konfigurasi yang baru dibuat
import 'screens/welcome_screens.dart';
import 'screens/login_screens.dart';
// Jika sudah membuat class MainNavigation, impor di sini:
// import 'screens/main_navigation.dart'; 

void main() async {
  // 1. Wajib dipanggil untuk inisialisasi binding sebelum Firebase
  WidgetsFlutterBinding.ensureInitialized(); 

  // 2. INISIALISASI FIREBASE (Wajib ada setelah flutterfire configure)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas MP1',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/welcome': (context) => const WelcomeScreen(), 
        // 🚨 PERBAIKAN: Menggunakan LoginScreen (bukan LoginPage)
        '/login': (context) => const LoginScreen(), 
        // Contoh jika navigasi utama sudah dibuat:
        // '/main': (context) => MainNavigation(username: 'User'), 
      },
    );
  }
}