import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/event_model.dart';
import '../models/user_model.dart';

/// Halaman form untuk join ke event komunitas.
class FormJoinEventPage extends StatefulWidget {
  final EventModel event;
  final UserModel currentUser;

  const FormJoinEventPage({
    super.key,
    required this.event,
    required this.currentUser,
  });

  @override
  State<FormJoinEventPage> createState() => _FormJoinEventPageState();
}

/// State form join event.
class _FormJoinEventPageState extends State<FormJoinEventPage> {
  final Color primaryBlue = const Color(0xFF3B82F6);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = _displayName;
    _emailController.text = widget.currentUser.email.trim();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String get _displayName {
    final username = widget.currentUser.username.trim();
    if (username.isNotEmpty) {
      return username;
    }
    return widget.currentUser.email.trim();
  }

  bool get _isAlreadyJoined {
    final currentUserId = widget.currentUser.id;
    return widget.event.participants.any(
      (participant) => participant.userId != null && participant.userId == currentUserId,
    );
  }

  bool get _isEventFull => widget.event.participants.length >= widget.event.players;

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
        iconTheme: IconThemeData(color: titleColor),
        title: Text(
          'Join Event',
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                Text(
                  widget.event.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.event.date} • ${widget.event.time}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.event.location,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${widget.event.participants.length}/${widget.event.players} peserta bergabung',
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
          if (_isAlreadyJoined)
            _buildInfoCard(
              cardColor,
              titleColor,
              subtitleColor,
              'Kamu sudah join event ini.',
            )
          else if (_isEventFull)
            _buildInfoCard(
              cardColor,
              titleColor,
              subtitleColor,
              'Event ini sudah penuh. Coba join event lainnya.',
            )
          else
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data Peserta',
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lengkapi data singkat supaya pembuat event tahu siapa yang bergabung.',
                    style: TextStyle(
                      color: subtitleColor,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _buildInput(
                    controller: _nameController,
                    label: 'Nama',
                    icon: Icons.person_outline_rounded,
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
                    fillColor: surfaceColor,
                  ),
                  const SizedBox(height: 14),
                  _buildInput(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.alternate_email_rounded,
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
                    fillColor: surfaceColor,
                  ),
                  const SizedBox(height: 14),
                  _buildInput(
                    controller: _phoneController,
                    label: 'No. HP',
                    icon: Icons.phone_outlined,
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
                    fillColor: surfaceColor,
                  ),
                  const SizedBox(height: 14),
                  _buildInput(
                    controller: _noteController,
                    label: 'Catatan',
                    icon: Icons.edit_note_rounded,
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
                    fillColor: surfaceColor,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(top: BorderSide(color: surfaceColor, width: 1)),
        ),
        child: ElevatedButton.icon(
          onPressed: (_isSubmitting || _isAlreadyJoined || _isEventFull)
              ? null
              : _submitJoin,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            disabledBackgroundColor: primaryBlue.withValues(alpha: 0.5),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          icon: _isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.sports_handball_rounded),
          label: Text(
            _isAlreadyJoined
                ? 'Sudah Bergabung'
                : _isEventFull
                    ? 'Event Penuh'
                    : (_isSubmitting ? 'Menyimpan...' : 'Konfirmasi Join'),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    Color cardColor,
    Color titleColor,
    Color subtitleColor,
    String message,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: primaryBlue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.info_outline_rounded, color: primaryBlue),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color titleColor,
    required Color subtitleColor,
    required Color fillColor,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: titleColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: subtitleColor),
        prefixIcon: Icon(icon, color: subtitleColor),
        filled: true,
        fillColor: fillColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF3B82F6)),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }

  Future<void> _submitJoin() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan email wajib diisi')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final participant = EventParticipant(
      userId: widget.currentUser.id,
      name: name,
      email: email,
      phone: _phoneController.text.trim(),
      note: _noteController.text.trim(),
      joinedAt: _formatJoinedAt(DateTime.now()),
    );

    final updatedEvent = widget.event.copyWith(
      participants: [...widget.event.participants, participant],
    );

    try {
      await DatabaseHelper.instance.updateEvent(updatedEvent);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil join event')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal join event: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  String _formatJoinedAt(DateTime dateTime) {
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
