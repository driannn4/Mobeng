// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart'; 
import 'screens/welcome_screens.dart';
import 'screens/login_screens.dart';
import 'screens/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Pastikan Firebase diinisialisasi
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
      title: 'Mobile Bengkel App',
      debugShowCheckedModeBanner: false,

      // Start app → cek login dulu
      initialRoute: '/checkauth',

      routes: {
        '/checkauth': (context) => const AuthChecker(),
        // '/' sekarang akan menampilkan WelcomeScreen (Default Route)
        '/': (context) => const WelcomeScreen(), 
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}

// Mengecek status login
class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Status loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        // Jika sudah login → masuk MainNavigation
        if (user != null) {
          final username =
              user.displayName ?? user.email?.split('@')[0] ?? 'User';

          return MainNavigation(username: username);
        }

        // ✅ PERBAIKAN: Jika belum login → arahkan ke Welcome Screen
        return const WelcomeScreen(); 
      },
    );
  }
}