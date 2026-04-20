import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/booking_model.dart';
import '../models/user_model.dart';
import 'payment_page.dart';

/// Halaman daftar booking milik user.
class BookingsPage extends StatefulWidget {
  final UserModel currentUser;

  const BookingsPage({super.key, required this.currentUser});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

/// State yang memuat dan menampilkan riwayat booking user.
class _BookingsPageState extends State<BookingsPage> {
  late Future<List<Booking>> bookingList;
  final Color bgColor = const Color(0xFF121824);
  final Color cardColor = const Color(0xFF1E2736);
  final Color primaryBlue = const Color(0xFF3B82F6);
  final Color textMuted = const Color(0xFF94A3B8);

  @override
  void initState() {
    super.initState();
    _reloadBookings();
  }

  void _reloadBookings() {
    bookingList = DatabaseHelper.instance.getBookingsByUser(
      widget.currentUser.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? bgColor : const Color(0xFFF5F7FB);
    final localCardColor = isDark ? cardColor : Colors.white;
    final localTextMuted = isDark ? textMuted : const Color(0xFF66758A);
    final titleColor = isDark ? Colors.white : const Color(0xFF102033);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: FutureBuilder<List<Booking>>(
        future: bookingList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: primaryBlue),
            );
          }

          if (snapshot.hasError) {
            return _buildMessageState(
              icon: Icons.error_outline,
              title: "Riwayat belum bisa dimuat",
              subtitle: "Coba buka lagi beberapa saat lagi.",
              cardColorValue: localCardColor,
              textMutedValue: localTextMuted,
              titleColor: titleColor,
            );
          }

          final bookings = snapshot.data ?? [];

          return RefreshIndicator(
            color: primaryBlue,
            backgroundColor: localCardColor,
            onRefresh: () async {
              setState(_reloadBookings);
              await bookingList;
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
              children: [
                _buildHeader(bookings.length, localCardColor, localTextMuted,
                    titleColor),
                const SizedBox(height: 24),
                if (bookings.isEmpty)
                  _buildMessageState(
                    icon: Icons.book_online_outlined,
                    title: "Belum ada booking",
                    subtitle:
                        "Booking lapangan pertama kamu akan muncul di sini.",
                    cardColorValue: localCardColor,
                    textMutedValue: localTextMuted,
                    titleColor: titleColor,
                  )
                else
                  ...bookings.map((booking) => bookingCard(
                        booking,
                        localCardColor,
                        localTextMuted,
                        titleColor,
                      )),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(
    int totalBookings,
    Color cardColorValue,
    Color textMutedValue,
    Color titleColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SafeArea(
          bottom: false,
          child: SizedBox.shrink(),
        ),
        Text(
          "Riwayat Booking",
          style: TextStyle(
            color: titleColor,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Pantau semua jadwal lapangan yang sudah kamu pesan.",
          style: TextStyle(color: textMutedValue, fontSize: 14),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryBlue,
                const Color(0xFF1D4ED8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total booking aktif",
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$totalBookings booking",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageState({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color cardColorValue,
    required Color textMutedValue,
    required Color titleColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardColorValue,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: primaryBlue.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(icon, color: primaryBlue, size: 34),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: titleColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: textMutedValue, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget bookingCard(
    Booking booking,
    Color cardColorValue,
    Color textMutedValue,
    Color titleColor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColorValue,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : const Color(0xFFE2EAF5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: primaryBlue.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.sports_soccer,
                  color: primaryBlue,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "MyField",
                      style: TextStyle(
                        color: textMutedValue,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      booking.lapangan,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusChip(
                booking.paymentStatus.isEmpty
                    ? booking.status
                    : booking.paymentStatus,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.03)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                _buildInfoRow(Icons.calendar_today_rounded, booking.tanggal),
                const SizedBox(height: 10),
                _buildInfoRow(Icons.access_time_rounded, booking.waktu),
                const SizedBox(height: 10),
                _buildInfoRow(
                  Icons.timelapse_rounded,
                  booking.durationHours == 1
                      ? '1 jam'
                      : '${booking.durationHours} jam',
                ),
                const SizedBox(height: 10),
                _buildInfoRow(Icons.payments_outlined, booking.harga),
                if (booking.invoiceNumber.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _buildInfoRow(
                    Icons.receipt_long_rounded,
                    booking.invoiceNumber,
                  ),
                ],
              ],
            ),
          ),
          if (booking.paymentStatus.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.03)
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : const Color(0xFFE2EAF5),
                ),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    Icons.verified_rounded,
                    'Status pembayaran: ${booking.paymentStatus}',
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                    Icons.account_balance_wallet_outlined,
                    booking.paymentMethod.isEmpty ? '-' : booking.paymentMethod,
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                    Icons.event_available_rounded,
                    booking.paymentDate.isEmpty ? '-' : booking.paymentDate,
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                    Icons.schedule_rounded,
                    booking.bookedAt.isEmpty ? '-' : booking.bookedAt,
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                    Icons.shield_outlined,
                    booking.paymentProofCode.isEmpty
                        ? '-'
                        : booking.paymentProofCode,
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 8,
            spacing: 8,
            children: [
              Text(
                "ID Booking #${booking.id ?? '-'}",
                style: TextStyle(color: textMutedValue, fontSize: 12),
              ),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  if (booking.invoiceNumber.isNotEmpty)
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: primaryBlue,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingInvoicePage(
                              booking: booking,
                              customerName: _displayName(widget.currentUser),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.receipt_long_rounded),
                      label: const Text("Invoice"),
                    ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFF87171),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () async {
                      await DatabaseHelper.instance.deleteBooking(booking.id!);
                      setState(() {
                        _reloadBookings();
                      });
                    },
                    icon: const Icon(Icons.delete_outline_rounded),
                    label: const Text("Hapus"),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final infoTextColor = isDark ? Colors.white : const Color(0xFF102033);
    final infoMuted = isDark ? textMuted : const Color(0xFF66758A);
    return Row(
      children: [
        Icon(icon, color: infoMuted, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: infoTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    final normalizedStatus = status.trim().toLowerCase();
    final isPaid = normalizedStatus == 'lunas' || normalizedStatus == 'booked';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: (isPaid ? const Color(0xFF10B981) : const Color(0xFFF59E0B))
            .withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: isPaid ? const Color(0xFF34D399) : const Color(0xFFFBBF24),
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  String _displayName(UserModel user) {
    final username = user.username.trim();
    if (username.isNotEmpty) {
      return username;
    }
    return user.email.trim();
  }
}
