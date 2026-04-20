import 'package:MyField/fieldreview/view/review_list_page.dart';
import 'package:MyField/database/database_helper.dart';
import 'package:MyField/models/booking_model.dart';
import 'package:MyField/models/user_model.dart';
import 'package:MyField/views/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Halaman detail lapangan sebelum user melakukan booking.
class DetailBooking extends StatefulWidget {
  final String namaLapangan;
  final String lokasi;
  final double rating;
  final String gambar;
  final String harga;
  final int? harga1Jam;
  final int? harga2Jam;
  final String? fullAddress;
  final double? latitude;
  final double? longitude;
  final UserModel currentUser;

  const DetailBooking({
    super.key,
    required this.namaLapangan,
    required this.lokasi,
    required this.rating,
    required this.gambar,
    required this.harga,
    this.harga1Jam,
    this.harga2Jam,
    this.fullAddress,
    this.latitude,
    this.longitude,
    required this.currentUser,
  });

  @override
  State<DetailBooking> createState() => _DetailBookingState();
}

/// State detail booking yang mengatur tanggal, jam, durasi, dan Maps.
class _DetailBookingState extends State<DetailBooking> {
  final Color bgColor = const Color(0xFF121824);
  final Color cardColor = const Color(0xFF1E2736);
  final Color primaryBlue = const Color(0xFF3B82F6);
  final Color textMuted = const Color(0xFF94A3B8);
  final List<int> _durationChoices = const [1, 2, 3, 4, 5, 6];

  late DateTime _visibleStartDate;
  late DateTime _selectedBookingDate;
  int _selectedStartHour = 12;
  int _selectedDurationHours = 1;
  bool _isLoadingBookedSlots = false;
  List<Booking> _bookedSlots = [];

  final List<Map<String, dynamic>> facilities = [
    {'icon': Icons.shower, 'label': 'Shower'},
    {'icon': Icons.directions_car, 'label': 'Parking'},
    {'icon': Icons.checkroom, 'label': 'Lockers'},
    {'icon': Icons.water_drop, 'label': 'Water'},
    {'icon': Icons.wifi, 'label': 'Wi-Fi'},
  ];

  final List<int> timeSlots = List.generate(16, (index) => index + 7);

  @override
  void initState() {
    super.initState();
    final today = _normalizeDate(DateTime.now());
    _visibleStartDate = today;
    _selectedBookingDate = today;
    _loadBookedSlots();
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
    final nextStart =
        _normalizeDate(_visibleStartDate.add(Duration(days: days)));

    setState(() {
      _visibleStartDate = nextStart.isBefore(today) ? today : nextStart;
      if (_selectedBookingDate.isBefore(_visibleStartDate)) {
        _selectedBookingDate = _visibleStartDate;
      }
    });
  }

  /// Membuka date picker untuk memilih tanggal booking.
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

    await _loadBookedSlots();
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

  List<int> get _parsedPricePoints {
    if (widget.harga1Jam != null || widget.harga2Jam != null) {
      final values = <int>[
        if ((widget.harga1Jam ?? 0) > 0) widget.harga1Jam!,
        if ((widget.harga2Jam ?? 0) > 0) widget.harga2Jam!,
      ];
      if (values.isNotEmpty) {
        return values;
      }
    }

    final currencyMatches = RegExp(
      r'Rp\s*([\d.]+)',
      caseSensitive: false,
    ).allMatches(widget.harga).toList();

    if (currencyMatches.isNotEmpty) {
      return currencyMatches
          .map(
            (match) =>
                int.tryParse(match.group(1)?.replaceAll('.', '') ?? '0') ?? 0,
          )
          .where((value) => value > 0)
          .toList();
    }

    final fallbackMatch = RegExp(r'[\d.]+').firstMatch(widget.harga);
    final fallbackValue =
        int.tryParse(fallbackMatch?.group(0)?.replaceAll('.', '') ?? '0') ?? 0;
    return fallbackValue > 0 ? [fallbackValue] : const [0];
  }

  int get _oneHourRate {
    final prices = _parsedPricePoints;
    if (prices.isEmpty) return 0;
    return prices.first;
  }

  int get _twoHourRate {
    final prices = _parsedPricePoints;
    if (prices.length >= 2) {
      return prices[1];
    }
    return _oneHourRate * 2;
  }

  List<int> get _availableDurationChoices {
    final maxDuration = (24 - _selectedStartHour).clamp(1, 6);
    return _durationChoices
        .where((duration) => duration <= maxDuration)
        .where((duration) => !_doesOverlapExistingBooking(_selectedStartHour, duration))
        .toList();
  }

  int get _endHour => _selectedStartHour + _selectedDurationHours;

  String get _startTimeLabel => _formatHour(_selectedStartHour);

  String get _endTimeLabel => _formatHour(_endHour);

  String get _bookingTimeRange => '$_startTimeLabel - $_endTimeLabel';

  int get _totalPrice {
    if (_selectedDurationHours <= 1) {
      return _oneHourRate;
    }

    if (_selectedDurationHours == 2) {
      return _twoHourRate;
    }

    return _twoHourRate + ((_selectedDurationHours - 2) * _oneHourRate);
  }

  String get _totalPriceLabel => 'Rp ${_formatCurrency(_totalPrice)}';

  String get _pricingBenchmarkLabel {
    return '1 jam Rp ${_formatCurrency(_oneHourRate)} | 2 jam Rp ${_formatCurrency(_twoHourRate)}';
  }

  String get _resolvedAddress {
    final address = widget.fullAddress?.trim();
    if (address != null && address.isNotEmpty) {
      return address;
    }
    return widget.lokasi;
  }

  String get _coordinateLabel {
    if (widget.latitude == null || widget.longitude == null) {
      return 'Koordinat tersedia saat dibuka di Google Maps';
    }

    return '${widget.latitude!.toStringAsFixed(6)}, ${widget.longitude!.toStringAsFixed(6)}';
  }

  String get _durationLabel =>
      _selectedDurationHours == 1 ? '1 jam' : '$_selectedDurationHours jam';

  Future<void> _openInMaps() async {
    final query = widget.latitude != null && widget.longitude != null
        ? '${widget.latitude},${widget.longitude}'
        : '${widget.namaLapangan}, $_resolvedAddress';
    final uri = Uri.https(
      'www.google.com',
      '/maps/search/',
      {
        'api': '1',
        'query': query,
      },
    );

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Google Maps belum bisa dibuka di perangkat ini.'),
        ),
      );
    }
  }

  String _formatHour(int hour) {
    return '${hour.toString().padLeft(2, '0')}:00';
  }

  String _formatCurrency(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      final reversedIndex = digits.length - i;
      buffer.write(digits[i]);
      if (reversedIndex > 1 && reversedIndex % 3 == 1) {
        buffer.write('.');
      }
    }
    return buffer.toString();
  }

  /// Memuat daftar slot yang sudah dibooking untuk tanggal yang dipilih.
  Future<void> _loadBookedSlots() async {
    setState(() {
      _isLoadingBookedSlots = true;
    });

    final bookings = await DatabaseHelper.instance.getBookingsByFieldAndDate(
      lapangan: widget.namaLapangan,
      tanggal: _formatBookingDate(_selectedBookingDate),
    );

    if (!mounted) return;

    final firstAvailableStartHour = _findFirstAvailableStartHour(bookings);
    final nextDurationChoices = firstAvailableStartHour == null
        ? const <int>[]
        : _durationChoices
            .where((duration) => duration <= (24 - firstAvailableStartHour).clamp(1, 6))
            .where((duration) => !_doesOverlapWithBookings(bookings, firstAvailableStartHour, duration))
            .toList();

    setState(() {
      _bookedSlots = bookings;
      _isLoadingBookedSlots = false;

      if (firstAvailableStartHour == null) {
        _selectedStartHour = timeSlots.first;
        _selectedDurationHours = 1;
        return;
      }

      if (_isStartHourUnavailable(_selectedStartHour, bookings)) {
        _selectedStartHour = firstAvailableStartHour;
      }

      if (!nextDurationChoices.contains(_selectedDurationHours)) {
        _selectedDurationHours = nextDurationChoices.isNotEmpty
            ? nextDurationChoices.first
            : 1;
      }
    });
  }

  bool _doesOverlapExistingBooking(int proposedStartHour, int durationHours) {
    return _doesOverlapWithBookings(_bookedSlots, proposedStartHour, durationHours);
  }

  bool _doesOverlapWithBookings(
    List<Booking> bookings,
    int proposedStartHour,
    int durationHours,
  ) {
    final proposedEndHour = proposedStartHour + durationHours;
    return bookings.any(
      (booking) =>
          proposedStartHour < booking.endHour &&
          proposedEndHour > booking.startHour,
    );
  }

  bool _isStartHourUnavailable(int startHour, [List<Booking>? bookings]) {
    final source = bookings ?? _bookedSlots;
    return source.any(
      (booking) => startHour >= booking.startHour && startHour < booking.endHour,
    );
  }

  int? _findFirstAvailableStartHour([List<Booking>? bookings]) {
    final source = bookings ?? _bookedSlots;
    for (final hour in timeSlots) {
      if (!_isStartHourUnavailable(hour, source)) {
        return hour;
      }
    }
    return null;
  }

  String get _bookedSlotsLabel {
    if (_bookedSlots.isEmpty) {
      return 'Belum ada booking di tanggal ini. Semua slot masih tersedia.';
    }

    final ranges = _bookedSlots
        .map((booking) => '${_formatHour(booking.startHour)} - ${_formatHour(booking.endHour)}')
        .join(', ');
    return 'Sudah dibooking: $ranges';
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
                  _buildLocationPanel(localCardColor, localTextMuted, titleColor),
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
                  _buildDurationSelector(localCardColor, localTextMuted, titleColor),
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
                (index) =>
                    const Icon(Icons.star, color: Colors.amber, size: 18),
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
                      fieldName: widget.namaLapangan,
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

  /// Panel lokasi lapangan yang menampilkan alamat, koordinat, dan tombol Maps.
  Widget _buildLocationPanel(
    Color localCardColor,
    Color localTextMuted,
    Color titleColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: localCardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.explore_rounded, color: primaryBlue, size: 20),
              const SizedBox(width: 8),
              Text(
                'Lokasi Lapangan',
                style: TextStyle(
                  color: titleColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.place_outlined, color: localTextMuted, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _resolvedAddress,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.my_location_rounded, color: localTextMuted, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _coordinateLabel,
                  style: TextStyle(
                    color: localTextMuted,
                    fontSize: 12.5,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _openInMaps,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.map_outlined),
              label: const Text(
                'Buka di Google Maps',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
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
                  Icon(Icons.calendar_month_rounded,
                      color: primaryBlue, size: 18),
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
                onTap: () async {
                  setState(() {
                    _selectedBookingDate = dates[index];
                  });
                  await _loadBookedSlots();
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
        const SizedBox(height: 8),
        Text(
          _isLoadingBookedSlots ? 'Memuat slot yang sudah dibooking...' : _bookedSlotsLabel,
          style: TextStyle(
            color: _bookedSlots.isEmpty ? const Color(0xFF16A34A) : textMuted,
            fontSize: 12,
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
            final hour = timeSlots[index];
            final isSelected = _selectedStartHour == hour;
            final isUnavailable = _isStartHourUnavailable(hour);
            final slotColor = isUnavailable
                ? localCardColor.withValues(alpha: 0.45)
                : isSelected
                    ? primaryBlue
                    : localCardColor;

            return GestureDetector(
              onTap: isUnavailable
                  ? null
                  : () {
                setState(() {
                  _selectedStartHour = hour;
                  if (!_availableDurationChoices.contains(_selectedDurationHours)) {
                    _selectedDurationHours = _availableDurationChoices.first;
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: slotColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatHour(hour),
                      style: TextStyle(
                        color: isUnavailable
                            ? titleColor.withValues(alpha: 0.45)
                            : isSelected
                                ? Colors.white
                                : titleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isUnavailable) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.block_rounded,
                        color: titleColor.withValues(alpha: 0.45),
                        size: 14,
                      ),
                    ] else if (isSelected) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.check_circle,
                          color: Colors.white, size: 14),
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

  Widget _buildDurationSelector(
    Color localCardColor,
    Color localTextMuted,
    Color titleColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Durasi Booking',
          style: TextStyle(
            color: titleColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Pilih lama main. Harga pakai patokan 1 jam dan 2 jam.',
          style: TextStyle(
            color: localTextMuted,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _pricingBenchmarkLabel,
          style: TextStyle(
            color: primaryBlue,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        if (_availableDurationChoices.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: localCardColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              'Jam mulai yang dipilih bentrok dengan booking lain. Silakan pilih jam lain.',
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        else
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _availableDurationChoices.map((duration) {
            final isSelected = duration == _selectedDurationHours;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDurationHours = duration;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? primaryBlue : localCardColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  duration == 1 ? '1 Jam' : '$duration Jam',
                  style: TextStyle(
                    color: isSelected ? Colors.white : titleColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: localCardColor,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ringkasan Durasi',
                style: TextStyle(
                  color: titleColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Main $_durationLabel',
                style: TextStyle(color: localTextMuted),
              ),
              const SizedBox(height: 4),
              Text(
                _bookingTimeRange,
                style: TextStyle(
                  color: titleColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _totalPriceLabel,
                style: TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
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
                    _totalPriceLabel,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '/ $_durationLabel',
                    style: TextStyle(color: localTextMuted, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              if (_availableDurationChoices.isEmpty ||
                  _doesOverlapExistingBooking(
                    _selectedStartHour,
                    _selectedDurationHours,
                  )) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Slot ini sudah dibooking user lain. Pilih jam yang masih kosong.',
                    ),
                  ),
                );
                return;
              }

              final booking = Booking(
                lapangan: widget.namaLapangan,
                userID: widget.currentUser.id ?? 0,
                tanggal: _formatBookingDate(selectedBookingDate),
                waktu: _bookingTimeRange,
                startHour: _selectedStartHour,
                endHour: _endHour,
                durationHours: _selectedDurationHours,
                status: 'Menunggu Pembayaran',
                harga: _totalPriceLabel,
              );

              if (!mounted) return;
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PaymentPage(
                    draftBooking: booking,
                    currentUser: widget.currentUser,
                  ),
                ),
              );
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
                  'Lanjut Bayar',
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
