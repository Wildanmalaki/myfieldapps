import 'package:MyField/database/database_helper.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

/// Halaman pendaftaran user baru.
class PendaftaranUser extends StatefulWidget {
  const PendaftaranUser({super.key});

  @override
  State<PendaftaranUser> createState() => _PendaftaranUserState();
}

/// State form registrasi user.
class _PendaftaranUserState extends State<PendaftaranUser> {
  final Color bgColor = const Color(0xFFF4F7FB);
  final Color cardColor = Colors.white;
  final Color accentColor = const Color(0xFF1D4ED8);
  final Color accentSoft = const Color(0xFFE0EAFF);
  final Color mutedText = const Color(0xFF5B6B82);
  final Color titleColor = const Color(0xFF0F172A);

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String selectedRole = 'user booking';

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void daftarUser() async {
    final String username = usernameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field harus diisi")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password tidak sama")),
      );
      return;
    }

    final existingUser = await DatabaseHelper.instance.getUserByEmail(email);
    if (!mounted) return;

    if (existingUser != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email sudah terdaftar")),
      );
      return;
    }

    final user = UserModel(
      username: username,
      email: email,
      password: password,
      role: selectedRole,
    );

    await DatabaseHelper.instance.insertUser(user);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Pendaftaran berhasil")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: -70,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: accentSoft,
                borderRadius: BorderRadius.circular(110),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: -80,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                color: const Color(0xFFD6E4FF),
                borderRadius: BorderRadius.circular(115),
              ),
            ),
          ),
          Container(
            height: size.height * 0.32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accentColor,
                  const Color(0xFF0F3FB8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        "Buat akun baru\ndan mulai sekarang.",
                        style: TextStyle(
                          fontSize: 30,
                          height: 1.15,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Daftar sebagai pemain atau pemilik lapangan, lalu kelola semuanya dari satu aplikasi.",
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1A0F172A),
                              blurRadius: 40,
                              offset: Offset(0, 18),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Daftar",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Lengkapi informasi akun kamu di bawah ini.",
                              style: TextStyle(
                                fontSize: 14,
                                color: mutedText,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 22),
                            TextField(
                              controller: usernameController,
                              style: TextStyle(color: titleColor),
                              decoration: _inputDecoration(
                                label: "Username",
                                hint: "Nama pengguna kamu",
                                icon: Icons.person_outline_rounded,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: emailController,
                              style: TextStyle(color: titleColor),
                              keyboardType: TextInputType.emailAddress,
                              decoration: _inputDecoration(
                                label: "Email",
                                hint: "nama@email.com",
                                icon: Icons.alternate_email_rounded,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: passwordController,
                              obscureText: true,
                              style: TextStyle(color: titleColor),
                              decoration: _inputDecoration(
                                label: "Password",
                                hint: "Masukkan password",
                                icon: Icons.lock_outline_rounded,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: confirmPasswordController,
                              obscureText: true,
                              style: TextStyle(color: titleColor),
                              decoration: _inputDecoration(
                                label: "Konfirmasi Password",
                                hint: "Ulangi password",
                                icon: Icons.verified_user_outlined,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Daftar Sebagai",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: mutedText,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildRoleOption(
                              label: "User Booking",
                              subtitle: "Cari lawan main dan booking lapangan",
                              value: "user booking",
                              icon: Icons.sports_soccer_rounded,
                            ),
                            const SizedBox(height: 10),
                            _buildRoleOption(
                              label: "Pemilik Lapangan",
                              subtitle: "Kelola venue, jadwal, dan reservasi",
                              value: "pemilik lapangan",
                              icon: Icons.storefront_outlined,
                            ),
                            const SizedBox(height: 22),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentColor,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 17,
                                  ),
                                ),
                                onPressed: daftarUser,
                                child: const Text(
                                  "Buat Akun",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: mutedText,
                                fontSize: 14,
                                fontFamily: 'Roboto',
                              ),
                              children: [
                                const TextSpan(text: "Sudah punya akun? "),
                                TextSpan(
                                  text: "Masuk",
                                  style: TextStyle(
                                    color: accentColor,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: mutedText),
      hintStyle: TextStyle(color: mutedText.withValues(alpha: 0.75)),
      prefixIcon: Icon(icon, color: mutedText),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Color(0xFFD9E2F1),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: accentColor, width: 1.4),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }

  Widget _buildRoleOption({
    required String label,
    required String subtitle,
    required String value,
    required IconData icon,
  }) {
    final isSelected = selectedRole == value;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        setState(() {
          selectedRole = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFEFF4FF)
              : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? accentColor
                : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? accentColor : mutedText,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: mutedText,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    color: accentColor,
                    size: 20,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
