import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  final String username;

  const ProfileScreen({super.key, required this.username});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String email = '';
  String phone = '';
  String? photoUrl;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    email = user?.email ?? "${widget.username}@gmail.com";
    phone = "+62 812-3456-7890";
    photoUrl = user?.photoURL;
  }

  void _editField(String title, String currentValue, Function(String) onSave) {
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit $title"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Masukkan $title baru"),
        ),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Simpan"),
            onPressed: () {
              onSave(controller.text.trim());
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        extendBodyBehindAppBar: true,
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ================================
                //              HEADER
                // ================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 70, bottom: 45),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFF9800), // orange terang
                        Color(0xFFF57C00), // orange gelap
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.white,
                        backgroundImage: photoUrl != null
                            ? NetworkImage(photoUrl!)
                            : null,
                        child: photoUrl == null
                            ? const Icon(Icons.person,
                                size: 60, color: Colors.orange)
                            : null,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        widget.username,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Akun Mobile Bengkel",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ================================
                //           PROFILE ITEMS
                // ================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      ProfileTile(
                        icon: Icons.email_outlined,
                        title: "Email",
                        subtitle: email,
                        onEdit: () => _editField("Email", email, (value) {
                          setState(() => email = value);
                        }),
                      ),
                      ProfileTile(
                        icon: Icons.phone_android,
                        title: "Telepon",
                        subtitle: phone,
                        onEdit: () => _editField("Telepon", phone, (value) {
                          setState(() => phone = value);
                        }),
                      ),
                      ProfileTile(
                        icon: Icons.settings,
                        title: "Pengaturan",
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ================================
                //         LOGOUT BUTTON
                // ================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ElevatedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout),
                    label: const Text("Keluar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                // ✅ PERBAIKAN: Tambahkan ruang kosong yang cukup di bagian bawah
                // agar konten tidak terpotong oleh Bottom Navigation Bar (sekitar 100px)
                const SizedBox(height: 100), 
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===================================================
//                 PROFILE TILE COMPONENT (TIDAK BERUBAH)
// ===================================================
class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  const ProfileTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFFFE9D6),
          child: Icon(icon, color: Colors.orange),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: const TextStyle(color: Colors.black54),
              )
            : null,
        trailing: onEdit != null
            ? IconButton(
                icon: const Icon(Icons.edit, color: Colors.grey),
                onPressed: onEdit,
              )
            : onTap != null
                ? const Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.grey)
                : null,
        onTap: onTap,
      ),
    );
  }
}