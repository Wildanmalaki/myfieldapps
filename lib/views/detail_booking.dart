import 'package:MyField/fieldreview/view/review_list_page.dart';
import 'package:MyField/database/database_helper.dart';
import 'package:MyField/models/booking_model.dart';
import 'package:flutter/material.dart';

class DetailBooking extends StatefulWidget {
  final String namaLapangan;
  final String lokasi;
  final double rating;
  final String gambar;
  final String harga;

  const DetailBooking({
    super.key,
    required this.namaLapangan,
    required this.lokasi,
    required this.rating,
    required this.gambar,
    required this.harga,
  });

  @override
  State<DetailBooking> createState() => _DetailBookingState();
}

class _DetailBookingState extends State<DetailBooking> {
  // Warna Tema
  final Color bgColor = const Color(0xFF121824);
  final Color cardColor = const Color(0xFF1E2736);
  final Color primaryBlue = const Color(0xFF3B82F6);
  final Color textMuted = const Color(0xFF94A3B8);

  // State untuk pilihan aktif
  int selectedDateIndex = 0;
  String selectedTime = "12:00";

  // Data Mockup
  final List<Map<String, dynamic>> facilities = [
    {'icon': Icons.shower, 'label': 'Shower'},
    {'icon': Icons.directions_car, 'label': 'Parking'},
    {'icon': Icons.checkroom, 'label': 'Lockers'},
    {'icon': Icons.water_drop, 'label': 'Water'},
    {'icon': Icons.wifi, 'label': 'Wi-Fi'},
  ];

  final List<Map<String, String>> dates = [
    {'day': 'Mon', 'date': '12'},
    {'day': 'Tue', 'date': '13'},
    {'day': 'Wed', 'date': '14'},
    {'day': 'Thu', 'date': '15'},
    {'day': 'Fri', 'date': '16'},
  ];

  final List<Map<String, dynamic>> timeSlots = [
    {'time': '09:00', 'status': 'disabled'},
    {'time': '10:00', 'status': 'available'},
    {'time': '11:00', 'status': 'available'},
    {'time': '12:00', 'status': 'available'},
    {'time': '13:00', 'status': 'available'},
    {'time': '14:00', 'status': 'available'},
    {'time': '15:00', 'status': 'disabled'},
    {'time': '16:00', 'status': 'disabled'},
    {'time': '17:00', 'status': 'available'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderImage(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleAndRating(),
                  const SizedBox(height: 24),
                  _buildFacilities(),
                  const SizedBox(height: 24),
                  _buildDateSelector(),
                  const SizedBox(height: 24),
                  _buildTimeSlots(),
                  const SizedBox(height: 24),
                  _buildCourtRules(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildHeaderImage() {
    return Stack(
      children: [
        // gambar lapangan
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage((widget.gambar)),
              fit: BoxFit.cover,
            ),
          ),
          // Overlay hitam
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withValues(alpha: 0.4), bgColor],
              ),
            ),
          ),
        ),
        Positioned(
          top: 50,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIconButton(Icons.arrow_back),
              Row(
                children: [
                  _buildIconButton(Icons.share),
                  const SizedBox(width: 12),
                  _buildIconButton(Icons.favorite_border),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildTitleAndRating() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                widget.namaLapangan,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'COURT 1',
                style: TextStyle(
                  color: Color(0xFF3B82F6),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.location_on, color: primaryBlue, size: 16),
            const SizedBox(width: 4),
            Text(
              widget.lokasi,
              style: TextStyle(color: textMuted, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              widget.rating.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Row(
              children: List.generate(
                5,
                (index) =>
                    const Icon(Icons.star, color: Colors.amber, size: 18),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewListPage(
                      fieldName: "Talenta Court",
                    ),
                  ),
                );
              },
              child: const Text("Lihat Review"),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildFacilities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Fasilitas",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: facilities.length,
            separatorBuilder: (context, index) => const SizedBox(width: 20),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: cardColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      facilities[index]['icon'],
                      color: textMuted,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    facilities[index]['label'],
                    style: TextStyle(color: textMuted, fontSize: 12),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select Date',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  'Maret 2026',
                  style: TextStyle(color: primaryBlue, fontSize: 14),
                ),
                Icon(Icons.keyboard_arrow_down, color: primaryBlue, size: 20),
              ],
            ),
          ],
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            separatorBuilder: (context, index) => SizedBox(width: 12),
            itemBuilder: (context, index) {
              bool isSelected = selectedDateIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDateIndex = index;
                  });
                },
                child: Container(
                  width: 60,
                  decoration: BoxDecoration(
                    color: isSelected ? primaryBlue : cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dates[index]['day']!,
                        style: TextStyle(
                          color: isSelected ? Colors.white : textMuted,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        dates[index]['date']!,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlots() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jam Kosong',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: timeSlots.length,
          itemBuilder: (context, index) {
            final slot = timeSlots[index];
            bool isSelected = selectedTime == slot['time'];
            bool isDisabled = slot['status'] == 'disabled';

            return GestureDetector(
              onTap: isDisabled
                  ? null
                  : () {
                      setState(() {
                        selectedTime = slot['time'];
                      });
                    },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? primaryBlue : cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      slot['time'],
                      style: TextStyle(
                        color: isDisabled
                            ? Colors.white.withValues(alpha: 0.2)
                            : Colors.white,
                        fontWeight: FontWeight.w600,
                        decoration: isDisabled
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    if (isSelected) ...[
                      SizedBox(width: 4),
                      Icon(Icons.check_circle, color: Colors.white, size: 14),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCourtRules() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: primaryBlue, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Syarat ketentuan',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          _buildRuleItem('Harus menjaga kebersihan lapangan'),
          _buildRuleItem('Dilarang ngeroko di lapangan'),
          _buildRuleItem('Membatalkan secara sepihak maka tidak bisa refund'),
        ],
      ),
    );
  }

  Widget _buildRuleItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6, right: 8),
            child: CircleAvatar(radius: 2, backgroundColor: textMuted),
          ),
          Expanded(
            child: Text(text, style: TextStyle(color: textMuted, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(top: BorderSide(color: cardColor, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Price',
                style: TextStyle(color: textMuted, fontSize: 12),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.harga,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '/ 90min',
                    style: TextStyle(color: textMuted, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              final booking = Booking(
                lapangan: widget.namaLapangan,
                userID: 0,
                tanggal: dates[selectedDateIndex]['date']!,
                waktu: selectedTime,
                status: "Booked",
                harga: widget.harga,
              );

              await DatabaseHelper.instance.insertBooking(booking);
              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Booking berhasil")),
              );

              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Row(
              children: [
                Text(
                  'Booking',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Colors.white, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
