import 'dart:io';

import 'package:MyField/database/database_helper.dart';
import 'package:MyField/service/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:MyField/models/user_model.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  final UserModel currentUser;

  const ProfilePage({super.key, required this.currentUser});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  bool _isUploadingPhoto = false;
  String _photoUrl = '';
  int _photoRefreshKey = 0;

  String get displayFullName {
    final rawName = widget.currentUser.username.trim().isNotEmpty
        ? widget.currentUser.username.trim()
        : widget.currentUser.displayName.trim();
    if (rawName.isEmpty) return "Member";

    final source = rawName.contains('@') ? rawName.split('@').first : rawName;
    final cleaned = source.replaceAll(RegExp(r'[._-]+'), ' ').trim();
    final parts = cleaned
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .map(
          (part) => part[0].toUpperCase() + part.substring(1).toLowerCase(),
        )
        .toList();

    if (parts.isEmpty) return "Member";

    return parts.join(' ');
  }

  @override
  void initState() {
    super.initState();
    _photoUrl = widget.currentUser.photoUrl.trim();
    _photoRefreshKey = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF071A2C),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// hEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "My Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.settings, color: Colors.white),
                  ],
                ),

                SizedBox(height: 30),

                // PROFILE IMAGE
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: const Color(0xFF0E2A47),
                        backgroundImage: _buildProfileImage(),
                        child: _photoUrl.isEmpty
                            ? Text(
                                displayFullName[0],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w800,
                                ),
                              )
                            : null,
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

                SizedBox(height: 20),

                /// NAME
                Center(
                  child: Text(
                    displayFullName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 6),

                Center(
                  child: Text(
                    widget.currentUser.role == "pemilik lapangan"
                        ? "Pemilik Lapangan"
                        : "User Booking",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),

                SizedBox(height: 20),

                /// EDIT BUTTON
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: Icon(Icons.edit),
                    label: Text("Edit Profile"),
                    onPressed: () {},
                  ),
                ),

                SizedBox(height: 30),

                /// SPORTS STATS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "STATS",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "View All",
                      style: TextStyle(color: Colors.blue.shade300),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    /// MATCHES CARD
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0E2A47),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.sports_soccer, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              "100",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "LAPANGAN YANG SUDAH DIBOOKING",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// WIN RATE CARD
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFF0E2A47),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.emoji_events, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              "64%",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "WIN RATE",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 25),

                /// TOP SPORT
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF3A7BFF), Color(0xFF2A5BEA)],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.sports_soccer, color: Colors.white, size: 40),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "STATIC",
                            style: TextStyle(color: Colors.white70),
                          ),
                          Text(
                            "Minisoccer",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Striker • Avg Rating 8.4",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                /// RECENT ACTIVITY
                Text(
                  "History Lapangan",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 15),

                fungsiKolom(
                  Icons.sports_basketball,
                  "Dekings Arena",
                  "Dibooking pada 12 Jan 2024",
                  "2 jam lalu",
                  Colors.orange,
                  Image.network(
                    "https://scontent-cgk1-2.xx.fbcdn.net/v/t39.30808-1/610964674_2679999182333365_6903091626739272275_n.jpg?stp=dst-jpg_s160x160_tt6&_nc_cat=108&ccb=1-7&_nc_sid=e99d92&_nc_eui2=AeG3ffvtVTA9GRRQUyHkLEFCrZlFi7NRhLOtmUWLs1GEswZh25jZ0vyFISOGLtD9vuGRuiod-AG3b1qxJdVtzXLt&_nc_ohc=R9vTCjBGoHEQ7kNvwEgdCT1&_nc_oc=AdmY2ASZ25NvGE0k9dkgYH5v6XeecXBtt9C0f2IZoYJjp5_qOE6CjE0LWH_fd_USYrU&_nc_zt=24&_nc_ht=scontent-cgk1-2.xx&_nc_gid=aS6GJIQkkseVX1pNVJaAaA&_nc_ss=8&oh=00_Afwv7cN5mnbKEphn6B3URGRGOe30e-_-JDxyn5tXIguKFQ&oe=69B3EA63",
                  ),
                ),
                fungsiKolom(
                  Icons.sports_basketball,
                  "Lapangan Basket B",
                  "Dibooking pada 12 Jan 2024",
                  "2 jam lalu",
                  Colors.orange,
                  Image.network(
                    "https://scontent-cgk1-2.xx.fbcdn.net/v/t39.30808-1/610964674_2679999182333365_6903091626739272275_n.jpg?stp=dst-jpg_s160x160_tt6&_nc_cat=108&ccb=1-7&_nc_sid=e99d92&_nc_eui2=AeG3ffvtVTA9GRRQUyHkLEFCrZlFi7NRhLOtmUWLs1GEswZh25jZ0vyFISOGLtD9vuGRuiod-AG3b1qxJdVtzXLt&_nc_ohc=R9vTCjBGoHEQ7kNvwEgdCT1&_nc_oc=AdmY2ASZ25NvGE0k9dkgYH5v6XeecXBtt9C0f2IZoYJjp5_qOE6CjE0LWH_fd_USYrU&_nc_zt=24&_nc_ht=scontent-cgk1-2.xx&_nc_gid=aS6GJIQkkseVX1pNVJaAaA&_nc_ss=8&oh=00_Afwv7cN5mnbKEphn6B3URGRGOe30e-_-JDxyn5tXIguKFQ&oe=69B3EA63",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget fungsiKolom(
    IconData icon,
    String title,
    String subtitle,
    String time,
    Color color,
    Image imageUrl,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color(0xFF0E2A47),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.2),
            child: Icon(icon, color: color),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(subtitle, style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Text(time, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  ImageProvider? _buildProfileImage() {
    if (_photoUrl.isEmpty) return null;
    final separator = _photoUrl.contains('?') ? '&' : '?';
    return NetworkImage('$_photoUrl${separator}v=$_photoRefreshKey');
  }

  Future<void> _changeProfilePhoto() async {
    if (widget.currentUser.id == null) {
      _showMessage("User belum valid untuk upload foto");
      return;
    }

    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
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
      _showMessage("Cropper tidak berhasil dibuka, foto asli akan dipakai.");
    }

    if (!mounted) return;

    final selectedImagePath = croppedFile?.path ?? pickedFile.path;
    final imageFile = File(selectedImagePath);

    setState(() {
      _isUploadingPhoto = true;
    });

    try {
      final downloadUrl = await FirebaseService.instance.uploadProfileImage(
        userId: widget.currentUser.id!,
        file: imageFile,
      );

      await DatabaseHelper.instance.updateUserProfile(
        userId: widget.currentUser.id!,
        photoUrl: downloadUrl,
      );

      if (!mounted) return;

      setState(() {
        _photoUrl = downloadUrl;
        _photoRefreshKey = DateTime.now().millisecondsSinceEpoch;
        widget.currentUser.photoUrl = downloadUrl;
      });
      _showMessage("Foto profil berhasil diperbarui");
    } on FirebaseException catch (e) {
      if (!mounted) return;
      final message = switch (e.code) {
        'unauthorized' =>
          'Upload ditolak Firebase Storage. Aturan Storage kemungkinan masih butuh login.',
        'object-not-found' =>
          'File hasil upload tidak ditemukan di Firebase Storage.',
        'bucket-not-found' =>
          'Bucket Firebase Storage belum aktif atau nama bucket tidak cocok.',
        _ =>
          'Upload gagal: ${e.code}${e.message == null ? '' : ' - ${e.message}'}',
      };
      _showMessage(message);
    } catch (e) {
      if (!mounted) return;
      _showMessage("Upload gagal: $e");
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
