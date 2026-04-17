import 'package:MyField/database/database_helper.dart';
import 'package:MyField/fieldreview/view/review_list_page.dart';
import 'package:MyField/models/booking_model.dart';
import 'package:MyField/models/user_model.dart';
import 'package:flutter/material.dart';

class DetailBooking extends StatefulWidget {
  final String namaLapangan;
  final String lokasi;
  final double rating;
  final String gambar;
  final String harga;
  final UserModel currentUser;

  const DetailBooking({
    super.key,
    required this.namaLapangan,
    required this.lokasi,
    required this.rating,
    required this.gambar,
    required this.harga,
    required this.currentUser,
  });

  @override
  State<DetailBooking> createState() => _DetailBookingState();
}

class _DetailBookingState extends State<DetailBooking> {
  final Color bgColor = const Color(0xFF121824);
  final Color cardColor = const Color(0xFF1E2736);
  final Color primaryBlue = const Color(0xFF3B82F6);
  final Color textMuted = const Color(0xFF94A3B8);

  late DateTime _visibleStartDate;
  late DateTime _selectedBookingDate;
  String selectedTime = '12:00';

  final List<Map<String, dynamic>> facilities = [
    {'icon': Icons.shower, 'label': 'Shower'},
    {'icon': Icons.directions_car, 'label': 'Parking'},
    {'icon': Icons.checkroom, 'label': 'Lockers'},
    {'icon': Icons.water_drop, 'label': 'Water'},
    {'icon': Icons.wifi, 'label': 'Wi-Fi'},
  ];

  final List<Map<String, dynamic>> timeSlots = List.generate(16, (index) {
    final hour = index + 7;
    final hourLabel = hour.toString().padLeft(2, '0');
    return {
      'time': '$hourLabel:00',
      'status': 'available',
    };
  });

  @override
  void initState() {
    super.initState();
    final today = _normalizeDate(DateTime.now());
    _visibleStartDate = today;
    _selectedBookingDate = today;
  }

  List<DateTime> get dateOptions {
    return List.generate(
      7,
      (index) => _visibleStartDate.add(Duration(days: index)),
    );
  }

  DateTime get selectedBookingDate => _selectedBookingDate;

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool _isSameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  void _syncVisibleRangeForSelectedDate() {
    final rangeEnd = _visibleStartDate.add(const Duration(days: 6));
    if (_selectedBookingDate.isBefore(_visibleStartDate) ||
        _selectedBookingDate.isAfter(rangeEnd)) {
      _visibleStartDate = _selectedBookingDate;
    }
  }

  void _shiftVisibleDates(int days) {
    final today = _normalizeDate(DateTime.now());
    final nextStart = _normalizeDate(_visibleStartDate.add(Duration(days: days)));

    setState(() {
      _visibleStartDate = nextStart.isBefore(today) ? today : nextStart;
      if (_selectedBookingDate.isBefore(_visibleStartDate)) {
        _selectedBookingDate = _visibleStartDate;
      }
    });
  }

  Future<void> _pickBookingDate() async {
    final today = _normalizeDate(DateTime.now());
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedBookingDate,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
    );

    if (pickedDate == null || !mounted) return;

    setState(() {
      _selectedBookingDate = _normalizeDate(pickedDate);
      _syncVisibleRangeForSelectedDate();
    });
  }

  String _formatMonthYear(DateTime date) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${months[date.month - 1]} ${date.year}';
  }

  String _formatWeekdayShort(DateTime date) {
    const weekdays = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return weekdays[date.weekday - 1];
  }

  String _formatBookingDate(DateTime date) {
    const weekdays = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final localBgColor = isDark ? bgColor : const Color(0xFFF5F7FB);
    final localCardColor = isDark ? cardColor : Colors.white;
    final localTextMuted = isDark ? textMuted : const Color(0xFF64748B);
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final softSurface = isDark ? cardColor : const Color(0xFFEAF1FB);

    return Scaffold(
      backgroundColor: localBgColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderImage(localBgColor, isDark),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleAndRating(
                    localCardColor,
                    localTextMuted,
                    titleColor,
                    isDark,
                  ),
                  const SizedBox(height: 24),
                  _buildFacilities(localCardColor, localTextMuted, titleColor),
                  const SizedBox(height: 24),
                  _buildDateSelector(
                    localCardColor,
                    localTextMuted,
                    titleColor,
                  ),
                  const SizedBox(height: 24),
                  _buildTimeSlots(localCardColor, titleColor),
                  const SizedBox(height: 24),
                  _buildCourtRules(localCardColor, localTextMuted, titleColor),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(
        localBgColor,
        softSurface,
        localTextMuted,
        titleColor,
      ),
    );
  }

  Widget _buildHeaderImage(Color localBgColor, bool isDark) {
    return Stack(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.gambar),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.35),
                  localBgColor,
                ],
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
              _buildIconButton(Icons.arrow_back, isDark, () {
                Navigator.pop(context);
              }),
              Row(
                children: [
                  _buildIconButton(Icons.share, isDark, null),
                  const SizedBox(width: 12),
                  _buildIconButton(Icons.favorite_border, isDark, null),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, bool isDark, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.82),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isDark ? Colors.white : const Color(0xFF1E293B),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildTitleAndRating(
    Color localCardColor,
    Color localTextMuted,
    Color titleColor,
    bool isDark,
  ) {
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
                style: TextStyle(
                  color: titleColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: localCardColor,
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
              style: TextStyle(color: localTextMuted, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              widget.rating.toString(),
              style: TextStyle(
                color: titleColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Row(
              children: List.generate(
                5,
                (index) => const Icon(Icons.star, color: Colors.amber, size: 18),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDark ? Colors.white : const Color(0xFFEAF1FB),
                foregroundColor:
                    isDark ? const Color(0xFF102033) : const Color(0xFF2563EB),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewListPage(
                      fieldName: 'Talenta Court',
                    ),
                  ),
                );
              },
              child: const Text('Lihat Review'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFacilities(
    Color localCardColor,
    Color localTextMuted,
    Color titleColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fasilitas',
          style: TextStyle(
            color: titleColor,
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
                      color: localCardColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      facilities[index]['icon'],
                      color: localTextMuted,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    facilities[index]['label'],
                    style: TextStyle(color: localTextMuted, fontSize: 12),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector(
    Color localCardColor,
    Color localTextMuted,
    Color titleColor,
  ) {
    final dates = dateOptions;
    final today = _normalizeDate(DateTime.now());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select Date',
              style: TextStyle(
                color: titleColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: _pickBookingDate,
              child: Row(
                children: [
                  Icon(Icons.calendar_month_rounded, color: primaryBlue, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    _formatMonthYear(selectedBookingDate),
                    style: TextStyle(color: primaryBlue, fontSize: 14),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: primaryBlue, size: 20),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pilih cepat 7 hari',
              style: TextStyle(color: localTextMuted, fontSize: 13),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: _visibleStartDate.isAfter(today)
                      ? () => _shiftVisibleDates(-7)
                      : null,
                  icon: const Icon(Icons.chevron_left_rounded),
                  color: primaryBlue,
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  onPressed: () => _shiftVisibleDates(7),
                  icon: const Icon(Icons.chevron_right_rounded),
                  color: primaryBlue,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final isSelected = _isSameDate(dates[index], selectedBookingDate);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedBookingDate = dates[index];
                  });
                },
                child: Container(
                  width: 60,
                  decoration: BoxDecoration(
                    color: isSelected ? primaryBlue : localCardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatWeekdayShort(dates[index]),
                        style: TextStyle(
                          color: isSelected ? Colors.white : localTextMuted,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${dates[index].day}',
                        style: TextStyle(
                          color: isSelected ? Colors.white : titleColor,
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

  Widget _buildTimeSlots(Color localCardColor, Color titleColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jam Kosong',
          style: TextStyle(
            color: titleColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: timeSlots.length,
          itemBuilder: (context, index) {
            final slot = timeSlots[index];
            final isSelected = selectedTime == slot['time'];

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedTime = slot['time'];
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? primaryBlue : localCardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      slot['time'],
                      style: TextStyle(
                        color: isSelected ? Colors.white : titleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.check_circle, color: Colors.white, size: 14),
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

  Widget _buildCourtRules(
    Color localCardColor,
    Color localTextMuted,
    Color titleColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: localCardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: primaryBlue, size: 20),
              const SizedBox(width: 8),
              Text(
                'Syarat ketentuan',
                style: TextStyle(
                  color: titleColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildRuleItem('Harus menjaga kebersihan lapangan', localTextMuted),
          _buildRuleItem('Dilarang ngeroko di lapangan', localTextMuted),
          _buildRuleItem(
            'Membatalkan secara sepihak maka tidak bisa refund',
            localTextMuted,
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem(String text, Color localTextMuted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6, right: 8),
            child: CircleAvatar(radius: 2, backgroundColor: localTextMuted),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: localTextMuted, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(
    Color localBgColor,
    Color softSurface,
    Color localTextMuted,
    Color titleColor,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: localBgColor,
        border: Border(top: BorderSide(color: softSurface, width: 1)),
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
                style: TextStyle(color: localTextMuted, fontSize: 12),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.harga,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '/ 90min',
                    style: TextStyle(color: localTextMuted, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              final booking = Booking(
                lapangan: widget.namaLapangan,
                userID: widget.currentUser.id ?? 0,
                tanggal: _formatBookingDate(selectedBookingDate),
                waktu: selectedTime,
                status: 'Booked',
                harga: widget.harga,
              );

              await DatabaseHelper.instance.insertBooking(booking);
              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking berhasil')),
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
