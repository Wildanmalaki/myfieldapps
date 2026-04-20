import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../database/database_helper.dart';
import '../models/event_model.dart';
import '../models/user_model.dart';

class CreateEventPage extends StatefulWidget {
  final UserModel currentUser;

  const CreateEventPage({super.key, required this.currentUser});

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
  final ImagePicker _picker = ImagePicker();

  String? selectedSport;
  String _eventImageBase64 = '';
  bool _isPickingImage = false;

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
    final now = DateTime.now();

    final EventModel event = EventModel(
      title: title.text,
      sport: selectedSport!,
      location: location.text,
      date: date.text,
      time: time.text,
      players: playerCount,
      imageBase64: _eventImageBase64,
      creatorName: _creatorName,
      creatorId: widget.currentUser.id,
      createdAt: now,
      expireAt: now.add(const Duration(days: 30)),
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

  Future<void> _pickEventImage() async {
    if (_isPickingImage) return;

    setState(() {
      _isPickingImage = true;
    });

    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1280,
      );

      if (pickedFile == null || !mounted) return;

      CroppedFile? croppedFile;
      try {
        croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 86,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Foto Event',
              toolbarColor: const Color(0xFF1D4ED8),
              toolbarWidgetColor: Colors.white,
              activeControlsWidgetColor: const Color(0xFF3B82F6),
              lockAspectRatio: false,
              aspectRatioPresets: [
                CropAspectRatioPreset.ratio16x9,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
              ],
            ),
            IOSUiSettings(
              title: 'Crop Foto Event',
              aspectRatioPresets: [
                CropAspectRatioPreset.ratio16x9,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
              ],
            ),
          ],
        );
      } catch (_) {
        // Fallback ke file asli jika cropper gagal dibuka.
      }

      final imagePath = croppedFile?.path ?? pickedFile.path;
      final bytes = await File(imagePath).readAsBytes();
      if (bytes.length > 900000) {
        throw Exception(
          'Ukuran foto terlalu besar. Coba crop ulang atau pilih gambar yang lebih kecil.',
        );
      }

      setState(() {
        _eventImageBase64 = base64Encode(bytes);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFF87171),
          content: Text('Gagal memilih foto event: $e'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPickingImage = false;
        });
      }
    }
  }

  Uint8List? get _eventImageBytes {
    if (_eventImageBase64.trim().isEmpty) return null;

    try {
      final payload = _eventImageBase64.contains(',')
          ? _eventImageBase64.split(',').last.trim()
          : _eventImageBase64;
      return base64Decode(payload);
    } catch (_) {
      return null;
    }
  }

  String get _creatorName {
    final username = widget.currentUser.username.trim();
    if (username.isNotEmpty) {
      return username;
    }
    return widget.currentUser.email.trim();
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
        borderSide: BorderSide(color: primaryBlue),
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
                        const SizedBox(height: 8),
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
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: localSurfaceColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: primaryBlue.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.person_outline_rounded,
                          color: primaryBlue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Dibuat oleh",
                              style: TextStyle(
                                color: localTextMuted,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _creatorName,
                              style: TextStyle(
                                color: titleColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  "Foto Event",
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: _pickEventImage,
                  child: Ink(
                    height: 180,
                    decoration: BoxDecoration(
                      color: localSurfaceColor,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                    child: _eventImageBytes != null
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: Image.memory(
                                  _eventImageBytes!,
                                  fit: BoxFit.cover,
                                  gaplessPlayback: true,
                                ),
                              ),
                              Positioned(
                                left: 12,
                                right: 12,
                                bottom: 12,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          side: BorderSide(
                                            color: Colors.white.withValues(
                                              alpha: 0.35,
                                            ),
                                          ),
                                          backgroundColor: Colors.black
                                              .withValues(alpha: 0.3),
                                        ),
                                        onPressed: _pickEventImage,
                                        icon: const Icon(
                                          Icons.refresh_rounded,
                                          size: 18,
                                        ),
                                        label: const Text('Ganti'),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: const Color(
                                            0xFFFDA4AF,
                                          ),
                                          side: BorderSide(
                                            color: const Color(0xFFFDA4AF)
                                                .withValues(alpha: 0.35),
                                          ),
                                          backgroundColor: Colors.black
                                              .withValues(alpha: 0.3),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _eventImageBase64 = '';
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.delete_outline_rounded,
                                          size: 18,
                                        ),
                                        label: const Text('Hapus'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: primaryBlue.withValues(alpha: 0.14),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: _isPickingImage
                                    ? const Padding(
                                        padding: EdgeInsets.all(14),
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.4,
                                          color: Color(0xFF3B82F6),
                                        ),
                                      )
                                    : Icon(
                                        Icons.add_a_photo_outlined,
                                        color: primaryBlue,
                                      ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'Upload foto event',
                                style: TextStyle(
                                  color: titleColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: Text(
                                  'Foto akan di-crop dulu dan dibatasi ukurannya agar upload tetap ringan.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: localTextMuted,
                                    height: 1.45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 18),
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
