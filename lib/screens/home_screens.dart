import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';

// --- DEFINISI WARNA BARU (Navy Primary, Orange Accent) ---
const Color primaryColor = Color.fromARGB(255, 13, 76, 154); // Navy Blue
const Color backgroundColor = Color(0xFFFDFDFD);
const Color darkTextColor = Color(0xFF2C2C2C);
const Color accentColor = Color.fromARGB(255, 195, 86, 23); // Burnt Orange

class HomeScreens extends StatefulWidget {
  final String username;

  const HomeScreens({super.key, required this.username});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  int _current = 0;
  final List<String> sliderImages = [
    'assets/images/banner.jpg',
    'assets/images/promo.jpg',
    'assets/images/promo2.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, ${widget.username.toLowerCase()}",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: darkTextColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          'Bekasi, Indonesia',
                          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const Icon(Icons.notifications_none_outlined, color: primaryColor) // Icon diwarnai Primary
              ],
            ),
            const SizedBox(height: 20),

            // Slider
            CarouselSlider(
              options: CarouselOptions(
                height: 160,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
              items: sliderImages.map((imagePath) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(imagePath, fit: BoxFit.cover),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: sliderImages.asMap().entries.map((entry) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // Penanda slider menggunakan Accent Color (Orange)
                    color: accentColor.withOpacity(_current == entry.key ? 0.9 : 0.3),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Quick Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                quickAction(Icons.build, 'Servis'),
                quickAction(Icons.oil_barrel, 'Oli'),
                quickAction(Icons.tire_repair, 'Ban'),
                quickAction(Icons.local_car_wash, 'Cuci'),
              ],
            ),
            const SizedBox(height: 28),

            // Reminder Servis
            Text('Reminder Servis',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: primaryColor)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                // Gradien disesuaikan dengan skema warna baru
                gradient: LinearGradient(
                  colors: [primaryColor.withOpacity(0.08), accentColor.withOpacity(0.1)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.notifications_active, color: accentColor, size: 28), // Ikon menggunakan Orange
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Waktunya servis motor kamu! Jangan tunda agar performa tetap optimal.',
                      style: GoogleFonts.poppins(fontSize: 13, color: darkTextColor),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Jadwal Booking Hari Ini
            Text('Jadwal Booking Hari Ini',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: primaryColor)),
            const SizedBox(height: 12),
            Column(
              children: [
                bookingCard('Servis Ringan', '09.00 WIB', 'Bengkel Motor Jaya'),
                bookingCard('Ganti Oli', '13.00 WIB', 'Bengkel Mandiri'),
              ],
            ),
            const SizedBox(height: 28),

            // Tips Hari Ini
            Text('Tips Hari Ini',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: primaryColor)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1), // Latar belakang Tips menggunakan Primary Color (Navy) yang lembut
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Pastikan tekanan angin ban motor selalu sesuai agar berkendara lebih aman dan irit bahan bakar.',
                style: GoogleFonts.poppins(fontSize: 13, color: darkTextColor),
              ),
            ),
            const SizedBox(height: 28),

            // Simulasi Servis Virtual
            ElevatedButton.icon(
              onPressed: _showVirtualServiceSimulation,
              icon: const Icon(Icons.smart_toy_outlined),
              label: Text("Simulasi Servis Virtual", style: GoogleFonts.poppins()),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor, // Tombol Aksi menggunakan Orange
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showVirtualServiceSimulation() {
    final List<Map<String, dynamic>> options = [
      {'title': 'Ganti Oli Mesin', 'price': 60000},
      {'title': 'Servis Ringan', 'price': 85000},
      {'title': 'Ganti Kampas Rem', 'price': 45000},
      {'title': 'Servis CVT', 'price': 120000},
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Simulasi Servis Virtual',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Text('Pilih jenis servis untuk melihat estimasi harga:',
                  style: GoogleFonts.poppins(fontSize: 13)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = options[index];
                    return ListTile(
                      tileColor: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: Text(item['title'],
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                      trailing: Text(
                        "Rp ${item['price']}",
                        style: GoogleFonts.poppins(
                            color: accentColor, fontWeight: FontWeight.bold), // Harga menggunakan Orange
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Estimasi biaya untuk ${item['title']} adalah Rp ${item['price']}'),
                          backgroundColor: accentColor, // Notifikasi menggunakan Orange
                        ));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget quickAction(IconData icon, String label) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            // Gradien Quick Action menggunakan Orange dan Primary
            gradient: LinearGradient(
              colors: [accentColor, primaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.5),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 6),
        Text(label, style: GoogleFonts.poppins(fontSize: 12)),
      ],
    );
  }

  Widget bookingCard(String title, String time, String place) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 20, color: primaryColor), // Icon menggunakan Primary Color (Navy)
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, color: darkTextColor)),
              Text('$time - $place',
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: Colors.grey.shade600)),
            ],
          )
        ],
      ),
    );
  }
}