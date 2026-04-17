import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/event_model.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final Color bgColor = const Color(0xFF121824);
  final Color cardColor = const Color(0xFF1E2736);
  final Color primaryBlue = const Color(0xFF3B82F6);
  final Color textMuted = const Color(0xFF94A3B8);

  final title = TextEditingController();
  final location = TextEditingController();
  final date = TextEditingController();
  final time = TextEditingController();
  final players = TextEditingController();

  String? selectedSport;

  final List<String> sports = [
    "Sepak Bola",
    "Futsal",
    "Mini Soccer",
    "Padel",
    "Tenis",
  ];

  @override
  void dispose() {
    title.dispose();
    location.dispose();
    date.dispose();
    time.dispose();
    players.dispose();
    super.dispose();
  }

  Future<void> saveEvent() async {
    if (title.text.isEmpty ||
        location.text.isEmpty ||
        date.text.isEmpty ||
        time.text.isEmpty ||
        players.text.isEmpty ||
        selectedSport == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFF87171),
          content: const Text("Semua field harus diisi"),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
      return;
    }

    final int playerCount = int.tryParse(players.text) ?? 0;

    final EventModel event = EventModel(
      title: title.text,
      sport: selectedSport!,
      location: location.text,
      date: date.text,
      time: time.text,
      players: playerCount,
    );

    await DatabaseHelper.instance.insertEvent(event);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: primaryBlue,
        content: const Text("Event berhasil dibuat"),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
    Navigator.pop(context);
  }

  Future<void> pickDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: DateTime(now.year + 3),
    );

    if (pickedDate == null) return;

    setState(() {
      date.text = '${pickedDate.day.toString().padLeft(2, '0')}/'
          '${pickedDate.month.toString().padLeft(2, '0')}/'
          '${pickedDate.year}';
    });
  }

  Future<void> pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    setState(() {
      time.text = pickedTime.format(context);
    });
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    required Color textMutedColor,
    required Color fillColor,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: textMutedColor),
      labelStyle: TextStyle(color: textMutedColor),
      hintStyle: TextStyle(color: textMutedColor.withValues(alpha: 0.7)),
      filled: true,
      fillColor: fillColor,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: primaryBlue,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }

  Widget _buildSectionCard({
    required Color cardColorValue,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColorValue,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final localBgColor = isDark ? bgColor : const Color(0xFFF5F7FB);
    final localCardColor = isDark ? cardColor : Colors.white;
    final localSurfaceColor =
        isDark ? const Color(0xFF141D2B) : const Color(0xFFE8EEF8);
    final localTextMuted = isDark ? textMuted : const Color(0xFF66758A);
    final titleColor = isDark ? Colors.white : const Color(0xFF102033);

    return Scaffold(
      backgroundColor: localBgColor,
      appBar: AppBar(
        backgroundColor: localBgColor,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: titleColor),
        title: Text(
          "Buat Event",
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryBlue,
                    const Color(0xFF1D4ED8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.campaign_rounded,
                      color: Colors.white,
                    ),
                  ),
                const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Publikasikan Event Baru",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Isi detail event olahraga kamu agar komunitas bisa cepat lihat, tertarik, dan langsung gabung.",
                          style: TextStyle(
                            color: Colors.white70,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionCard(
              cardColorValue: localCardColor,
              children: [
                Text(
                  "Informasi Event",
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Lengkapi data utama supaya event kamu mudah ditemukan.",
                  style: TextStyle(
                    color: localTextMuted,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: title,
                  style: TextStyle(color: titleColor),
                  decoration: _inputDecoration(
                    label: "Judul Event",
                    icon: Icons.edit_outlined,
                    textMutedColor: localTextMuted,
                    fillColor: localSurfaceColor,
                    hint: "Contoh: Fun Match Sabtu Pagi",
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedSport,
                  dropdownColor: localCardColor,
                  iconEnabledColor: titleColor,
                  style: TextStyle(color: titleColor),
                  decoration: _inputDecoration(
                    label: "Jenis Olahraga",
                    icon: Icons.sports_soccer_rounded,
                    textMutedColor: localTextMuted,
                    fillColor: localSurfaceColor,
                  ),
                  hint: Text(
                    "Pilih olahraga",
                    style: TextStyle(color: localTextMuted),
                  ),
                  items: sports.map((sport) {
                    return DropdownMenuItem<String>(
                      value: sport,
                      child: Text(
                        sport,
                        style: TextStyle(color: titleColor),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSport = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: location,
                  style: TextStyle(color: titleColor),
                  decoration: _inputDecoration(
                    label: "Lokasi",
                    icon: Icons.location_on_outlined,
                    textMutedColor: localTextMuted,
                    fillColor: localSurfaceColor,
                    hint: "Masukkan area atau nama venue",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _buildSectionCard(
              cardColorValue: localCardColor,
              children: [
                Text(
                  "Jadwal & Kapasitas",
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Tentukan waktu bermain dan jumlah pemain yang dibutuhkan.",
                  style: TextStyle(
                    color: localTextMuted,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: date,
                  readOnly: true,
                  onTap: pickDate,
                  style: TextStyle(color: titleColor),
                  decoration: _inputDecoration(
                    label: "Tanggal",
                    icon: Icons.calendar_today_rounded,
                    textMutedColor: localTextMuted,
                    fillColor: localSurfaceColor,
                    hint: "Pilih tanggal event",
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: time,
                  readOnly: true,
                  onTap: pickTime,
                  style: TextStyle(color: titleColor),
                  decoration: _inputDecoration(
                    label: "Waktu",
                    icon: Icons.access_time_rounded,
                    textMutedColor: localTextMuted,
                    fillColor: localSurfaceColor,
                    hint: "Pilih jam bermain",
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: players,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: titleColor),
                  decoration: _inputDecoration(
                    label: "Jumlah Pemain",
                    icon: Icons.groups_rounded,
                    textMutedColor: localTextMuted,
                    fillColor: localSurfaceColor,
                    hint: "Contoh: 10",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveEvent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Create Event",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
