import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:MyField/database/database_helper.dart';
import 'package:MyField/models/booking_model.dart';
import 'package:MyField/models/user_model.dart';
import 'package:MyField/views/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AccountPage extends StatefulWidget {
  final UserModel currentUser;

  const AccountPage({super.key, required this.currentUser});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final ImagePicker _picker = ImagePicker();
  bool _isUploadingPhoto = false;
  bool _isLoadingBookings = true;
  String _photoUrl = '';
  List<Booking> _userBookings = [];

  String get displayFullName {
    final rawName = widget.currentUser.username.trim().isNotEmpty
        ? widget.currentUser.username.trim()
        : widget.currentUser.displayName.trim();
    if (rawName.isEmpty) return 'Member';

    final source = rawName.contains('@') ? rawName.split('@').first : rawName;
    final cleaned = source.replaceAll(RegExp(r'[._-]+'), ' ').trim();
    final parts = cleaned
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .map(
          (part) => part[0].toUpperCase() + part.substring(1).toLowerCase(),
        )
        .toList();

    if (parts.isEmpty) return 'Member';

    return parts.join(' ');
  }

  int get _totalBookings => _userBookings.length;

  int get _totalBookedHours => _userBookings.fold(
        0,
        (total, booking) => total + booking.durationHours,
      );

  String get _favoriteFieldName {
    if (_userBookings.isEmpty) return 'Belum ada booking';

    final counts = <String, int>{};
    for (final booking in _userBookings) {
      counts.update(booking.lapangan, (value) => value + 1, ifAbsent: () => 1);
    }

    final favorite = counts.entries.reduce(
      (current, next) => next.value > current.value ? next : current,
    );
    return favorite.key;
  }

  int get _favoriteFieldCount {
    if (_userBookings.isEmpty) return 0;

    final counts = <String, int>{};
    for (final booking in _userBookings) {
      counts.update(booking.lapangan, (value) => value + 1, ifAbsent: () => 1);
    }

    return counts.values.reduce((current, next) => next > current ? next : current);
  }

  @override
  void initState() {
    super.initState();
    _photoUrl = widget.currentUser.photoUrl.trim();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _isLoadingBookings = true;
    });

    await _refreshProfileFromDatabase();

    final userId = widget.currentUser.id;
    if (userId == null) {
      if (!mounted) return;
      setState(() {
        _userBookings = [];
        _isLoadingBookings = false;
      });
      return;
    }

    try {
      final bookings = await DatabaseHelper.instance.getBookingsByUser(userId);
      if (!mounted) return;
      setState(() {
        _userBookings = bookings;
        _isLoadingBookings = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _userBookings = [];
        _isLoadingBookings = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF071A2C) : const Color(0xFFF5F7FB);
    final cardColor = isDark ? const Color(0xFF0E2A47) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF102033);
    final subtitleColor = isDark ? Colors.grey : const Color(0xFF66758A);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: RefreshIndicator(
        onRefresh: _loadProfileData,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Profile',
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SettingsPage(),
                            ),
                          );
                        },
                        icon: Icon(Icons.settings, color: titleColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: const Color(0xFF0B3A66),
                          child: _buildProfileAvatarContent(120),
                        ),
                        if (_isUploadingPhoto)
                          const Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Color(0x66000000),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _isUploadingPhoto ? null : _changeProfilePhoto,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      displayFullName,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      widget.currentUser.role == 'pemilik lapangan'
                          ? 'Pemilik Lapangan'
                          : 'User Booking',
                      style: TextStyle(color: subtitleColor),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Profile'),
                      onPressed: _showEditProfileDialog,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'STATS',
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _isLoadingBookings ? 'Memuat...' : '$_totalBookings data',
                        style: TextStyle(color: Colors.blue.shade300),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          cardColor: cardColor,
                          titleColor: titleColor,
                          subtitleColor: subtitleColor,
                          icon: Icons.calendar_month_rounded,
                          value: _isLoadingBookings ? '--' : '$_totalBookings',
                          label: 'TOTAL BOOKING',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          cardColor: cardColor,
                          titleColor: titleColor,
                          subtitleColor: subtitleColor,
                          icon: Icons.timelapse_rounded,
                          value: _isLoadingBookings ? '--' : '$_totalBookedHours',
                          label: 'TOTAL JAM MAIN',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3A7BFF), Color(0xFF2A5BEA)],
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.stadium_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'LAPANGAN FAVORIT',
                                style: TextStyle(color: Colors.white70),
                              ),
                              Text(
                                _isLoadingBookings ? 'Memuat...' : _favoriteFieldName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _favoriteFieldCount == 0
                                    ? 'Belum ada riwayat booking'
                                    : '$_favoriteFieldCount kali dibooking',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'History Lapangan',
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  if (_isLoadingBookings)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (_userBookings.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Belum ada riwayat booking yang tersimpan.',
                        style: TextStyle(color: subtitleColor),
                      ),
                    )
                  else
                    ..._userBookings.take(5).map(
                          (booking) => _buildBookingHistoryCard(
                            booking: booking,
                            cardColor: cardColor,
                            titleColor: titleColor,
                            subtitleColor: subtitleColor,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required Color cardColor,
    required Color titleColor,
    required Color subtitleColor,
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: titleColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: subtitleColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingHistoryCard({
    required Booking booking,
    required Color cardColor,
    required Color titleColor,
    required Color subtitleColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.withValues(alpha: 0.16),
            child: const Icon(
              Icons.calendar_month_rounded,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.lapangan,
                  style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${booking.tanggal} • ${booking.waktu}',
                  style: TextStyle(color: subtitleColor),
                ),
              ],
            ),
          ),
          Text(
            booking.harga,
            style: TextStyle(
              color: subtitleColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatarContent(double size) {
    final imageBytes = _decodeBase64Image(_photoUrl);
    if (imageBytes != null) {
      return ClipOval(
        child: Image.memory(
          imageBytes,
          width: size,
          height: size,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          errorBuilder: (_, __, ___) => _buildAvatarFallback(),
        ),
      );
    }

    final legacyUrl = _photoUrl.trim();
    if (legacyUrl.startsWith('http://') || legacyUrl.startsWith('https://')) {
      return ClipOval(
        child: Image.network(
          legacyUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildAvatarFallback(),
        ),
      );
    }

    return _buildAvatarFallback();
  }

  Widget _buildAvatarFallback() {
    return Center(
      child: Text(
        displayFullName[0],
        style: const TextStyle(
          color: Colors.white,
          fontSize: 34,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Uint8List? _decodeBase64Image(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) return null;

    final payload = normalized.contains(',')
        ? normalized.split(',').last.trim()
        : normalized;

    try {
      return base64Decode(payload);
    } catch (_) {
      return null;
    }
  }

  Future<void> _refreshProfileFromDatabase() async {
    final userId = widget.currentUser.id;
    if (userId == null) return;

    try {
      final latestUser = await DatabaseHelper.instance.getUserById(userId);
      if (!mounted || latestUser == null) return;

      final latestPhotoUrl = latestUser.photoUrl.trim();
      final latestUsername = latestUser.username;
      if (latestPhotoUrl == _photoUrl &&
          latestUsername == widget.currentUser.username) {
        return;
      }

      setState(() {
        _photoUrl = latestPhotoUrl;
        widget.currentUser.photoUrl = latestPhotoUrl;
        widget.currentUser.username = latestUsername;
      });
    } catch (_) {
      // Keep current UI state if refresh fails.
    }
  }

  Future<void> _showEditProfileDialog() async {
    final userId = widget.currentUser.id;
    if (userId == null) {
      _showMessage('User belum valid untuk diedit');
      return;
    }

    final controller = TextEditingController(text: widget.currentUser.username);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF102033);
    final subtitleColor =
        isDark ? Colors.grey.shade400 : const Color(0xFF66758A);
    final cardColor = isDark ? const Color(0xFF0E2A47) : Colors.white;
    final inputFillColor =
        isDark ? const Color(0xFF102A44) : const Color(0xFFF1F5F9);

    final newName = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            'Edit Profile',
            style: TextStyle(
              color: titleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ubah nama profil yang ingin ditampilkan di aplikasi.',
                style: TextStyle(
                  color: subtitleColor,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                style: TextStyle(color: titleColor),
                decoration: InputDecoration(
                  hintText: 'Masukkan nama baru',
                  hintStyle: TextStyle(color: subtitleColor),
                  filled: true,
                  fillColor: inputFillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Batal',
                style: TextStyle(color: subtitleColor),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext, controller.text.trim());
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    if (!mounted || newName == null) return;

    final cleanedName = newName.trim();
    if (cleanedName.isEmpty) {
      _showMessage('Nama profil tidak boleh kosong');
      return;
    }

    if (cleanedName == widget.currentUser.username.trim()) {
      return;
    }

    try {
      await DatabaseHelper.instance.updateUserProfile(
        userId: userId,
        username: cleanedName,
      );

      if (!mounted) return;

      setState(() {
        widget.currentUser.username = cleanedName;
      });

      _showMessage('Profil berhasil diperbarui');
      await _loadProfileData();
    } catch (e) {
      if (!mounted) return;
      _showMessage('Update profil gagal: $e');
    }
  }

  Future<void> _changeProfilePhoto() async {
    if (widget.currentUser.id == null) {
      _showMessage('User belum valid untuk upload foto');
      return;
    }

    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (pickedFile == null || !mounted) return;

    CroppedFile? croppedFile;
    try {
      croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 88,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Foto Profil',
            toolbarColor: const Color(0xFF0E2A47),
            toolbarWidgetColor: Colors.white,
            backgroundColor: const Color(0xFF071A2C),
            activeControlsWidgetColor: Colors.blue,
            cropStyle: CropStyle.circle,
            hideBottomControls: false,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Foto Profil',
            cropStyle: CropStyle.circle,
            aspectRatioLockEnabled: true,
          ),
        ],
      );
    } catch (_) {
      if (!mounted) return;
      _showMessage('Cropper tidak berhasil dibuka, foto asli akan dipakai.');
    }

    if (!mounted) return;

    final selectedImagePath = croppedFile?.path ?? pickedFile.path;
    final imageFile = File(selectedImagePath);

    setState(() {
      _isUploadingPhoto = true;
    });

    try {
      final imageBytes = await imageFile.readAsBytes();
      final encodedImage = base64Encode(imageBytes);

      if (encodedImage.length > 700000) {
        throw Exception(
          'Ukuran foto masih terlalu besar. Coba pilih foto lain yang lebih kecil.',
        );
      }

      await DatabaseHelper.instance.updateUserProfile(
        userId: widget.currentUser.id!,
        photoUrl: encodedImage,
      );

      if (!mounted) return;

      setState(() {
        _photoUrl = encodedImage;
        widget.currentUser.photoUrl = encodedImage;
      });
      await _loadProfileData();
      _showMessage('Foto profil berhasil diperbarui');
    } catch (e) {
      if (!mounted) return;
      _showMessage('Upload gagal: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingPhoto = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

