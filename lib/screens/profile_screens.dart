import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatefulWidget {
  final String username;

  const ProfileScreen({super.key, required this.username});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String email = '';
  String phone = '';

  @override
  void initState() {
    super.initState();
    email = "${widget.username}@gmail.com";
    phone = "+62 812-3456-7890";
  }

  void _editField(String title, String currentValue, Function(String) onSave) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $title'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Masukkan $title baru'),
        ),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Simpan'),
            onPressed: () {
              onSave(controller.text.trim());
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDFDFD),
        extendBodyBehindAppBar: true,
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 60, bottom: 40, left: 20, right: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color.fromARGB(255, 22, 44, 243), Color.fromARGB(255, 240, 155, 27)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 58, color: Colors.orange),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      widget.username,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
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

              // Info Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    ProfileTile(
                      icon: Icons.email_outlined,
                      title: "Email",
                      subtitle: email,
                      onEdit: () => _editField("Email", email, (newVal) {
                        setState(() {
                          email = newVal;
                        });
                      }),
                    ),
                    ProfileTile(
                      icon: Icons.phone_android,
                      title: "Telepon",
                      subtitle: phone,
                      onEdit: () => _editField("Telepon", phone, (newVal) {
                        setState(() {
                          phone = newVal;
                        });
                      }),
                    ),
                    ProfileTile(
                      icon: Icons.settings,
                      title: "Pengaturan",
                      onTap: () {
                        // Navigasi ke pengaturan
                      },
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Logout Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Keluar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                    shadowColor: Colors.orange.shade200,
                  ),
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}

// ProfileTile dengan ikon edit
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
      color: Colors.white,
      elevation: 2.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFFFF3E0),
          child: Icon(icon, color: Colors.deepOrange),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: subtitle != null
            ? Text(subtitle!, style: const TextStyle(color: Colors.black54))
            : null,
        trailing: onEdit != null
            ? IconButton(
                icon: const Icon(Icons.edit, size: 20, color: Colors.grey),
                onPressed: onEdit,
              )
            : (onTap != null
                ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
                : null),
        onTap: onTap,
      ),
    );
  }
}
