import 'dart:math';

import 'package:MyField/database/database_helper.dart';
import 'package:MyField/models/booking_model.dart';
import 'package:MyField/models/user_model.dart';
import 'package:flutter/material.dart';

/// Halaman pembayaran booking.
class PaymentPage extends StatefulWidget {
  final Booking draftBooking;
  final UserModel currentUser;

  const PaymentPage({
    super.key,
    required this.draftBooking,
    required this.currentUser,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

/// State pembayaran yang menangani ringkasan booking dan metode pembayaran.
class _PaymentPageState extends State<PaymentPage> {
  final Color primaryBlue = const Color(0xFF3B82F6);
  final List<_PaymentMethodOption> _paymentMethods = const [
    _PaymentMethodOption(
      id: 'virtual_account',
      title: 'Virtual Account',
      subtitle: 'Bayar otomatis lewat nomor VA dummy',
      icon: Icons.account_balance_rounded,
    ),
    _PaymentMethodOption(
      id: 'e_wallet',
      title: 'E-Wallet',
      subtitle: 'Simulasi pembayaran instan',
      icon: Icons.account_balance_wallet_rounded,
    ),
    _PaymentMethodOption(
      id: 'qris',
      title: 'QRIS',
      subtitle: 'Scan QR palsu untuk demo aplikasi',
      icon: Icons.qr_code_2_rounded,
    ),
  ];

  String _selectedMethodId = 'virtual_account';
  bool _isProcessing = false;

  _PaymentMethodOption get _selectedMethod => _paymentMethods.firstWhere(
        (method) => method.id == _selectedMethodId,
      );

  String get _payActionLabel {
    if (_isProcessing) {
      return 'Mengonfirmasi...';
    }

    return 'Konfirmasi Pembayaran';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF071A2C) : const Color(0xFFF5F7FB);
    final cardColor = isDark ? const Color(0xFF0E2A47) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF102033);
    final subtitleColor =
        isDark ? const Color(0xFFAFC0D4) : const Color(0xFF66758A);
    final surfaceColor =
        isDark ? const Color(0xFF102A44) : const Color(0xFFEAF1FB);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'Payment',
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: titleColor),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          _buildOrderCard(cardColor, titleColor, subtitleColor),
          const SizedBox(height: 18),
          _buildMethodSelector(
            cardColor,
            surfaceColor,
            titleColor,
            subtitleColor,
          ),
          const SizedBox(height: 18),
          _buildPaymentInstructions(
            cardColor,
            surfaceColor,
            titleColor,
            subtitleColor,
          ),
          const SizedBox(height: 18),
          _buildInvoicePreview(cardColor, titleColor, subtitleColor),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            top: BorderSide(color: surfaceColor, width: 1),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total pembayaran',
                    style: TextStyle(color: subtitleColor, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.draftBooking.harga,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: _isProcessing ? null : _submitPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              icon: _isProcessing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.verified_rounded),
              label: Text(_payActionLabel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(
    Color cardColor,
    Color titleColor,
    Color subtitleColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Booking',
            style: TextStyle(
              color: titleColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Lapangan', widget.draftBooking.lapangan, titleColor,
              subtitleColor),
          _buildDetailRow('Tanggal', widget.draftBooking.tanggal, titleColor,
              subtitleColor),
          _buildDetailRow(
              'Jam', widget.draftBooking.waktu, titleColor, subtitleColor),
          _buildDetailRow(
            'Durasi',
            widget.draftBooking.durationHours == 1
                ? '1 jam'
                : '${widget.draftBooking.durationHours} jam',
            titleColor,
            subtitleColor,
          ),
          _buildDetailRow('Pemesan', _displayName(widget.currentUser),
              titleColor, subtitleColor),
        ],
      ),
    );
  }

  Widget _buildMethodSelector(
    Color cardColor,
    Color surfaceColor,
    Color titleColor,
    Color subtitleColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih metode pembayaran',
            style: TextStyle(
              color: titleColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          ..._paymentMethods.map(
            (method) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  setState(() {
                    _selectedMethodId = method.id;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _selectedMethodId == method.id
                        ? primaryBlue.withValues(alpha: 0.12)
                        : surfaceColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: _selectedMethodId == method.id
                          ? primaryBlue
                          : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(method.icon, color: primaryBlue),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              method.title,
                              style: TextStyle(
                                color: titleColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              method.subtitle,
                              style: TextStyle(
                                color: subtitleColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        _selectedMethodId == method.id
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: primaryBlue,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInstructions(
    Color cardColor,
    Color surfaceColor,
    Color titleColor,
    Color subtitleColor,
  ) {
    final paymentCode = _dummyVirtualCode(_selectedMethodId);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Gateway by Wildan',
            style: TextStyle(
              color: titleColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Silahkan melakukan pembayaran menggunakan metode yang dipilih. ',
            style: TextStyle(
              color: subtitleColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          if (_selectedMethod.id == 'qris')
            _buildDummyQrisCard(
              surfaceColor,
              titleColor,
              subtitleColor,
              paymentCode,
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedMethod.id == 'virtual_account'
                        ? 'Nomor VA Bank'
                        : 'Kode Referensi',
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    paymentCode,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDummyQrisCard(
    Color surfaceColor,
    Color titleColor,
    Color subtitleColor,
    String paymentCode,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryBlue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'QRIS Dummy',
                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Icon(Icons.qr_code_2_rounded, color: primaryBlue),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  'MYFIELD PAYMENT',
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 190,
                  height: 190,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CustomPaint(
                      painter: _DummyQrPainter(seed: paymentCode.hashCode),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _displayName(widget.currentUser),
                  style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.draftBooking.harga,
                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            paymentCode,
            style: TextStyle(
              color: titleColor,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'Silahkan Scan QR di atas menggunakan aplikasi pembayaran yang mendukung QRIS untuk melakukan pembayaran.',
            style: TextStyle(
              color: subtitleColor,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInvoicePreview(
    Color cardColor,
    Color titleColor,
    Color subtitleColor,
  ) {
    final previewNumber = _buildInvoiceNumber();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preview invoice',
            style: TextStyle(
              color: titleColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            'No. invoice',
            previewNumber,
            titleColor,
            subtitleColor,
          ),
          _buildDetailRow(
            'Status',
            'Menunggu pembayaran',
            titleColor,
            subtitleColor,
          ),
          _buildDetailRow(
            'Metode',
            _selectedMethod.title,
            titleColor,
            subtitleColor,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    Color titleColor,
    Color subtitleColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(color: subtitleColor, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitPayment() async {
    setState(() {
      _isProcessing = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 1400));

    final now = DateTime.now();
    final invoiceNumber = _buildInvoiceNumber();
    final proofCode = _buildProofCode(now);
    final savedBooking = widget.draftBooking.copyWith(
      status: 'Booked',
      invoiceNumber: invoiceNumber,
      paymentMethod: _selectedMethod.title,
      paymentStatus: 'Lunas',
      paymentDate: _formatDateTime(now),
      paymentProofCode: proofCode,
      bookedAt: _formatDateTime(now),
    );

    final bookingId = await DatabaseHelper.instance.insertBooking(savedBooking);

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
    });

    final completedBooking = savedBooking.copyWith(id: bookingId);

    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BookingInvoicePage(
          booking: completedBooking,
          customerName: _displayName(widget.currentUser),
        ),
      ),
    );
  }

  String _buildInvoiceNumber() {
    final now = DateTime.now();
    return 'INV-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${now.millisecondsSinceEpoch.toString().substring(7)}';
  }

  String _buildProofCode(DateTime timestamp) {
    final randomValue =
        Random(timestamp.millisecondsSinceEpoch).nextInt(899999) + 100000;
    return 'PAY-${timestamp.year}${timestamp.month.toString().padLeft(2, '0')}${timestamp.day.toString().padLeft(2, '0')}-$randomValue';
  }

  String _dummyVirtualCode(String methodId) {
    final seed = widget.draftBooking.userID.toString().padLeft(4, '0');
    return switch (methodId) {
      'virtual_account' => '8808 77$seed 1024',
      'e_wallet' => 'EWALLET-$seed-7788',
      _ => 'QRIS-$seed-4455',
    };
  }

  String _displayName(UserModel user) {
    final username = user.username.trim();
    if (username.isNotEmpty) {
      return username;
    }
    return user.email.trim();
  }

  String _formatDateTime(DateTime dateTime) {
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

    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day ${months[dateTime.month - 1]} ${dateTime.year}, $hour:$minute';
  }
}

/// Halaman invoice setelah pembayaran selesai diproses.
class BookingInvoicePage extends StatelessWidget {
  final Booking booking;
  final String customerName;

  const BookingInvoicePage({
    super.key,
    required this.booking,
    required this.customerName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF071A2C) : const Color(0xFFF5F7FB);
    final cardColor = isDark ? const Color(0xFF0E2A47) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF102033);
    final subtitleColor =
        isDark ? const Color(0xFFAFC0D4) : const Color(0xFF66758A);
    const primaryBlue = Color(0xFF3B82F6);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'Invoice Booking',
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: titleColor),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PAYMENT SUCCESS',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  booking.invoiceNumber.isEmpty
                      ? 'Invoice belum tersedia'
                      : booking.invoiceNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    booking.paymentStatus.isEmpty
                        ? 'Menunggu pembayaran'
                        : booking.paymentStatus,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _InvoiceSection(
            title: 'Informasi pembayaran',
            cardColor: cardColor,
            titleColor: titleColor,
            subtitleColor: subtitleColor,
            children: [
              _InvoiceRow(label: 'Lapangan', value: booking.lapangan),
              _InvoiceRow(label: 'Tanggal main', value: booking.tanggal),
              _InvoiceRow(label: 'Jam', value: booking.waktu),
              _InvoiceRow(
                label: 'Durasi',
                value: booking.durationHours == 1
                    ? '1 jam'
                    : '${booking.durationHours} jam',
              ),
              _InvoiceRow(label: 'Nama pemesan', value: customerName),
              _InvoiceRow(label: 'Metode', value: booking.paymentMethod),
              _InvoiceRow(label: 'Total', value: booking.harga),
            ],
          ),
          const SizedBox(height: 18),
          _InvoiceSection(
            title: 'Riwayat bukti pembayaran',
            cardColor: cardColor,
            titleColor: titleColor,
            subtitleColor: subtitleColor,
            children: [
              _InvoiceTimelineItem(
                title: 'Invoice dibuat',
                subtitle: booking.bookedAt.isEmpty ? '-' : booking.bookedAt,
                icon: Icons.receipt_long_rounded,
                color: primaryBlue,
              ),
              _InvoiceTimelineItem(
                title: 'Pembayaran terkonfirmasi',
                subtitle:
                    booking.paymentDate.isEmpty ? '-' : booking.paymentDate,
                icon: Icons.verified_rounded,
                color: const Color(0xFF10B981),
              ),
              _InvoiceTimelineItem(
                title: 'Kode bukti transaksi',
                subtitle: booking.paymentProofCode.isEmpty
                    ? '-'
                    : booking.paymentProofCode,
                icon: Icons.shield_outlined,
                color: const Color(0xFFF59E0B),
                isLast: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Section tampilan invoice.
class _InvoiceSection extends StatelessWidget {
  final String title;
  final Color cardColor;
  final Color titleColor;
  final Color subtitleColor;
  final List<Widget> children;

  const _InvoiceSection({
    required this.title,
    required this.cardColor,
    required this.titleColor,
    required this.subtitleColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

/// Baris kecil untuk menampilkan pasangan label dan value pada invoice.
class _InvoiceRow extends StatelessWidget {
  final String label;
  final String value;

  const _InvoiceRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF102033);
    final subtitleColor =
        isDark ? const Color(0xFFAFC0D4) : const Color(0xFF66758A);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(color: subtitleColor, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Item timeline status pada invoice.
class _InvoiceTimelineItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isLast;

  const _InvoiceTimelineItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF102033);
    final subtitleColor =
        isDark ? const Color(0xFFAFC0D4) : const Color(0xFF66758A);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: color.withValues(alpha: 0.24),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: subtitleColor,
                      height: 1.45,
                    ),
                  ),
                  if (!isLast) const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Model internal untuk opsi metode pembayaran.
class _PaymentMethodOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;

  const _PaymentMethodOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

/// Painter dummy untuk placeholder QR.
class _DummyQrPainter extends CustomPainter {
  final int seed;

  const _DummyQrPainter({required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = Colors.white;
    final fillPaint = Paint()..color = Colors.black;
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    const gridSize = 21;
    final cellSize = size.width / gridSize;
    final random = Random(seed);

    void drawFinder(double startX, double startY) {
      final outer = Rect.fromLTWH(
        startX,
        startY,
        cellSize * 7,
        cellSize * 7,
      );
      canvas.drawRect(outer, fillPaint);
      canvas.drawRect(
        Rect.fromLTWH(
          startX + cellSize,
          startY + cellSize,
          cellSize * 5,
          cellSize * 5,
        ),
        backgroundPaint,
      );
      canvas.drawRect(
        Rect.fromLTWH(
          startX + (cellSize * 2),
          startY + (cellSize * 2),
          cellSize * 3,
          cellSize * 3,
        ),
        fillPaint,
      );
    }

    drawFinder(0, 0);
    drawFinder(size.width - (cellSize * 7), 0);
    drawFinder(0, size.height - (cellSize * 7));

    for (var row = 0; row < gridSize; row++) {
      for (var col = 0; col < gridSize; col++) {
        final isInsideTopLeft = row < 7 && col < 7;
        final isInsideTopRight = row < 7 && col >= 14;
        final isInsideBottomLeft = row >= 14 && col < 7;
        if (isInsideTopLeft || isInsideTopRight || isInsideBottomLeft) {
          continue;
        }

        final shouldFill = random.nextBool();
        if (!shouldFill) continue;

        canvas.drawRect(
          Rect.fromLTWH(
            col * cellSize,
            row * cellSize,
            cellSize,
            cellSize,
          ),
          fillPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DummyQrPainter oldDelegate) {
    return oldDelegate.seed != seed;
  }
}
